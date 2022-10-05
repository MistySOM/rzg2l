#!/bin/bash
#set -e
#Check hostname is a hexadecimal number of 12 
LOCALCONF="/home/yocto/rzv_vlp_v3.0.0/build/conf/local.conf"
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
#exit 0
mkdir $WORK
cd $WORK
unzip ~/RTK0EF0045Z0024AZJ-v3.0.0-update2.zip
tar zxvf ./RTK0EF0045Z0024AZJ-v3.0.0-update2/rzv_bsp_v3.0.0.tar.gz
cd $WORK
unzip ~/RTK0EF0045Z13001ZJ-v1.2_EN.zip
tar zxvf ./RTK0EF0045Z13001ZJ-v1.2_EN/meta-rz-features.tar.gz
cd $WORK
unzip ~/RTK0EF0045Z15001ZJ-v0.58_EN.zip
tar zxvf ./RTK0EF0045Z15001ZJ-v0.58_EN/meta-rz-features.tar.gz
cd $WORK
source poky/oe-init-build-env
cd $WORK/build
cp ../meta-renesas/docs/template/conf/smarc-rzv2l/*.conf ./conf/
echo "    ------------------------------------------------"
echo "    CONFIGURATION COPIED TO conf/"
#Decompress OSS files (offline install)
if [ -z $DLOAD ];
then
	cd $WORK/build
	7z x ~/oss_pkg_rzv_v3.0.0.7z
fi
##Apply DRPAI patch
#echo "applying drpai patch"
#patch -p2 < ../rzv2l-drpai-conf.patch
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
##Add installation of Python to local.conf
#echo "IMAGE_INSTALL_append = \" python3\"">> /home/yocto/rzv2l_bsp_v101/build/conf/local.conf
#echo "IMAGE_INSTALL_append = \" python3-datetime\"">> /home/yocto/rzv2l_bsp_v101/build/conf/local.conf
#echo "IMAGE_INSTALL_append = \" python3-io\"">> /home/yocto/rzv2l_bsp_v101/build/conf/local.conf
#echo "IMAGE_INSTALL_append = \" python3-core\"">> /home/yocto/rzv2l_bsp_v101/build/conf/local.conf
#echo "IMAGE_INSTALL_append = \" python3-multiprocessing\"">> /home/yocto/rzv2l_bsp_v101/build/conf/local.conf
#
##Add kconfig fragments to bb recipe
#cd ~/rzv2l_bsp_v101/
#FRAG=$(./get_fragments.sh)
#echo "$FRAG" >> ~/rzv2l_bsp_v101/meta-rzv/recipes-kernel/linux/linux-renesas_4.19.bb
#cp ~/rzv2l_bsp_v101/mw_fragments/* ~/rzv2l_bsp_v101/meta-rzv/recipes-kernel/linux/linux-renesas/
#
echo "    ------------------------------------------------
    SETUP SCRIPT BUILD ENVIRONMENT SETUP SUCCESSFUL!
    run the following commands to start the build:
    'cd ~/rzv_vlp_v3.0.0/'
    'source poky/oe-init-build-env'
    'bitbake core-image-weston'"
cd ~/rzv_vlp_v3.0.0

