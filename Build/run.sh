#!/bin/bash
#set -e

usage() {
    echo "    Usage:
    $ $0 -c|--cpath : path to local cache (download & sstate)
    $ $0 -n|--no : starts container but does not invoke bitbake
    $ $0 -s|--sdk : start in developer mode, 
                    invokes building of SDK"
}
#OUTDIR is bind mopunted and will contain the compiled output from the container
OUTDIR='output'
CONTNAME="$(whoami)-rzg2l_vlp_v3.0.0"
MPU="rzg2l"
str="$*"
if [[ $str == *"-c"* ]];
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
      -c|--cpath)
        CPATH="$2"
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
if [ -z "${CPATH}" ]; 
then
	/usr/bin/docker run --privileged -it -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} -v "${PWD}/${OUTDIR}":/home/yocto/rzg_vlp_v3.0.0/out ${CONTNAME}
else
	#Create CPATH sub directories if they do not exist
	if [ ! -d "${CPATH}/downloads" ];
	then
		mkdir ${CPATH}/downloads
	fi
	if [ ! -d "${CPATH}/sstate-cache/${MPU}" ];
	then
		mkdir ${CPATH}/sstate-cache/${MPU}
	fi
	chmod -R 777 ${CPATH}/downloads
	chmod -R 777 ${CPATH}/sstate-cache/${MPU}
	/usr/bin/docker run --privileged -it --rm -v "${PWD}/${OUTDIR}":/home/yocto/rzg_vlp_v3.0.0/out -v "${CPATH}/downloads":/home/yocto/rzg_vlp_v3.0.0/build/downloads -v "${CPATH}/sstate-cache/${MPU}/":/home/yocto/rzg_vlp_v3.0.0/build/sstate-cache -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} --name ${CONTNAME} ${CONTNAME}
fi
