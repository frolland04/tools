#!/bin/bash

set -aeu -o pipefail

# This is a *host* folder,
# bind-mounted into the container :
BACKUP_FOLDER_HOST=/backups/${HOSTNAME}/gitlab

# Final destination of backup files
# within the container :
BACKUP_FOLDER_BINDMOUNT=/backups/gitlab

# Gitlab backups its configuration in this folder
# within the container :
GITLAB_BACKUP_CONFIG_DIR=/etc/gitlab/config_backup

# Gitlab backups its data in this folder
# within the container :
GITLAB_BACKUP_DATA_DIR=/var/opt/gitlab/backups

docker exec -it gitlab /bin/sh \
            -c "gitlab-ctl backup-etc && mv ${GITLAB_BACKUP_CONFIG_DIR}/* ${BACKUP_FOLDER_BINDMOUNT}" && \
docker exec -it gitlab /bin/sh \
            -c "gitlab-backup create && mv ${GITLAB_BACKUP_DATA_DIR}/* ${BACKUP_FOLDER_BINDMOUNT}" && \
cd ${BACKUP_FOLDER_HOST} && \
sudo bzip2 --best gitlab_config*.tar
sudo chown -R test:test ${BACKUP_FOLDER_HOST}
ls -alh ${BACKUP_FOLDER_HOST}
echo "Finished."
