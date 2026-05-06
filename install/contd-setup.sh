#!/bin/bash

set -aeu -o pipefail

# Stop contd
systemctl stop containerd.service

# Move files to new directory
CONTD_OLD_ROOT="/var/lib/containerd"
CONTD_DATA_ROOT=/home/test/contd
mkdir -p "${CONTD_DATA_ROOT}"
mv "${CONTD_OLD_ROOT}" "${CONTD_DATA_ROOT}"
chown -R root:root "${CONTD_DATA_ROOT}"

# Configure contd to use the new data root directory
CONTD_CONFIG_FILE="/etc/containerd/config.toml"
containerd config default > "${CONTD_CONFIG_FILE}"
sed -i "s%root = '${CONTD_OLD_ROOT}'%root = '${CONTD_DATA_ROOT}'%" "${CONTD_CONFIG_FILE}"
grep "root = " "${CONTD_CONFIG_FILE}"

# Start contd service
systemctl start containerd.service
