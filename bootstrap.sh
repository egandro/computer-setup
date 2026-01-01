#!/usr/bin/env bash
set -euo pipefail

apt update -y && apt install -y ansible curl sudo
curl -fsSL https://raw.githubusercontent.com/egandro/computer-setup/main/debian-playbook.yml -o debian-playbook.yml
ansible-playbook debian-playbook.yml
