#!/bin/bash
git submodule update --init --recursive
if [ "$1" == "-b" ]; then
	IMAGE_NAME="$(whoami)-rzg2l_vlp_v3.0.0_$(git branch --show-current)"
else if [ "$1" == "-h" ]; then
	echo " Use -b to add the branch name to the current container name"
	else
		IMAGE_NAME="$(whoami)-rzg2l_vlp_v3.0.0"
	fi
fi
docker image rm ${IMAGE_NAME} || (echo "Image ${IMAGE_NAME} didn't exist so not cleaned."; exit 0)
docker build -t ${IMAGE_NAME}:latest .
