#!/bin/bash
set -e
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
	if [ -z $SDK ]; #if $SDK is not set
	then
		time bitbake core-image-weston
		echo "copying compiled images into 'out/'"
		cp -r /home/yocto/rzv_vlp_v3.0.0/build/tmp/deploy/images/ /home/yocto/rzv_vlp_v3.0.0/out/
	else
		time sh -c "bitbake core-image-weston && bitbake core-image-weston -c populate_sdk"
		echo "copying compiled images & SDK directories into 'out/'"
		cp -r /home/yocto/rzv_vlp_v3.0.0/build/tmp/deploy/sdk/ /home/yocto/rzv_vlp_v3.0.0/out/
		cp -r /home/yocto/rzv_vlp_v3.0.0/build/tmp/deploy/images/ /home/yocto/rzv_vlp_v3.0.0/out/
	fi
else
	/bin/bash
fi


