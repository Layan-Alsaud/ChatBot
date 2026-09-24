#!/usr/bin/env bash
# Installs Docker Engine + the Docker Compose plugin on Ubuntu 24.04.
# Run this ON THE VM after SSHing in:
#   chmod +x installDocker.sh && ./installDocker.sh
set -euo pipefail

echo "==> Updating apt and installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

echo "==> Adding Docker's official GPG key and repo..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Installing Docker Engine + Compose plugin..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Adding $(whoami) to the docker group..."
sudo usermod -aG docker "$(whoami)"

echo "==> Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo ""
echo "Docker installed. IMPORTANT: exit this SSH session and SSH back in"
echo "so your group membership (docker) takes effect, then verify with:"
echo "    docker run hello-world"
