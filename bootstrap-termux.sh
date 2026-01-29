#!/usr/bin/env bash
set -euo pipefail

apt update -y
apt upgrade -y
#termux-setup-storage
apt install -y which
apt install -y file
apt install -y vim
echo "set mouse=r" >> $HOME/.vimrc
apt install -y tmux
echo "set -g mouse off" >> $HOME/.tmux.conf
apt install -y mc
apt install -y git
apt install -y wget
apt install -y man
apt install -y openssh
apt install -y termux-auth
apt install -y ffmpeg
apt install -y yt-dlp
apt install -y iproute2
apt install -y dnsutils
apt install -y jq
apt install -y ncdu
apt install -y make
apt install -y udocker

#apt install -y nodejs
#apt install -y golang
#apt install -y clang
#apt install -y python

# additional repos
# https://github.com/termux-user-repository/tur
#apt install -y tur-repo

apt autoremove -y
