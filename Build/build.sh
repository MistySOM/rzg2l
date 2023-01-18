#!/bin/bash
git submodule update --init --recursive
CONTNAME="$(whoami)-rzg2l_vlp_v3.0.0"
docker build -t ${CONTNAME}:latest .
