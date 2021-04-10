SHELL=bash

TARGET=builder-node-go
BASE_IMAGE=builder-node

all: 
	docker build --build-arg BASE_IMAGE="${BASE_IMAGE}" -t ${TARGET} . 
