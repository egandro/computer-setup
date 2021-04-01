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
