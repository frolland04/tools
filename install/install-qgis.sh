#!/bin/bash

apt update
apt install -y ca-certificates gnupg wget software-properties-common lsb-release
KEYRING_DIR="/usr/share/keyrings"
KEYFILE_GPG="qgis-archive-keyring.gpg"

mkdir -m755 -p "${KEYRING_DIR}"
wget --inet4-only -O "${KEYRING_DIR}/${KEYFILE_GPG}" "https://download.qgis.org/downloads/${KEYFILE_GPG}"

cat << EOF > /etc/apt/sources.list.d/qgis.sources
Types: deb deb-src
URIs: https://qgis.org/debian
Suites: $(lsb_release -cs)
Architectures: amd64
Components: main
Signed-By: ${KEYRING_DIR}/${KEYFILE_GPG}
EOF

apt update && \
apt install -y qgis qgis-plugin-grass
