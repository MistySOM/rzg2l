#!/bin/bash
git submodule sync
git submodule update --init --recursive
if [ "$1" == "-b" ]; then
	IMAGE_NAME="$(whoami)-rzg2l_vlp_v3.0.0_$(git branch --show-current)"
else
	IMAGE_NAME="$(whoami)-rzg2l_vlp_v3.0.0"
fi
docker build -t ${IMAGE_NAME}:latest .
(docker images | grep "^<none" | awk '{print $3}' | xargs docker rmi) || :
