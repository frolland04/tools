# Remove distribution-related packages if present
sudo apt remove docker docker-engine docker.io containerd runc

# Update apt repositories
sudo apt update

# Required dependencies
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add the official docker repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh repositories
sudo apt update

# Install docker-ce from docker repository
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create 'docker' group
sudo groupadd docker

# Add the group 'docker' to your user
sudo usermod -aG docker ${USER}

# Reload group 'docker'
newgrp docker

# Check that it works, whitout sudo !
docker run hello-world

# If it doesn't work, try
sudo su - ${USER}

# Log-out / log-in if it still doesn't work
