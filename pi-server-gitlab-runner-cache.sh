#!/bin/bash

#
# this "fixes" the "No URL provided, cache will not be downloaded from shared cache server. Instead a local version of cache will be extracted. "
# by adding a s3 docker as cache
#

GITLAB_HOME=/var/opt/gitlab

mkdir -p ${GITLAB_HOME}
mkdir -p ${GITLAB_HOME}/gitlab-runner-cache/data

MINIO_ACCESS_KEY="$(< /dev/urandom tr -dc A-Z0-9 | head -c20)"
MINIO_SECRET_KEY="$(< /dev/urandom tr -dc _A-Za-z0-9+- | head -c40)"

docker run -d --restart always \
  --name gitlab-runner-cache-s3 \
  -e "MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}" \
  -e "MINIO_SECRET_KEY=${MINIO_SECRET_KEY}" \
  -v ${GITLAB_HOME}/gitlab-runner-cache:/var/lib/minio \
  -p 9010:9000 \
  webhippie/minio
#jessestuart/minio  # this is an arm64 version

echo "access_key: ${MINIO_ACCESS_KEY}" >${GITLAB_HOME}/gitlab-runner-cache/secret.txt
echo "secret_key: ${MINIO_SECRET_KEY}" >>${GITLAB_HOME}/gitlab-runner-cache/secret.txt
chmod 600 ${GITLAB_HOME}/gitlab-runner-cache/secret.txt

echo "add this to your/var/opt/gitlab/gitlab-runner/config.toml"
echo "  [runners.cache]"
echo "    Type = \"s3\""
echo "    [runners.cache.s3]"
echo "      ServerAddress = \"gitlab.localnet:9010\""
echo "      AccessKey = \"${MINIO_ACCESS_KEY}\""
echo "      SecretKey = \"${MINIO_SECRET_KEY}\""
echo "      BucketName = \"data\""
echo "      Insecure = true"

