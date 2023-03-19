#!/bin/bash
set -e
#Check hostname is a hexadecimal number of 12 
LOCALCONF="/home/yocto/rzg_vlp_v3.0.0/build/conf/local.conf"
YOCTODIR="/home/yocto/rzg_vlp_v3.0.0/"
hname=`hostname | egrep -o '^[0-9a-f]{12}\b'`
echo $hname
len=${#hname}
if [ "$len" -eq 12 ];
then 
    echo "$0 is running inside container"
else
    echo "ERROR: this script needs to be run inside the Yocto build container!"
    exit
fi
git config --global user.email "yocto@mistywest.com"
git config --global user.name "Yocto"
git config --global url.https://github.com/.insteadOf git://github.com/
if [[ ! -e $WORK ]]; then #Check if dir already exists
	mkdir $WORK #if not, create it
fi
cd $WORK
unzip -o ~/RTK0EF0045Z0021AZJ-v3.0.0-update2.zip
tar zxf ./RTK0EF0045Z0021AZJ-v3.0.0-update2/rzg_bsp_v3.0.0.tar.gz
cd $WORK
unzip -o ~/RTK0EF0045Z13001ZJ-v1.2_EN.zip
tar zxf ./RTK0EF0045Z13001ZJ-v1.2_EN/meta-rz-features.tar.gz
cd $WORK
unzip -o ~/RTK0EF0045Z15001ZJ-v0.58_EN.zip
tar zxf ./RTK0EF0045Z15001ZJ-v0.58_EN/meta-rz-features.tar.gz
cd $WORK
source poky/oe-init-build-env
cd $WORK/build
cp ../meta-renesas/docs/template/conf/smarc-rzg2l/*.conf ./conf/
echo "    ------------------------------------------------"
echo "    CONFIGURATION COPIED TO conf/"
#Decompress OSS files (offline install)
if [ -z $DLOAD ];
then
	cd $WORK/build
	7z x ~/oss_pkg_v3.0.0.7z
fi
##Apply DRPAI patch
#echo "applying drpai patch"
#patch -p2 < ../rzg2l-drpai-conf.patch
#echo "drpai patch applied"
swp=`cat /proc/meminfo | grep "SwapTotal"|awk '{print $2}'`
mem=`cat /proc/meminfo | grep "MemTotal"|awk '{print $2}'`
NUM_CPU=$(((mem+swp)/1000/1000/4))
#NUM_CPU=`nproc`
##Update number of CPUs in local.conf
sed -i "1 i\PARALLEL_MAKE = \"-j ${NUM_CPU}\"\nBB_NUMBER_THREADS = \"${NUM_CPU}\"" ${LOCALCONF}
#build offline tools, without network access
if [ -z $DLOAD ];
then
	sed -i 's/BB_NO_NETWORK = "0"/BB_NO_NETWORK = "1"/g' ${LOCALCONF}
fi
#addition of meta-mistysom layer to bblayers.conf
sed -i 's/renesas \\/&\n  ${TOPDIR}\/..\/meta-mistysom \\/' /home/yocto/rzg_vlp_v3.0.0/build/conf/bblayers.conf

# add dunfell compatibility to layers wehre they're missing to avoid WARNING
echo "LAYERSERIES_COMPAT_qt5-layer = \"dunfell\"" >> ${YOCTODIR}/meta-qt5/conf/layer.conf
echo "LAYERSERIES_COMPAT_rz-features = \"dunfell\"" >> ${YOCTODIR}/meta-rz-features/conf/layer.conf

echo "    ------------------------------------------------
    SETUP SCRIPT BUILD ENVIRONMENT SETUP SUCCESSFUL!
    run the following commands to start the build:
    'cd ~/rzg_vlp_v3.0.0/'
    'source poky/oe-init-build-env'
    'bitbake mistysom-image'"
cd ~/rzg_vlp_v3.0.0

