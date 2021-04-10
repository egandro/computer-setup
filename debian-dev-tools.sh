#!/bin/bash

ARCH=$(dpkg --print-architecture)

#
# Java
#
apt-get install -y default-jre default-jdk

#
# golang
#
# most recent go version: wget "https://dl.google.com/go/$(curl https://golang.org/VERSION?m=text).linux-amd64.tar.gz"

GO_LATEST=$(curl -s https://golang.org/VERSION?m=text)
GO_INSTALLER=${GO_LATEST}.linux-${ARCH}.tar.gz
wget -c -t0 "https://dl.google.com/go/${GO_INSTALLER}"
rm -rf /usr/local/go && tar -C /usr/local -xzf ${GO_INSTALLER}
###rm -f ${GO_INSTALLER}
rm -f /etc/profile.d/go-env.sh
echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile.d/go-env.sh
echo "export GOPATH=\$HOME/.golib" >> /etc/profile.d/go-env.sh
echo "export PATH=\$PATH:\$GOPATH/bin" >> /etc/profile.d/go-env.sh
echo "export GOPATH=\$GOPATH:\$HOME/projects/go" >> /etc/profile.d/go-env.sh

#
# kubernetes
#
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

rm -f /etc/apt/sources.list.d/kubernetes.list
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

#
# Lens
#

#https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}
# get_latest_release lensapp/lens

LENS_LATEST=$(get_latest_release lensapp/lens)
LENS_LATEST=$(echo $LENS_LATEST | sed -e 's/v//')

wget -c -t0 https://github.com/lensapp/lens/releases/download/v$LENS_LATEST{}/Lens-${LENS_LATEST}.${ARCH}.deb
dpkg -i Lens-${LENS_LATEST}.${ARCH}.deb
dpkg --configure -a
apt --fix-broken install -y
###rm -f Lens-${LENS_LATEST}.${ARCH}.deb

#
# DotNet Core
#
# from here: https://github.com/dotnet/core/blob/main/release-notes/5.0/releases.json
# https://raw.githubusercontent.com/dotnet/core/main/release-notes/5.0/releases.json
# URL=$(curl -s https://raw.githubusercontent.com/dotnet/core/main/release-notes/5.0/releases.json  | grep -P "https:.*dotnet-sdk-linux-arm64\.tar\.gz" | head -1 | sed -e "s/^.*http/http/g" | sed -e "s/\"//g")
# arm, arm64, x64

URL=$(curl -s https://raw.githubusercontent.com/dotnet/core/main/release-notes/5.0/releases.json  | grep -P "https:.*dotnet-sdk-linux-${ARCH}\.tar\.gz" | head -1 | sed -e "s/^.*http/http/g" | sed -e "s/\"//g")
wget -c -t0 ${URL}
rm -rf /usr/local/dotnet && mkdir -p /usr/local/dotnet && tar -C /usr/local/dotnet -xzf dotnet-sdk-linux-$(ARCH).tar.gz
###rm -f dotnet-sdk-linux-$(ARCH).tar.gz


rm -f /etc/profile.d/dotnet-env.sh
echo "export DOTNET_ROOT=/usr/local/dotnet" >> /etc/profile.d/dotnet-env.sh
echo "export PATH=\$PATH:\$DOTNET_ROOT" >> /etc/profile.d/dotnet-env.sh

#
# cli docker registry tools
#
go get github.com/mayflower/docker-ls/cli/...