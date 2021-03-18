#!/bin/bash

# https://ralph.blog.imixs.com/2019/06/09/running-gitlab-on-docker/

GITLAB_HOME=/var/opt/gitlab

mkdir -p ${GITLAB_HOME}

docker run -d --restart always \
--name gitlab \
--hostname gitlab.localnet \
--env GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.localnet:8888'; gitlab_rails['gitlab_shell_ssh_port'] = 2222;  nginx['listen_port'] = 
8888;  nginx['listen_https'] = false; ; " \
-p 8888:8888 -p 2222:22 \
-v ${GITLAB_HOME}/gitlab/config:/etc/gitlab \
-v ${GITLAB_HOME}/gitlab/logs:/var/log/gitlab \
-v ${GITLAB_HOME}/gitlab/data:/var/opt/gitlab \
ulm0/gitlab

docker run -d --restart always \
--name arm-gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${GITLAB_HOME}/gitlab-runner:/etc/gitlab-runner \
klud/gitlab-runner

echo "wait until git is available and register the runner via:"
echo "   docker exec -it arm-gitlab-runner gitlab-runner register -n \
  --url http://gitlab.localnet:8888/ \
  --registration-token REGISTRATION_TOKEN \
  --executor docker \
  --description 'Arm Gitlab Runner' \
  --docker-image 'debian:buster' \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock"

echo "add >    pull_policy = "if-not-present"< to end of /var/opt/gitlab/gitlab-runner/config.toml"
