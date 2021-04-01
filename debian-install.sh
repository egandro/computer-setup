#!/bin/bash
set -x

DEBIAN_USER=$(ls /home)
IS_RASPBERRY=$(grep Pi /proc/device-tree/model 2>/dev/null && echo 1)

apt-get update
apt-get -y dist-upgrade
apt install -y wget curl gpg build-essential dkms
apt install -y  p7zip-full

if [ -z "$IS_RASPBERRY" ]
then
  apt install -y linux-headers-$(uname -r)
fi

###################################################################
# vbox driver
###################################################################

apt install -y dmidecode || echo ""
VBOX_VERSION=$(dmidecode  | grep vboxVer | sed -e 's/.*vboxVer_//')

if [ !  -z "$VBOX_VERSION" ]
then
  wget -c -t0 https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso

  rm -rf vbox
  mkdir -p vbox
  cd vbox
  7z x ../VBoxGuestAdditions_${VBOX_VERSION}.iso
  chmod 755 VBoxLinuxAdditions.run
  ./VBoxLinuxAdditions.run

  cd ..
  rm -rf VBoxGuestAdditions_${VBOX_VERSION}.iso vbox
fi

###################################################################
# nodejs
###################################################################

curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
apt-get install -y nodejs
# pi has installed node - remove old stuff
apt autoremove -y

# yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update
apt install yarn

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

if [ -z "$IS_RASPBERRY" ]
then
  wget -t0 -c  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  apt install -y ./google-chrome-stable_current_amd64.deb
  apt --fix-broken install -y
  rm -f ./google-chrome-stable_current_amd64.deb
fi

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
  "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null
 
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

usermod -a -G docker ${DEBIAN_USER}

if [ -z "$IS_RASPBERRY" ]
then
  curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
#else
#this takes for ever to install on pi.
#pip3 install docker-compose
fi

if [ -z "$IS_RASPBERRY" ]
then
   curl -Lo /usr/local/bin/kind "https://kind.sigs.k8s.io/dl/v0.10.0/kind-$(uname)-amd64"
   chmod +x /usr/local/bin/kind
fi

###################################################################
# Tools
###################################################################

# Install dig tool for DNS querying
apt install -y dnsutils

# Install our version control systems
apt install -y git subversion

# Install ifconfig
apt install -y net-tools

# Install mc
apt install -y mc

# Install screen
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
VIM_VERSION=$(apt list vim 2>&1 | grep vim  | sed -e 's/.*://g' | sed -e 's/\.//' | sed -e 's/\..*//')
echo "if has('mouse')" >> /usr/share/vim/vim${VIM_VERSION}/defaults.vim
echo "   set mouse=r" >> /usr/share/vim/vim${VIM_VERSION}/defaults.vim
echo "endif" >> /usr/share/vim/vim${VIM_VERSION}/defaults.vim
echo "set background=dark" >> /usr/share/vim/vim${VIM_VERSION}/defaults.vim

###################################################################
# sudo
###################################################################

apt install -y sudo

usermod -aG sudo ${DEBIAN_USER}  || echo ""

###################################################################
# cleanup
###################################################################

apt autoremove -y
