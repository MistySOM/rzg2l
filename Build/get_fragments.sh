#!/bin/bash
FRAG_DIR="mw_fragments/" #specifies relaTIVE directory PATH that contains the config fragments
CURR_DIR=$(pwd)
KERNELCONFIG=$WORK/meta-rzv/recipes-kernel/linux/linux-renesas_4.19.bb
#Generates a list of fragemnt files inside $FRAG_DIR
FRAGMENTLIST=(`ls ${CURR_DIR}/${FRAG_DIR}/*.cfg`)
#Loop over files in list and print content to add to bitbake recipe
for i in ${FRAGMENTLIST[*]}
do
        echo "SRC_URI_append = \" \\"
        echo "         file:/$i \\" | sed -e "s@$CURR_DIR/@@" | sed -e "s@$FRAG_DIR@@"
        echo "\""
done
