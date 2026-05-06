#!/usr/bin/env bash
#
# --------------------------------------------------------------------------------------------------
# restore-docker-gitlab-vault.sh — Restore a Gitlab Docker instance from config and backup archives.
# Usage: restore-docker-gitlab-vault.sh <gitlab_config> <gitlab_backup>
# --------------------------------------------------------------------------------------------------
#
# Follow up:
# - Check you own R/W permissions on all needed files and current folder.
# 
# - Fill env variables needed by compose YAML
# . ./populate-gitlab-env.sh
#
# - Start Gitlab:
# docker compose up [-d]
#
# - Wait GitLab is up (~2-3 min)
# watch -n 10 docker exec -it gitlab gitlab-ctl status
#
# - Restore all data and config
# restore-docker-gitlab-vault.sh ./gitlab_config_1775051616_2026_04_01.tar.bz2 ./1775051631_2026_04_01_18.4.2_gitlab_backup.tar

set -aeu -o pipefail

decompress_to_tar() {
    local input="$1"
    local output

    [[ -f "${input}" ]] || { echo "ERROR: file not found: ${input}"; return 1; }

    # Strip the compression extension to get the .tar output path
    case "${input}" in
        *.tar)     output=${input}
         ;;
        *.tgz)     output="${input%.tgz}.tar"
         ;;
        *.tar.gz)  output="${input%.tar.gz}.tar"
         ;;
        *.tar.bz2) output="${input%.tar.bz2}.tar"
         ;;
        *) echo "ERROR: unsupported archive format: ${input}"; return 1 ;;
    esac

    # Decompress on the fly and write raw tar stream to output file
    case "${input}" in
        *.tar.gz|*.tgz) gunzip  -c "${input}" > "${output}"
         ;;
        *.tar.bz2)      bunzip2 -c "${input}" > "${output}"
         ;;
    esac

    echo "${output}"
}

GITLAB_ENV_SOURCE="populate-gitlab-env.sh"
if [[ ! -f "${GITLAB_ENV_SOURCE}" ]] ; then
    echo "ERROR: No '${GITLAB_ENV_SOURCE}' found in current directory."
    exit 1
fi
. ./"${GITLAB_ENV_SOURCE}"
env | grep GITLAB

CONFIG_ARCHIVE="${1:-}"
BACKUP_ARCHIVE="${2:-}"

if [[ -z "${CONFIG_ARCHIVE}" || -z "${BACKUP_ARCHIVE}" ]] ; then
    echo "Usage: ${BASH_SOURCE} <gitlab_config> <gitlab_backup>"
    exit 1
fi

[[ -f "${CONFIG_ARCHIVE}" ]] || { echo "ERROR: File not found: ${CONFIG_ARCHIVE}"; exit 1; }
CONFIG_ARCHIVE="$(decompress_to_tar "${CONFIG_ARCHIVE}")"
CONFIG_ARCHIVE="$(realpath "${CONFIG_ARCHIVE}")"
echo "Using config archive '${CONFIG_ARCHIVE}'"

[[ -f "${BACKUP_ARCHIVE}" ]] || { echo "ERROR: File not found: ${BACKUP_ARCHIVE}"; exit 1; }
BACKUP_ARCHIVE="$(decompress_to_tar "${BACKUP_ARCHIVE}")"
BACKUP_ARCHIVE="$(realpath "${BACKUP_ARCHIVE}")"
echo "Using backup archive '${BACKUP_ARCHIVE}'"

if [[ ! -f "docker-compose.yml" ]] ; then
    echo "ERROR: No 'docker-compose.yml' found in current directory."
    exit 1
fi

COMPOSE_FILE=$(ls -1 docker-compose.yml | head -1)

# --- Detect container name ---
CONTAINER_NAME=$(docker compose -f "${COMPOSE_FILE}" ps --format '{{.Name}}' 2>/dev/null | grep -i gitlab | head -1)
[[ -n "${CONTAINER_NAME}" ]] || { echo "ERROR: No running GitLab container found."; exit 1; }
echo "Using container: ${CONTAINER_NAME}"

# --- Detect config and data volume paths ---
CONFIG_PATH=$(docker inspect "${CONTAINER_NAME}" \
    --format '{{range .Mounts}}{{if eq .Destination "/etc/gitlab"}}{{.Source}}{{end}}{{end}}')
DATA_PATH=$(docker inspect "${CONTAINER_NAME}" \
    --format '{{range .Mounts}}{{if eq .Destination "/var/opt/gitlab"}}{{.Source}}{{end}}{{end}}')

[[ -n "${CONFIG_PATH}" ]] || { echo "ERROR: Cannot find volume mapped to '/etc/gitlab'."; exit 1; }
[[ -n "${DATA_PATH}"   ]] || { echo "ERROR: Cannot find volume mapped to '/var/opt/gitlab'."; exit 1; }
echo "Config volume : ${CONFIG_PATH}"
echo "Data volume   : ${DATA_PATH}"

# --- Check 'gitlab-secrets.json' is present in the config archive ---
if ! tar -tf "${CONFIG_ARCHIVE}" 2>/dev/null | grep -q "gitlab-secrets.json"; then
    echo "ERROR: 'gitlab-secrets.json' not found in ${CONFIG_ARCHIVE} — aborting."
    exit 1
else
    echo "'gitlab-secrets.json' found OK."
fi

# --- Check Gitlab version consistency ---
BACKUP_VERSION="$(echo "${BACKUP_ARCHIVE}" | cut -d "_" -f 5)"
echo "Backup is from Gitlab ${BACKUP_VERSION}"
RUNNING_VERSION=$(docker exec "${CONTAINER_NAME}" gitlab-rake gitlab:env:info 2>/dev/null | grep '^Version' | grep -oP '[\d.]+' || true)
echo "Running instance of Gitlab is ${RUNNING_VERSION}"

if [[ -n "${BACKUP_VERSION}" && -n "${RUNNING_VERSION}" ]]; then
    if [[ ! "${RUNNING_VERSION}" == *"${BACKUP_VERSION}"* ]]; then
        echo "ERROR: Backup version (${BACKUP_VERSION}) differs from running GitLab (${RUNNING_VERSION})."
        exit 1
    fi
else
    echo "ERROR: Could not compare running and backup versions of Gitlab"
    exit 1
fi

# --- Restore config (overwrites existing) ---
echo "Restoring config archive to ${CONFIG_PATH} ..."
mkdir -p "${CONFIG_PATH}"
sudo tar -xvf "${CONFIG_ARCHIVE}" -C "${CONFIG_PATH}" --strip-components=2 --overwrite
sudo chown -R 998:998 "${CONFIG_PATH}"

# --- Copy backup file into the backups directory ---
BACKUP_DIR="${DATA_PATH}/backups"
mkdir -p "${BACKUP_DIR}"
BACKUP_FILENAME="$(basename "${BACKUP_ARCHIVE}")"
sudo cp "${BACKUP_ARCHIVE}" "${BACKUP_DIR}/${BACKUP_FILENAME}"

# Fix ownership so GitLab can read the file (git user = uid 998 in official image)
sudo chown 998:998 "${BACKUP_DIR}/${BACKUP_FILENAME}" 2>/dev/null || echo "WARNING: Could not chown backup file ..."

# Extract backup timestamp
# (format: EPOCH_YYYY_MM_DD_VERSION_gitlab_backup.tar)
BACKUP_TIMESTAMP="$(echo $(basename "${BACKUP_ARCHIVE}") | cut -d "_" -f 1-5)"
[[ -n "${BACKUP_TIMESTAMP}" ]] || { echo "ERROR: Cannot get timestamp from : ${BACKUP_FILENAME}"; exit 1; }
echo "Backup timestamp is ${BACKUP_TIMESTAMP}"

# --- Stop ---
echo "STOPPING 'puma' and 'sidekiq' ..."
docker exec "${CONTAINER_NAME}" gitlab-ctl stop puma
docker exec "${CONTAINER_NAME}" gitlab-ctl stop sidekiq

# --- Restore ---
echo "Running 'gitlab-backup' RESTORE CMD ..."
docker exec "${CONTAINER_NAME}" ls -al "/var/opt/gitlab/backups"
docker exec -e GITLAB_ASSUME_YES=1 "${CONTAINER_NAME}" gitlab-backup restore BACKUP="${BACKUP_TIMESTAMP}"

# --- Reconfigure ---
echo "RECONFIGURING Gitlab ..."
docker exec "${CONTAINER_NAME}" gitlab-ctl reconfigure

# --- Restart ---
echo "RESTARTING Gitlab ..."
docker exec "${CONTAINER_NAME}" gitlab-ctl restart

# --- Sanity check ---
echo "Running 'gitlab:check' ..."
docker exec "${CONTAINER_NAME}" gitlab-rake gitlab:check SANITIZE=true

echo ""
echo "RESTORE COMPLETE. REVIEW ANY WARNINGS ABOVE."
echo ""
