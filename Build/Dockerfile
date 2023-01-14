FROM ubuntu:20.04
ENV TZ=America/Vancouver
ENV WORK=/home/yocto/rzg_vlp_v3.0.0
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# update and upgrade to latest & greatest
RUN apt -y update && apt -y upgrade
# Install packages
RUN apt-get -y install gawk wget git-core diffstat unzip texinfo \
		       gcc-multilib build-essential chrpath socat cpio python python3 \
	     	       python3-pip python3-pexpect xz-utils debianutils iputils-ping \
	     	       python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 \
	     	       xterm p7zip-full libyaml-dev screen ncurses-bin libncurses-dev \
		       device-tree-compiler locales vim git findutils exuberant-ctags \
		       cscope tmux sudo
# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
#create user yocto
RUN useradd -m yocto -s /bin/bash
RUN echo yocto:yocto | chpasswd
RUN usermod -aG sudo yocto
WORKDIR /home/yocto
#COPY files 
RUN wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z0021AZJ-v3.0.0-update2.zip
RUN wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z13001ZJ-v1.2_EN.zip
RUN wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z15001ZJ-v0.58_EN.zip
RUN wget https://remote.mistywest.io/download/mh11/rzg2l/VerifiedLinuxPackage_v3.0.0/oss_pkg_v3.0.0.7z
COPY start.sh /home/yocto/
COPY exec.sh /home/yocto/
COPY get_fragments.sh /home/yocto/rzg_vlp_v3.0.0/
COPY mw_fragments/*.cfg /home/yocto/rzg_vlp_v3.0.0/mw_fragments/
RUN chown yocto:yocto -R /home/yocto/
RUN apt-get -y install tree libssl-dev gcc-aarch64-linux-gnu
USER yocto
RUN mkdir -p /home/yocto/rzg_vlp_v3.0.0/build/downloads
RUN mkdir -p /home/yocto/rzg_vlp_v3.0.0/out
# copy mist-som layer from the submodule 
COPY meta-mistysom /home/yocto/rzg_vlp_v3.0.0/meta-mistysom

WORKDIR /home/yocto
CMD ["/home/yocto/exec.sh"]
