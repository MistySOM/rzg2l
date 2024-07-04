#!/bin/bash
NAME="rzg2l_vlp_v3.0.4"
Help()
{
   echo "This script createss the build container for MistySOM G2L or V2L."
   echo
   echo "Syntax: $0 [-h|-b]"
   echo "options:"
   echo "h     Show this help."
   echo "b     Include current branch name in container name."
   echo
}
# Get the options
while getopts ":hb" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      b) # include branch name
         INCLUDE_BRANCH=1;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [ $INCLUDE_BRANCH -eq 1 ]; then
	IMAGE_NAME="$(whoami)-${NAME}_$(git branch --show-current)"
else
	IMAGE_NAME="$(whoami)-${NAME}"
fi
docker build -t ${IMAGE_NAME}:latest .
(docker images | grep "^<none" | awk '{print $3}' | xargs docker rmi) || :
