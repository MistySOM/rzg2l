#!/bin/bash
FRAG_DIR="mw_fragments/" #specifies relaTIVE directory PATH that contains the config fragments
CURR_DIR=$(pwd)
#Generates a list of fragemnt files inside $FRAG_DIR
FRAGMENTLIST=(`ls ${CURR_DIR}/${FRAG_DIR}/*.cfg`)
#Loop over files in list and print content to add to bitbake recipe
        echo "SRC_URI_append = \" \\"
for i in ${FRAGMENTLIST[*]}
do
        echo "         file:/$i \\" | sed -e "s@$CURR_DIR/@@" | sed -e "s@$FRAG_DIR@@"
done
        echo "\""
