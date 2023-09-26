#!/usr/bin/env bash

# Remove distribution-related packages (if present) that would be harmful if kept installed.
sudo apt remove docker docker-engine docker.io containerd runc

# Update apt repositories
sudo apt update

# Add required dependencies
sudo apt install -y \
  lsb-release \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent

# ID of current running OS, lowercase
OS_ID=$(lsb_release -is)
OS_ID=${OS_ID,,}
OS_CN=$(lsb_release -cs)

# Add the official docker repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/${OS_ID}/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${OS_ID} \
  ${OS_CN} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh repositories
sudo apt update

# Install docker-ce from docker repository
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create 'docker' group
sudo groupadd docker

# Add the group 'docker' to your user
sudo usermod -aG docker ${USER}
