#!/bin/bash

apt update
apt install -y ca-certificates curl gnupg
KEYRING_DIR="/usr/share/keyrings"
KEYFILE="microsoft.asc"
KEYFILE_GPG="${KEYRING_DIR}/microsoft.gpg"
URL_ROOT="https://packages.microsoft.com"

install -d -m 0755 "${KEYRING_DIR}"
curl -fsSL "${URL_ROOT}/keys/${KEYFILE}" | gpg --dearmor | tee "${KEYFILE_GPG}" > /dev/null
chmod 755 "${KEYFILE_GPG}"
echo "deb [arch=amd64 signed-by=${KEYFILE_GPG}] ${URL_ROOT}/repos/edge stable main" | tee /etc/apt/sources.list.d/microsoft-edge-stable.list > /dev/null
apt update
apt install -y microsoft-edge-stable
rm -f /etc/apt/sources.list.d/microsoft-edge.list
