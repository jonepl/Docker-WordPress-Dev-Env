#!/bin/bash

SITENAME=$1
SSHINFO=`cat Scripts/Config/${SITENAME}/local.config | grep SSHINFO | cut -d \= -f 2`
DEVROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep DEVROOTDIR | cut -d \= -f 2`
REMOTESYNC=`cat Scripts/Config/${SITENAME}/local.config | grep REMOTESYNC | cut -d \= -f 2`

if [ -z $SITENAME ]; then
    echo "$0: Invalid site name"
    exit 1
fi

GITBRANCH=Backups/${SITENAME}/Local/
 
# Setup Local Repository
cp Scripts/Config/bitbucket-pipelines.yml.example Backups/${SITENAME}/Local/bitbucket-pipelines.yml
git init Backups/${SITENAME}/Local/

# Setup Remote Repository
if [ $REMOTESYNC = "enabled" ] || [ $REMOTESYNC == "ENABLED" ]; then

    echo "$0: Executing backup server script on remote server"
    ssh -p 22 ${SSHINFO} "sh ${DEVROOTDIR}scripts/${SITENAME}/server-init-repo.sh ${SITENAME}"

    if [ $? != "0" ]; then
        echo "$0: FAILURE: Unable to initial remote repository"
        exit 1
    fi
fi
