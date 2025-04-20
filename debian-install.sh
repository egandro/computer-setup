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
# vmware opensource driver ... good bye!
###################################################################

# IS_VMWARE=$(dmidecode  | grep VMware)

# if [ !  -z "$IS_VMWARE" ]
# then
#   apt install -y open-vm-tools
#   if type Xorg 2>/dev/null; then
#     # we have an UI installed
#     apt install -y open-vm-tools-desktop 
#   fi
# fi

###################################################################
# qemu drivers
###################################################################

IS_QEMU=$(lscpu | grep Hypervisor | grep KVM 2>/dev/null && echo 1)

if [ !  -z "$IS_QEMU" ]
then
  apt install -y open-vm-tools
  if type Xorg 2>/dev/null; then
    # we have an UI installed
    apt install -y qemu-guest-agent
    systemctl enable qemu-guest-agent || true
    systemctl start qemu-guest-agent || true
  fi
fi

###################################################################
# nodejs
###################################################################

apt-get update
#apt-get install -y ca-certificates curl gnupg
#mkdir -p /etc/apt/keyrings
#curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
#NODE_MAJOR=20
#echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
#apt-get update
#apt-get install nodejs -y

apt-get install -y curl
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
bash ./&nodesource_setup.sh
rm -f nodesource_setup.sh
apt-get update
apt-get install nodejs -y


# pi has installed node - remove old stuff
apt autoremove -y

# yarn
# curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# apt update
# apt install yarn
npm install -g yarn

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

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
 
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
apt install -y zsh fzf autojump

# Install tmux
apt install -y tmux

# Install jq
apt install -y jq

# Install xsel
apt install -y xsel

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


# fix mouse (fuck debian!)

cat <<EOF >> /etc/vim/vimrc.local
augroup system_mouse_override
  autocmd!
  autocmd VimEnter * set mouse=r
  autocmd VimEnter * set background=dark
augroup END
EOF

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

# alters /etc/default/locale - LC_TIME=C.UTF-8 gives 24h format
localectl set-locale LANG=en_US.UTF-8 LC_TIME=C.UTF-8

apt-get install -y exfat-fuse
apt-get install -y exfat-utils

###################################################################
# kubernetes and helm
###################################################################
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl


curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install -y helm

###################################################################
# python
###################################################################

apt-get install -y python3-pip
apt-get install -y python-is-python3

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

# lazydocker
# go install github.com/jesseduffield/lazydocker@latest



