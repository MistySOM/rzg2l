#!/bin/bash
git submodule update --init --recursive
IMAGE_NAME="$(whoami)-rzg2l_vlp_v3.0.0"
docker image rm ${IMAGE_NAME} || (echo "Image ${IMAGE_NAME} didn't exist so not cleaned."; exit 0)
docker build -t ${IMAGE_NAME}:latest .
