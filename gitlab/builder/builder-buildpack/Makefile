TARGET=builder-buildpack
BASE_IMAGE=buildpack-deps:buster

all:
	mkdir -p ca-certificates
	cp -r /usr/local/share/ca-certificates ca-certificates
	docker build --build-arg BASE_IMAGE="${BASE_IMAGE}" -t ${TARGET} .
	rm -rf ca-certificates
