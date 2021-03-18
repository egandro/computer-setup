TARGET=builder-buildpack
BASE_IMAGE=buildpack-deps:buster

all:
	docker build --build-arg BASE_IMAGE="${BASE_IMAGE}" -t ${TARGET} .
