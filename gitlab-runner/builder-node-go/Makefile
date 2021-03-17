TARGET=builder-node-go
BASE_IMAGE=builder-node
GO_VERSION=go1.16.2.linux-armv6l.tar.gz

all:
	wget -c -t0 https://golang.org/dl/${GO_VERSION}
	sed -i 's/go.*\.tar\.gz/'${GO_VERSION}'/g' Dockerfile
	docker build --build-arg BASE_IMAGE="${BASE_IMAGE}" -t ${TARGET} .
