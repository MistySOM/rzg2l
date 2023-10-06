#!/bin/bash
set -e
#Check hostname is a hexadecimal number of 12 
hname=`hostname | egrep -o '^[0-9a-f]{12}\b'`
OUTDIR=$WORK/out
echo $hname
len=${#hname}
if [[ ! "$len" -eq 12 ]];
then 
    echo "ERROR: this script needs to be run inside the Yocto build container!"
    exit
fi
if [[ ! -w ${OUTDIR} ]];
then
	echo "Unable to obtain full acess  permissions to 'output' and its sub directories, edit the permissions of 'output' accordingly! exit"
	exit -1
fi
if [[ ! -w $WORK/build/sstate-cache || ! -w $WORK/build/downloads ]];
then
	echo "Unable to obtain write permissions to 'cache' and its sub directories, edit the permissions of 'cache' accordingly! exit"
	exit -1
fi


./start.sh
if [ -z $NO ];
then
	cd $WORK
	source poky/oe-init-build-env
	if [ -z $SDK ]; #if $SDK is not set
	then
		time bitbake mistysom-image
		echo "copying compiled images into 'out/'"
		cp -r $WORK/build/tmp/deploy/images/ ${OUTDIR}
	else
		time sh -c "bitbake mistysom-image && bitbake mistysom-image -c populate_sdk"
		echo "copying compiled images & SDK directories into 'out/'"
		cp -r $WORK/build/tmp/deploy/sdk/ ${OUTDIR}
		cp -r $WORK/build/tmp/deploy/images/ ${OUTDIR}
	fi
else
	/bin/bash
fi


