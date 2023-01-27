#!/bin/bash
set -x

IS_RASPBERRY=$(grep Pi /proc/device-tree/model 2>/dev/null && echo 1)
if [ -z "$IS_RASPBERRY" ]
then
  DEBIAN_USER=$(ls /home)
else
  DEBIAN_USER=pi
fi

apt-get update
apt-get -y dist-upgrade
apt install -y wget curl gpg build-essential dkms mc
apt install -y p7zip-full

if [ -z "$IS_RASPBERRY" ]
then
  apt install -y linux-headers-$(uname -r)
fi

apt install -y dmidecode || echo ""

# add to sudo group
if [ -z "$IS_RASPBERRY" ]
then
  usermod -a -G sudo ${DEBIAN_USER}
fi

###################################################################
# vbox driver
###################################################################

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
# vmware opensource driver
###################################################################

IS_VMWARE=$(dmidecode  | grep VMware)

if [ !  -z "$IS_VMWARE" ]
then
  apt install -y open-vm-tools
  if type Xorg 2>/dev/null; then
    # we have an UI installed
    apt install -y open-vm-tools-desktop 
  fi
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

if type Xorg 2>/dev/null; then
  # we have an UI installed
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm packages.microsoft.gpg

  apt install -y apt-transport-https
  apt update
  apt install -y code gnome-keyring
fi

###################################################################
# Chrome
###################################################################

if [ -z "$IS_RASPBERRY" ]
then
  if type Xorg 2>/dev/null; then
    # we have an UI installed
    wget -t0 -c  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt install -y ./google-chrome-stable_current_amd64.deb
    apt --fix-broken install -y
    rm -f ./google-chrome-stable_current_amd64.deb
  fi
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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

usermod -a -G docker ${DEBIAN_USER}

###################################################################
# CLI Tools
###################################################################

# Install dig tool for DNS querying
apt install -y dnsutils

# Install our version control systems
apt install -y git subversion

# Install ifconfig
apt install -y net-tools

# Install zsh
apt install -y zsh fzf

# Install tmux
apt install -y tmux

cat << EOF > /home/${DEBIAN_USER}/.zprofile
emulate sh
. ~/.profile
emulate zsh
EOF
chown ${DEBIAN_USER}:${DEBIAN_USER} /home/${DEBIAN_USER}/.zprofile

cat << EOF > $HOME/${DEBIAN_USER}/.tmux.conf 
set -g bell-action any
set -g visual-bell on
set -g visual-activity on
EOF

chown ${DEBIAN_USER}:${DEBIAN_USER} $HOME/${DEBIAN_USER}/.tmux.conf

# Install oh my zsh
su - ${DEBIAN_USER} /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install htop
apt install -y htop

# Install zip
apt install -y zip unzip

# Install killall & co
apt install -y psmisc

# Exfat support
apt-get install -y exfat-fuse exfat-utils

###################################################################
# Vim
###################################################################

apt install -y vim

# Set vim as default editor
su - ${DEBIAN_USER} /bin/bash -c "echo 'export EDITOR=vim' >> /home/${DEBIAN_USER}/.bashrc"
su - ${DEBIAN_USER} /bin/bash -c "echo 3 | update-alternatives --config editor"


# fix mouse

# (FUCK! debian!)
VIM_VERSION=$(apt list vim 2>&1 | tail -1 | grep vim  | sed -e 's/.*://g' | sed -e 's/\.//' | sed -e 's/\..*//' | sed -e 's/ .*$//g')
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
# locales
###################################################################
locals=(
"en_DK ISO-8859-1"
"en_DK.ISO-8859-15 ISO-8859-15"
"en_DK.UTF-8 UTF-8"
"de_DE.UTF-8 UTF-8"
"de_DE ISO-8859-1"
"de_DE@euro ISO-8859-15"
"en_US.UTF-8 UTF-8"
"da_DK ISO-8859-1"
"da_DK.UTF-8 UTF-8"
)

for l in "${locals[@]}"
do :
        #echo $l
        l=$(echo $l | sed -e 's/\./\\./g')
        #echo $l
        #echo "s/# ${l}/${l}/g"
        sed -i "s/# ${l}/${l}/g" /etc/locale.gen
done

locale-gen

apt-get install -y exfat-fuse
apt-get install -y exfat-utils

###################################################################
# cleanup
###################################################################

apt autoremove -y


echo "On debian you need to reboot for the VBox Tools to be present."

echo "Setup Git:"
echo git config --global user.name "Your Name"
echo git config --global user.email "youremail@yourdomain.com"
echo git config --global credential.helper cache


echo "Set timezone:"
echo "sudo timedatectl set-timezone Europe/Berlin"

# https://lanbugs.de/howtos/linux-tipps-tricks/tmux-die-screen-alternative/#

echo "Setup tmux: in $HOME/.zshrc"
echo 'if [[ -z "$TMUX" ]] && [[ -z "$VSCODE_GIT_ASKPASS_MAIN" ]] && [ "$SSH_CONNECTION" != "" ]; then'
echo '    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux'
echo 'fi'

# https://unix.stackexchange.com/questions/537637/sshing-into-system-with-zsh-as-default-shell-doesnt-run-etc-profile
echo "Source /etc/profile.d/*.sh in zsh"
echo "emulate sh -c 'source /etc/profile.d/*.sh'"



#
# python version (Debian 11 finally gave us Python 3.9 as default)
#
## update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2

