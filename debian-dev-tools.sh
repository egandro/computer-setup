#!/bin/bash

set -x

IS_RASPBERRY=$(grep Pi /proc/device-tree/model 2>/dev/null && echo 1)
ARCH=$(dpkg --print-architecture)

#
# Java
#
apt-get install -y default-jre default-jdk

#
# Python
#
apt-get install -y python3-dev

#
# gdb
#
apt-get install -y gdb

#
# golang
#
# most recent go version: wget "https://dl.google.com/go/$(curl -L https://golang.org/VERSION?m=text).linux-amd64.tar.gz"
case "${ARCH}" in
	amd64) GO_ARCH=amd64;;
	arm64) GO_ARCH=arm64;;
	armhf) GO_ARCH=armv6l;;
	*) echo "unsupported architecture"; exit 1 ;;
esac
GO_LATEST=$(curl -L -s https://golang.org/VERSION?m=text)
GO_INSTALLER=${GO_LATEST}.linux-${GO_ARCH}.tar.gz
wget -c -t0 "https://dl.google.com/go/${GO_INSTALLER}"
rm -rf /usr/local/go && tar -C /usr/local -xzf ${GO_INSTALLER}
rm -f ${GO_INSTALLER}
rm -f /etc/profile.d/go-env.sh
echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile.d/go-env.sh
echo "export GOPATH=\$HOME/.golib" >> /etc/profile.d/go-env.sh
echo "export PATH=\$PATH:\$GOPATH/bin" >> /etc/profile.d/go-env.sh
echo "export GOPATH=\$GOPATH:\$HOME/projects/go" >> /etc/profile.d/go-env.sh

. /etc/profile.d/go-env.sh


#
# todo freelens
#


#
# DotNet Core
#
## https://docs.microsoft.com/de-de/dotnet/core/install/linux-debian
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0

###################################################################
# Tools
###################################################################

# atm ltrace is not always available? backports?
apt install -y strace

