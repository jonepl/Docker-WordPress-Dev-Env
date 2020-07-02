#!/bin/bash

SITENAME=$1
SSHINFO=`cat Scripts/Config/${SITENAME}/local.config | grep SSHINFO | cut -d \= -f 2`
DEVROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep DEVROOTDIR | cut -d \= -f 2`
REMOTESYNC=`cat Scripts/Config/${SITENAME}/local.config | grep REMOTESYNC | cut -d \= -f 2`

# Clean up local files for WP Site
CONFIGDIR="Scripts/Config/${SITENAME}/"
if [ -d $CONFIGDIR ]; then
    echo "$0: removing ${CONFIGDIR}"
    rm -rf ${CONFIGDIR}
fi

SCRIPTDIR="Scripts/Remote/${SITENAME}/"
if [ -d $SCRIPTDIR ]; then
    echo "$0: removing $SCRIPTDIR"
    rm -rf ${SCRIPTDIR}
fi

BACKUPDIR="Backups/${SITENAME}/"
if [ -d $BACKUPDIR ]; then
    echo "$0: removing ${BACKUPDIR}"
    rm -rf ${BACKUPDIR}
fi

# Clean up remote files for WP Site
if [[ $REMOTESYNC == "enabled" || $REMOTESYNC == "ENABLED" ]]; then

    echo "$0: Executing backup server script on remote server"
    ssh -p 22 ${SSHINFO} "sh ${DEVROOTDIR}scripts/${SITENAME}/server-clean-repo.sh"

    if [ $? != "0" ]; then
        echo "$0: FAILURE: Failed to execute remote script server-clean-repo.sh."
        exit 1
    fi

fi