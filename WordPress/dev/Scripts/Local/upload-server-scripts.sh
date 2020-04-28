#!/bin/bash

SITENAME=$(basename $1)

if [ -z $SITENAME ]; then
    echo "$0: Invalid site name"
    exit 1;
fi

if [ ! -f Scripts/Config/$SITENAME/local.config ]; then
    echo "$0: Unable to find the local.config for ${SITENAME}. You the create using the migration.sh script."
    exit 1;
fi

DEVROOTDIR=`cat Scripts/Config/$SITENAME/local.config | grep DEVROOTDIR | cut -d \= -f 2`
SSHINFO=`cat Scripts/Config/$SITENAME/local.config | grep SSHINFO | cut -d \= -f 2`

echo "$0: Copying server script to ${SSHINFO}"
scp -r Scripts/Remote/${SITENAME}/* ${SSHINFO}:${DEVROOTDIR}scripts/${SITENAME}/
