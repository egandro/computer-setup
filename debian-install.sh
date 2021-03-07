#!/bin/bash
set -x

DEBIAN_USER=$(ls /home)

###################################################################
# vbox driver
###################################################################

apt update
apt install -y dmidecode
VBOX_VERSION=$(dmidecode  | grep vboxVer | sed -e 's/.*vboxVer_//')
apt install -y wget curl gpg build-essential dkms linux-headers-$(uname -r)

apt install -y  p7zip-full

wget -c -t0 https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso

rm -rf vbox
mkdir -p vbox
cd vbox
7z x ../VBoxGuestAdditions_${VBOX_VERSION}.iso
chmod 755 VBoxLinuxAdditions.run
./VBoxLinuxAdditions.run
cd ..
rm -rf VBoxGuestAdditions_${VBOX_VERSION}.iso vbox


###################################################################
# nodejs
###################################################################

curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
apt-get install -y nodejs


###################################################################
# visual studio code
###################################################################

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm packages.microsoft.gpg

apt install apt-transport-https
apt update
apt install code 

###################################################################
# Chrome
###################################################################

wget -t0 -c  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
apt --fix-broken install -y
rm -f ./google-chrome-stable_current_amd64.deb


###################################################################
# Docker
###################################################################

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null
  
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

usermod -a -G docker ${DEBIAN_USER}

###################################################################
# Tools
###################################################################

# Install dig tool for DNS querying
apt install -y dnsutils

# Install our version control systems
apt install -y git subversion

# Install ifconfig
apt install -y net-tools

# Install imc
apt install -y mc

# Install imc
apt install -y screen


###################################################################
# Vim
###################################################################

apt install -y vim

# Set vim as default editor
su - ${DEBIAN_USER} /bin/bash -c "echo 'export EDITOR=vim' >> /home/${DEBIAN_USER}/.bashrc"
su - ${DEBIAN_USER} /bin/bash -c "echo 3 | update-alternatives --config editor"


# fix mouse

# (FUCK! debian!)
echo "if has('mouse')" >> /usr/share/vim/vim81/defaults.vim
echo "   set mouse=r" >> /usr/share/vim/vim81/defaults.vim
echo "endif" >> /usr/share/vim/vim81/defaults.vim


###################################################################
# sudo
###################################################################

apt install -y sudo

usermod -aG sudo ${DEBIAN_USER}

