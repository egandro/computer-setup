#!/bin/bash

PASS=""
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N "${PASS}"

# for windows/putty
sudo apt-get install putty-tools || true
puttygen ~/.ssh/id_ed25519 -o ~/.ssh/id_ed25519.ppk

# for windows to this machine
ssh-copy-id -i ~/.ssh/id_ed25519 ${USER}@localhost

# distribute key
echo ssh-copy-id -i ~/.ssh/id_ed25519 ${USER}@host
echo scp -p ~/.ssh/id_ed25519 ${USER}@host:/home/${USER}/.ssh
echo scp -p ~/.ssh/id_ed25519.pub ${USER}@host:/home/${USER}/.ssh

# show keys ~/.ssh/authorized_keys
# egrep '^[^#]' ~/.ssh/authorized_keys | xargs -n1 -I% bash -c 'ssh-keygen -l -f /dev/stdin <<<"%"'
