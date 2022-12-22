#!/bin/bash
git submodule update --init --recursive
docker build -t rzg2l_vlp_v3.0.0 .
