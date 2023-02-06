#!/bin/bash
git submodule update --init --recursive
IMAGE_NAME="$(whoami)-rzg2l_vlp_v3.0.0"
docker build -t ${IMAGE_NAME}:latest .
docker rmi $(docker images | grep "^<none" | awk '{print $3}')
