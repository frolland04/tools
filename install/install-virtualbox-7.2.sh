#!/bin/bash

apt update
apt install -y lsb-release gpg wget
DISTRIB=$(lsb_release -cs)
KEYRING_DIR="/usr/share/keyrings"
KEYFILE="oracle_vbox_2016.asc"
KEYFILE_GPG="${KEYRING_DIR}/oracle-virtualbox-2016.gpg"

mkdir -m755 -p "${KEYRING_DIR}"
wget -O- https://www.virtualbox.org/download/${KEYFILE} | gpg --yes --output ${KEYFILE_GPG} --dearmor && \
echo "deb [arch=amd64 signed-by=${KEYFILE_GPG}] https://download.virtualbox.org/virtualbox/debian ${DISTRIB} contrib" > "/etc/apt/sources.list.d/download_virtualbox_linux_debian.list" && \
apt-get update && \
apt-get install -y virtualbox-7.2
