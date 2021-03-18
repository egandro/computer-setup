TARGET=builder-node-java
BASE_IMAGE=builder-node
MAVEN_VERSION=3.6.3
ANT_VERSION=1.10.9

all:
	docker build --build-arg BASE_IMAGE="${BASE_IMAGE}" \
		     --build-arg MAVEN_VERSION="${MAVEN_VERSION}" \
		     --build-arg ANT_VERSION="${ANT_VERSION}" -t ${TARGET} .
