# Stop docker
sudo systemctl stop docker.service docker.socket

# Move files to new directory
sudo mv /var/lib/docker /home/docker

# Configure docker to use /home/docker as root directory
sudo bash -c 'echo -e "{\n\t\"data-root\": \"/home/docker\"\n}" > /etc/docker/daemon.json'

# Start docker service
sudo systemctl start docker

# Check that new root directory is well configured
docker info | grep "Docker Root Dir:"
