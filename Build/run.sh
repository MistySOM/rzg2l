#!/bin/bash
#set -e

usage() {
    echo "    Usage:
        $ $0 -b|--branch :      attach current branch name when running the container
        $ $0 -c|--cpath :       path to local cache (download & sstate)
        $ $0 -n|--no :          starts container but does not invoke bitbake
        $ $0 -s|--sdk :         start in developer mode, 
                                      invokes building of SDK
        $ $0 -v|--verbose       run script in verbose mode"

}
#OUTDIR is bind mopunted and will contain the compiled output from the container
OUTDIR='output'
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
      -b|--branch)
        BRANCH="1"
        shift #past argument
      ;;
      -c|--cpath)
        CPATH="$2"
	DLOAD="1"
        shift #past argument
        shift #past value
      ;;
      -n|--no)
        NO="1"
        shift #past argument
      ;;
      -s|--sdk)
        SDK="1"
        shift #past argument
      ;;
      -v|--verbose)
        VERBOSE="1"
        shift #past argument
      ;;
      -*|--*)
        echo "Unknown argument $1"
        usage
        exit 1
        ;;
    esac
done
if [ "$BRANCH" == "1" ];
then
	CONTNAME="$(whoami)-rzg2l_vlp_v3.0.0_$(git branch --show-current)"
else
	CONTNAME="$(whoami)-rzg2l_vlp_v3.0.0"
fi
#Create OUTDIR if iot doesn't exist
#echo "VERBOSE: ${VERBOSE} NO: ${NO}"
#exit
if [ ! -d "${OUTDIR}" ];
then
	mkdir ${OUTDIR}
fi
	if [ -z "${VERBOSE}" ];
	then
		chmod 777 ${OUTDIR} 2>/dev/null
	else
		chmod 777 ${OUTDIR}
	fi
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
		mkdir -p ${CPATH}/sstate-cache/${MPU}
	fi
	if [ -z ${VERBOSE} ];
	then
		chmod -R 777 ${CPATH}/downloads 2>/dev/null
		chmod -R 777 ${CPATH}/sstate-cache/${MPU} 2>/dev/null
	else
		chmod -R 777 ${CPATH}/downloads
		chmod -R 777 ${CPATH}/sstate-cache/${MPU}
	fi
	/usr/bin/docker run --privileged -it --rm -v "${PWD}/${OUTDIR}":/home/yocto/rzg_vlp_v3.0.0/out -v "${CPATH}/downloads":/home/yocto/rzg_vlp_v3.0.0/build/downloads -v "${CPATH}/sstate-cache/${MPU}/":/home/yocto/rzg_vlp_v3.0.0/build/sstate-cache -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} --name ${CONTNAME} ${CONTNAME}
fi
