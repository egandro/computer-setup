#!/bin/bash

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
sudo apt install python-is-python3 -y
sudo apt autoremove


for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo service docker start

# we will use systemd later
sudo usermod -aG docker $USER
sudo apt install openssh-server -y

sudo apt install jq mc tmux xsel git curl wget btop htop psmisc zip unzip dnsutils net-tools expect default-jdk -y
cat << EOF > ~/.tmux.conf
set -g bell-action any
set -g visual-bell on
set -g visual-activity on
EOF

sudo apt install -y vim

echo 'export EDITOR=vim' >> ~/.bashrc
sudo /bin/bash -c "echo 3 | update-alternatives --config editor"


sudo /bin/bash -c "cat <<EOF >> /etc/vim/vimrc.local
augroup system_mouse_override
  autocmd!
  autocmd VimEnter * set mouse=r
  autocmd VimEnter * set background=dark
augroup END
EOF"

sudo apt install bash-completion -y
sudo apt install zsh fzf autojump -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"







