#!/bin/bash
set -e
#Check hostname is a hexadecimal number of 12 
SOMHOSTNAME="MistySOM-G2L"
LOCALCONF="${WORK}/build/conf/local.conf"
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
swp=`cat /proc/meminfo | grep "SwapTotal"|awk '{print $2}'`
mem=`cat /proc/meminfo | grep "MemTotal"|awk '{print $2}'`
NUM_CPU=$(((mem+swp)/1000/1000/4))
#NUM_CPU=`nproc`
##Update number of CPUs in local.conf
sed -i "1 i\PARALLEL_MAKE = \"-j ${NUM_CPU}\"\nBB_NUMBER_THREADS = \"${NUM_CPU}\"" ${LOCALCONF}
# Comment out the line that flags GPLv3 as an incompatible license
sed -i '/^INCOMPATIBLE_LICENSE = \"GPLv3 GPLv3+\"/ s/./#&/' ${LOCALCONF}
# append hostname to local.conf
echo "hostname_pn-base-files = \"${SOMHOSTNAME}\"" >> ${LOCALCONF}
#build offline tools, without network access
if [ -z $DLOAD ];
then
	sed -i 's/BB_NO_NETWORK = "0"/BB_NO_NETWORK = "1"/g' ${LOCALCONF}
fi

#Add configuration details for Laird LWB5+ module according to: https://github.com/LairdCP/meta-summit-radio/tree/lrd-10.0.0.x/meta-summit-radio-pre-3.4
cat <<EOT >> ${LOCALCONF}

BBMASK += "/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/openssl"
BBMASK += "/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/.*/.*openssl10.*"
BBMASK += "/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/summit-supplicant"
PREFERRED_RPROVIDER_wpa-supplicant = "sterling-supplicant-lwb"
PREFERRED_RPROVIDER_wpa-supplicant-cli = "sterling-supplicant-lwb"
PREFERRED_RPROVIDER_wpa-supplicant-passphrase = "sterling-supplicant-lwb"
PREFERRED_RPROVIDER_wireless-regdb-static = "wireless-regdb"

EOT
#addition of meta-mistysom & mistylwb5p layers to bblayers.conf
sed -i 's/renesas \\/&\n  ${TOPDIR}\/..\/meta-mistysom \\\n  ${TOPDIR}\/..\/meta-mistylwb5p\/meta-summit-radio-pre-3.4 \\/' ${WORK}/build/conf/bblayers.conf

# add dunfell compatibility to layers where they're missing to avoid WARNING
echo "LAYERSERIES_COMPAT_qt5-layer = \"dunfell\"" >> ${WORK}/meta-qt5/conf/layer.conf
echo "LAYERSERIES_COMPAT_rz-features = \"dunfell\"" >> ${WORK}/meta-rz-features/conf/layer.conf 
echo "LAYERSERIES_COMPAT_summit-radio-pre-3.4 = \"dunfell\"" >> ${WORK}/meta-mistylwb5p/meta-summit-radio-pre-3.4/conf/layer.conf

echo "    ------------------------------------------------
    SETUP SCRIPT BUILD ENVIRONMENT SETUP SUCCESSFUL!
    run the following commands to start the build:
    'cd ${WORK}'
    'source poky/oe-init-build-env'
    'bitbake mistysom-image'"
cd ~/rzg_vlp_v3.0.0

