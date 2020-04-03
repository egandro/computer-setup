#!/bin/bash
DOCKER_COMPOSE_VERSION=1.26.0-rc3
DOCKER_MACHINE_VERSION=v0.16.2
HETZNER_MACHINE_DRIVER_VERSION=2.1.0
apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
base=https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
install /tmp/docker-machine /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
rm /tmp/docker-machine
wget https://github.com/JonasProgrammer/docker-machine-driver-hetzner/releases/download/${HETZNER_MACHINE_DRIVER_VERSION}/docker-machine-driver-hetzner_${HETZNER_MACHINE_DRIVER_VERSION}_linux_amd64.tar.gz
tar -xvf docker-machine-driver-hetzner_${HETZNER_MACHINE_DRIVER_VERSION}_linux_amd64.tar.gz
chmod +x docker-machine-driver-hetzner
mv docker-machine-driver-hetzner /usr/local/bin/
rm docker-machine-driver-hetzner_${HETZNER_MACHINE_DRIVER_VERSION}_linux_amd64.tar.gz
