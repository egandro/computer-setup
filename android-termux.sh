pkg update -y
pkg upgrade -y
termux-setup-storage
pkg install -y vim
pkg install -y screen
pkg install -y mc
pkg install -y make
pkg install -y clang
pkg install -y python
pkg install -y nodejs
pkg install -y git
pkg install -y wget
pkg install -y openssh
pkg install -y termux-auth
pkg install -y ffmpeg
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /data/data/com.termux/files/usr/bin/youtube-dl
chmod a+rx /data/data/com.termux/files/usr/bin/youtube-dl
apt autoremove -y
