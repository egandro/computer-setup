TARGET=builder-node
BASE_IMAGE=builder-buildpack
NODE_VERSION=15
URL=https://raw.githubusercontent.com/nodejs/docker-node/main

all: clean
	wget -c -t0 ${URL}/${NODE_VERSION}/buster/Dockerfile
	wget -c -t0 ${URL}/${NODE_VERSION}/buster/docker-entrypoint.sh
	chmod 755 docker-entrypoint.sh
	sed -i 's/buildpack-deps:buster/'${BASE_IMAGE}'/1' Dockerfile 
	docker build -t ${TARGET} .

clean:
	rm -f Dockerfile docker-entrypoint.sh
