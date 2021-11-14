sudo apt-get install -y zsh tmux
chsh /usr/bin/zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cat << EOF > .zprofile
emulate sh
. ~/.profile
emulate zsh
EOF

cat << EOF >> .zshrc
#https://lanbugs.de/howtos/linux-tipps-tricks/tmux-die-screen-alternative/#
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
        tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi
EOF
