TARGET=builder-node
BASE_IMAGE=builder-buildpack
NODE_VERSION=15
NODE_URL=https://raw.githubusercontent.com/nodejs/docker-node/main

all: clean
	wget -c -t0 ${NODE_URL}/${NODE_VERSION}/buster/Dockerfile
	wget -c -t0 ${NODE_URL}/${NODE_VERSION}/buster/docker-entrypoint.sh
	chmod 755 docker-entrypoint.sh
	sed -i 's/buildpack-deps:buster/'${BASE_IMAGE}'/1' Dockerfile 
	docker build -t ${TARGET} .
	make clean

clean:
	rm -f Dockerfile docker-entrypoint.sh
