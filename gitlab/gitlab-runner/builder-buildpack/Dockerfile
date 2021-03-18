ARG BASE_IMAGE

FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install -y \
    cmake \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
