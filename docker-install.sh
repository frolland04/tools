#!/usr/bin/env bash

set -aeux -o pipefail

# Remove distribution-related packages (if present) that would be harmful if kept installed.
for pkg in docker docker-engine docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc
do
    echo ${pkg}
    installed=$(apt list ${pkg} 2>/dev/null | grep installed | wc -l || true)
    if [[ ${installed} -ge 1 ]] ; then
        echo "Removing ${pkg}"
        sudo apt remove ${pkg}
    fi
done

# Update apt repositories
sudo apt update || true

# Add required dependencies
sudo apt install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent

# IDs of current running OS, lowercase
OS_DISTRIB_ID=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
OS_CODENAME=$(lsb_release -cs)

# Add the official docker repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/${OS_DISTRIB_ID}/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${OS_DISTRIB_ID} \
  ${OS_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh repositories
sudo apt update || true

# Install docker-ce from docker repository
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create 'docker' group
sudo groupadd docker || true

# Add the group 'docker' to your user
sudo usermod -aG docker ${USER}

set +x
echo "**************************** Finished. *****************************"
echo "Please logout, then login back, to ensure 'docker' group membership."
