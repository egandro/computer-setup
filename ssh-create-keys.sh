#!/bin/bash

PASS=""
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N "${PASS}"

# for windows/putty
sudo apt-get install putty-tools || echo ""
puttygen ~/.ssh/id_rsa -o ~/.ssh/id_rsa.ppk

# for windows to this machine
ssh-copy-id -i ~/.ssh/id_rsa ${USER}@localhost

# distribute key
echo ssh-copy-id -i ~/.ssh/id_rsa ${USER}@host
echo scp -p ~/.ssh/id_rsa ${USER}@host:/home/${USER}/.ssh
echo scp -p ~/.ssh/id_rsa.pub ${USER}@host:/home/${USER}/.ssh

# show keys ~/.ssh/authorized_keys
# egrep '^[^#]' ~/.ssh/authorized_keys | xargs -n1 -I% bash -c 'ssh-keygen -l -f /dev/stdin <<<"%"'
