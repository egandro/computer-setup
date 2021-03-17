ARG BASE_IMAGE

FROM ${BASE_IMAGE}

#RUN apt-get update && apt-get install -y git

# no ARGs in copy ... we use sed
COPY go1.16.2.linux-armv6l.tar.gz /usr/local

RUN rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /usr/local/go1.16.2.linux-armv6l.tar.gz && \
    rm /usr/local/go1.16.2.linux-armv6l.tar.gz

ENV PATH="${PATH}:/usr/local/go/bin"
