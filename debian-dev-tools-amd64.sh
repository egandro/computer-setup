#!/bin/bash

#
# Java
#
apt-get install -y default-jre default-jdk

#
# golang
#
wget -q -c -t0 https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
rm -f go1.16.2.linux-amd64.tar.gz

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
wget -q -c -t0 https://github.com/lensapp/lens/releases/download/v4.1.5/Lens-4.1.5.amd64.deb
dpkg -i Lens-4.1.5.amd64.deb
dpkg --configure -a
apt --fix-broken install -y
rm -f Lens-4.1.5.amd64.deb

#
# DotNet Core
#
# from here: https://github.com/dotnet/core/blob/main/release-notes/5.0/releases.json
# https://raw.githubusercontent.com/dotnet/core/main/release-notes/5.0/releases.json
# URL=$(curl -s https://raw.githubusercontent.com/dotnet/core/main/release-notes/5.0/releases.json  | grep -P "https:.*dotnet-sdk-linux-arm64\.tar\.gz" | head -1 | sed -e "s/^.*http/http/g" | sed -e "s/\"//g")
# arm, arm64, x64
wget -q -c -t0  https://download.visualstudio.microsoft.com/download/pr/73a9cb2a-1acd-4d20-b864-d12797ca3d40/075dbe1dc3bba4aa85ca420167b861b6/dotnet-sdk-5.0.201-linux-x64.tar.gz
rm -rf /usr/local/dotnet && mkdir -p /usr/local/dotnet && tar -C /usr/local/dotnet -xzf dotnet-sdk-5.0.201-linux-x64.tar.gz
rm -f dotnet-sdk-5.0.201-linux-x64.tar.gz


rm -f /etc/profile.d/dotnet-env.sh
echo "export DOTNET_ROOT=/usr/local/dotnet" >> /etc/profile.d/dotnet-env.sh
echo "export PATH=\$PATH:\$DOTNET_ROOT" >> /etc/profile.d/dotnet-env.sh

#
# cli docker registry tools
#
go get github.com/mayflower/docker-ls/cli/...
