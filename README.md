# MistySOM-G2L

This repository contains data that relate to the **MistySOM-G2L** version. 
It includes the [Build](Build/) container to build a Linux kernel, device tree  & rootfs for MistySOM

## Requirements

The build environment requires a Linux operating system with a Docker Engine installed. (Read [here](https://docs.docker.com/desktop/install/linux-install/) for installation)

As the first build can take hours to complete, it is highly recommended that the machine would have a powerful CPU, at least 16 GB of RAM, and at least 100 GB of SSD. *(Note that later builds would be faster using the previous build caches)*

It is important to be sure that the docker engine has enough space to work. By default, the engine uses the path `/var/lib/docker` which will be very limited if the root partition is separated from the home partition. So we recommend that you move the default location to a bigger partition. (Read [here](https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux) for moving docker)

## How to Run

Run the commands below to start the build:

````
git clone --recursive https://github.com/MistySOM/rzg2l.git
cd rzg2l/Build
./build.sh
./run.sh
````
Details about the container and its parameters are mentioned [here](https://github.com/MistySOM/rzg2l/tree/master/Build).
