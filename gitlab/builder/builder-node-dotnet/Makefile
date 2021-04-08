TARGET=builder-node-dotnet
BASE_IMAGE=mcr.microsoft.com/dotnet/sdk
NODE_VERSION=15
NODE_URL=https://raw.githubusercontent.com/nodejs/docker-node/main
BUILDERPACK_URL=https://raw.githubusercontent.com/docker-library/buildpack-deps/master/debian

all: clean
	mkdir -p ca-certificates
	cp -r /usr/local/share/ca-certificates ca-certificates
	wget -c -t0 ${BUILDERPACK_URL}/buster/Dockerfile
	sed -i 's/FROM.*//' Dockerfile 
	mv Dockerfile buildpack
	cp ../builder-buildpack/Dockerfile builder
	sed -i 's/FROM.*//' builder
	sed -i 's/ARG.*//' builder
	wget -c -t0 ${NODE_URL}/${NODE_VERSION}/buster/Dockerfile
	wget -c -t0 ${NODE_URL}/${NODE_VERSION}/buster/docker-entrypoint.sh
	chmod 755 docker-entrypoint.sh
	sed -i 's/FROM.*//' Dockerfile 
	mv Dockerfile node
	echo "FROM ${BASE_IMAGE}" > Dockerfile
	cat buildpack >> Dockerfile
	cat builder >> Dockerfile
	cat node >> Dockerfile
	docker build -t ${TARGET} .
	make clean
	rm -rf ca-certificates

clean:
	rm -f Dockerfile docker-entrypoint.sh buildpack builder node
	rm -rf ca-certificates
