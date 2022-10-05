#!/bin/bash
#set -e

usage() {
    echo "    Usage:
    $ $0 -d|--dpath : path to download cache
    $ $0 -n|--no : starts container but does not invoke bitbake
    $ $0 -s|--sdk : start in developer mode, 
                    invokes building of SDK"
}
#OUTDIR is bind mopunted and will contain the compiled output from the container
OUTDIR='output'
CONTNAME="rzv2l_vlp_v3.0.0"
str="$*"
if [[ $str == *"-d"* ]];
then
  if [ $# -lt 2 ]
  then
      echo "ERROR: insufficient number of arguments provided"
    usage
      exit
  fi
fi
while [[ $# -gt 0 ]]; do
    case $1 in
      -d|--dpath)
        DPATH="$2"
	DLOAD="1"
        shift #past argument
        shift #past value
      ;;
      -n|--no)
        NO="1"
        shift #past argument
        shift #past value
      ;;
      -s|--sdk)
        SDK="1"
        shift #past argument
        shift #past value
      ;;
      -*|--*)
        echo "Unknown argument $1"
        usage
        exit 1
        ;;
    esac
done
#Create OUTDIR if iot doesn't exist
if [ ! -d "${OUTDIR}" ];
then
	mkdir ${OUTDIR}
fi
	chmod 777 ${OUTDIR}
if [ -z "${DPATH}" ]; 
then
  /usr/bin/docker run --privileged -it -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} -v "${PWD}/${OUTDIR}":/home/yocto/rzv_vlp_v3.0.0/out ${CONTNAME}
else
	chmod 777 ${DPATH}
	/usr/bin/docker run --privileged -it -v "${PWD}/${OUTDIR}":/home/yocto/rzv_vlp_v3.0.0/out -v "$DPATH":/home/yocto/rzv_vlp_v3.0.0/build/downloads -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} ${CONTNAME}
fi
