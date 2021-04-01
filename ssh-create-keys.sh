#!/bin/bash

sudo apt-get install putty-tools || echo ""
ssh-keygen
puttygen ~/.ssh/id_rsa.pub -o ~/.ssh/id_rsa.ppk

echo ssh-copy-id -i ~/.ssh/id_rsa ${USER}@host
