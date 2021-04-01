#!/bin/bash

sudo apt-get install putty-tools || echo ""
ssh-keygen
# ssh-keygen -p
# ssh-keygen -p -P oldpassphrase -N "" -f ~/.ssh/id_rsa
puttygen ~/.ssh/id_rsa.pub -o ~/.ssh/id_rsa.ppk

echo ssh-copy-id -i ~/.ssh/id_rsa ${USER}@host
