#!/usr/bin/env bash
set -ex

# Docker Installation - Common for all environments
echo "=== Installing Docker CE ==="

# Update package list and install prerequisites
apt-get update
apt-get install -y ca-certificates curl

# Add Docker GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
# For Kali, use Ubuntu focal as the codename since Docker doesn't have kali-rolling repo
# For Noble, explicitly use noble codename
if grep -q "ID=kali" /etc/os-release; then
    DOCKER_CODENAME="focal"
elif grep -q "VERSION_CODENAME=noble" /etc/os-release; then
    DOCKER_CODENAME="noble"
else
    DOCKER_CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $DOCKER_CODENAME stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list with Docker repo
apt-get update

# Install Docker packages
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Docker CE Installation Complete ==="
