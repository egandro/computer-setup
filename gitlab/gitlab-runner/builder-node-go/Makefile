SHELL=bash

TARGET=builder-node-go
BASE_IMAGE=builder-node
GO_VERSION=1.16.2
dpkgArch:=$(shell dpkg --print-architecture)

all: 
	case "${dpkgArch}" in \
    		amd64) $(eval ARCH=amd64);; \
    		armhf) $(eval ARCH=armv6l);; \
    		*) echo "unsupported architecture"; exit 1 ;; \
  	esac 
	$(eval GO_INSTALLER=go${GO_VERSION}.linux-${ARCH}.tar.gz)
	wget -c -t0 https://golang.org/dl/${GO_INSTALLER} 
	sed -i 's/go.*\.tar\.gz/'${GO_INSTALLER}'/g' Dockerfile 
	docker build --build-arg BASE_IMAGE="${BASE_IMAGE}" -t ${TARGET} . 
