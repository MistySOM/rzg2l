#!/bin/bash
#set -e

usage() {
    echo "    Usage:
    $ $0 -b|--branch :	attach current branch name when running the container
    $ $0 -c|--cpath :	path to local cache (download & sstate)
    $ $0 -n|--no :	starts container but does not invoke bitbake,
				start in developer mode
    $ $0 -s|--sdk :	invokes building of SDK
    $ $0 -v|--verbose	run script in verbose mode"
}
#OUTDIR is bind mopunted and will contain the compiled output from the container
OUTDIR='output'
test -t 1 && USE_TTY="-it"
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
        BRANCH="_$(git branch --show-current)"
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
CONTNAME="$(whoami)-rzg2l_vlp_v3.0.0${BRANCH}"
#Create OUTDIR if it doesn't exist
mkdir -p ${OUTDIR}
chmod 777 ${OUTDIR}
if [ -z "${CPATH}" ]; 
then
  /usr/bin/docker run --privileged ${USE_TTY} --rm -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} -v "${PWD}/${OUTDIR}":/home/yocto/rzg_vlp_v3.0.0/out --name ${CONTNAME} ${CONTNAME}
else
	#Create CPATH sub directories if they do not exist
	mkdir -p -m777 ${CPATH}/downloads
	mkdir -p -m777 ${CPATH}/sstate-cache/${MPU}
	/usr/bin/docker run --privileged ${USE_TTY} --rm -v "${PWD}/${OUTDIR}":/home/yocto/rzg_vlp_v3.0.0/out -v "${CPATH}/downloads":/home/yocto/rzg_vlp_v3.0.0/build/downloads -v "${CPATH}/sstate-cache/${MPU}/":/home/yocto/rzg_vlp_v3.0.0/build/sstate-cache -e NO=${NO} -e SDK=${SDK} -e DLOAD=${DLOAD} --name ${CONTNAME} ${CONTNAME}
fi
