#!/bin/bash

GITLAB_HOME=/var/opt/gitlab

# idea from: https://github.com/xmartlabs/docker-htpasswd

cat << EOF > Dockerfile.htpasswd 
FROM debian:buster

RUN apt-get update \\
    && apt-get install -y apache2-utils \\
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["htpasswd", "-Bbn"]
EOF

mkdir -p ${GITLAB}/registry/auth

docker build -f Dockerfile.htpasswd . -t htpasswd
docker run --rm -ti htpasswd gitlab gitlab > ${GITLAB}/registry/auth/htpasswd
rm -f Dockerfile.htpasswd
docker image rm -f htpasswd || echo ""

# no arm version
#docker run \
#  --entrypoint htpasswd \
#  registry:2 -Bbn testuser testpassword > ${GITLAB}/registry/auth/htpasswd

mkdir -p ${GITLAB}/registry/cert

cp /etc/ssl/certs/wildcard.my.localnet.crt ${GITLAB}/registry/cert/server.crt
cp /etc/ssl/private/wildcard.my.localnet.key ${GITLAB}/registry/cert/server.key

docker rm -f registry || echo ""
docker run -d \
  --restart=always \
  --name registry \
  -v ${GITLAB}/registry/registry:/var/lib/registry \
  -v ${GITLAB}/registry/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v ${GITLAB}/registry/certs:/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/server.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/server.key \
  -p 5000:5000 \
  registry:2
