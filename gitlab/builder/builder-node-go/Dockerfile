ARG BASE_IMAGE

FROM ${BASE_IMAGE}

#RUN apt-get update && apt-get install -y git


RUN ARCH=$(dpkg --print-architecture) \
    && case "${ARCH}" in \
        amd64) $(eval GO_ARCH=amd64);; \
        arm64) $(eval GO_ARCH=arm64);; \
        armhf) $(eval GO_ARCH=armv6l);; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && GO_LATEST=$(curl -s https://golang.org/VERSION?m=text) \
    && GO_INSTALLER=${GO_LATEST}.linux-${GO_ARCH}.tar.gz \
    && wget -c -t0 "https://dl.google.com/go/${GO_INSTALLER}" \
    && rm -rf /usr/local/go && tar -C /usr/local -xzf ${GO_INSTALLER} \
    && rm -f ${GO_INSTALLER} 

ENV PATH="${PATH}:/usr/local/go/bin"
