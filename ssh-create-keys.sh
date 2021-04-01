#!/bin/bash

sudo apt-get install putty-tools || echo ""
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
# ssh-keygen -p
# ssh-keygen -p -P oldpassphrase -N "" -f ~/.ssh/id_rsa
puttygen ~/.ssh/id_rsa -o ~/.ssh/id_rsa.ppk

echo ssh-copy-id -i ~/.ssh/id_rsa ${USER}@host
