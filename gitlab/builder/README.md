# Docker Images for Gitlab Runner

## builder-buildpack

  - based on buildpacks-debs:buster (NodeJS is based on this)
  - contains debian + build tools (make, autoconf, ...)
  - added cmake here

## builder-node

  - Downloads original Dockerfile + tools
  - can be rebased e.g to builder-buildpack

## builder-node-go

  - adds go to the node image
