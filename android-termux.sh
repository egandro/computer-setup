# setup termux storage in apps

pkg update -y
pkg upgrade -y
#termux-setup-storage
pkg install -y which
pkg install -y file
pkg install -y vim
echo "set mouse=r" >> $HOME/.vimrc
pkg install -y tmux
echo "set -g mouse off" >> $HOME/.tmux.conf
pkg install -y mc
pkg install -y git
pkg install -y wget
pkg install -y openssh
pkg install -y termux-auth
pkg install -y ffmpeg
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp  -o /data/data/com.termux/files/usr/bin/yt-dlp
chmod a+rx /data/data/com.termux/files/usr/bin/yt-dlp

pkg install -y iproute2
pkg install -y dnsutils
pkg install -y jq
pkg install -y ncdu
pkg install -y make

#pkg install -y nodejs
#pkg install -y golang
#pkg install -y clang
#pkg install -y python

# additional repos
# https://github.com/termux-user-repository/tur
#pkg install -y tur-repo

apt autoremove -y
