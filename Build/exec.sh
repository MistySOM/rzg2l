#!/bin/bash
#set -e
#Check hostname is a hexadecimal number of 12 
hname=`hostname | egrep -o '^[0-9a-f]{12}\b'`
echo $hname
len=${#hname}
if [ "$len" -eq 12 ];
then 
	:
else
    echo "ERROR: this script needs to be run inside the Yocto build container!"
    exit
fi
./start.sh
if [ -z $NO ];
then
	cd $WORK
	source poky/oe-init-build-env
	if [ -z $SDK ]; 
	then
		bitbake core-image-weston
	else
		bitbake core-image-weston
		bitbake core-image-weston -c populate_sdk
	fi
	echo "copying compiled images & SDK directory into 'out/'"
	cp -r /home/yocto/rzv_vlp_v3.0.0/build/tmp/deploy/ /home/yocto/rzv_vlp_v3.0.0/out/
else
	/bin/bash
fi


