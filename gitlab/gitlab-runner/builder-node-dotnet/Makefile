TARGET=builder-node-dotnet
BASE_IMAGE=mcr.microsoft.com/dotnet/sdk
NODE_VERSION=15
NODE_URL=https://raw.githubusercontent.com/nodejs/docker-node/main
BUILDERPACK_URL=https://raw.githubusercontent.com/docker-library/buildpack-deps/master/debian

all: clean
	wget -c -t0 ${BUILDERPACK_URL}/buster/Dockerfile
	sed -i 's/FROM.*//' Dockerfile 
	sed -i 's/gcc/gcc gpg/' Dockerfile 
	sed -i 's/gcc/gcc gpg-agent/' Dockerfile 
	sed -i 's/gcc/gcc dirmngr/' Dockerfile 
	sed -i 's/gcc/gcc cmake/' Dockerfile 
	mv Dockerfile header
	wget -c -t0 ${NODE_URL}/${NODE_VERSION}/buster/Dockerfile
	wget -c -t0 ${NODE_URL}/${NODE_VERSION}/buster/docker-entrypoint.sh
	chmod 755 docker-entrypoint.sh
	sed -i 's/FROM.*//' Dockerfile 
	mv Dockerfile footer
	echo "FROM ${BASE_IMAGE}" > Dockerfile
	cat header >> Dockerfile
	cat footer >> Dockerfile
	docker build -t ${TARGET} .
	make clean

clean:
	rm -f Dockerfile docker-entrypoint.sh header footer
