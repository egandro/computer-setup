ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MAVEN_VERSION
ARG ANT_VERSION

RUN apt-get update && \
    apt-get install -y \
	default-jdk \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q https://mirror.netcologne.de/apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/local \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && wget -q https://ftp.halifax.rwth-aachen.de/apache/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz -C /usr/local \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz

ENV PATH="${PATH}:/usr/local/apache-maven-${MAVEN_VERSION}/bin"
ENV PATH="${PATH}:/usr/local/apache-ant-${ANT_VERSION}/bin"

