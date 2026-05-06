#!/bin/bash

set -aeu -o pipefail

# Stop docker
systemctl stop docker.service docker.socket

# Move files to new directory
DOCKER_OLD_ROOT="/var/lib/docker"
DOCKER_DATA_ROOT=/home/test/docker
mkdir -p "${DOCKER_DATA_ROOT}"
mv "${DOCKER_OLD_ROOT}" "${DOCKER_DATA_ROOT}"
chown -R root:root "${DOCKER_DATA_ROOT}"

# Configure docker to use the new data root directory
DOCKER_CONFIG_FILE="/etc/docker/daemon.json"
bash -c 'echo -e "{\n\t\"data-root\": \"${DOCKER_DATA_ROOT}\"\n}" > ${DOCKER_CONFIG_FILE}'

# Start docker service
systemctl start docker

# Check that new root directory is well configured
docker info | grep "Docker Root Dir:"
