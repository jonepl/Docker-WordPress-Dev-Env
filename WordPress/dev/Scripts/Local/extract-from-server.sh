#!/bin/bash

if [ $1 == "-c" ]; then
    SITENAME=`cat Scripts/Config/local.config | grep SITENAME | cut -d \= -f 2`
    SSHINFO=`cat Scripts/Config/ocal.config | grep SSHINFO | cut -d \= -f 2`
elif [ ! -z $1 ] & [ ! -z $2 ]; then
    SITENAME=$1
    SSHINFO=$2
else
    echo "Please provide a site name and ssh info."
    exit 1
fi

# Backup Src and DB on Server
ssh -p 22 ${SSHINFO} "sh ~/var/dev/${SITENAME}/server-wp-backup.sh ${SITENAME}"
if [ $? != "0" ]; then
    echo "Unable to backup wordpress on server"
    exit 1
fi

if [ ! -d "Backups/Remote/${SITENAME}/" ]; then
    mkdir -p Backups/Remote/${SITENAME}
else 
    rm -rf Backups/Remote/${SITENAME}/*
fi

# Grab latest src and db files
sqlBackup=`ssh -p 22 ${SSHINFO} "cd backups/${SITENAME}/ ; ls -t *.sql | head -1"`
srcBackup=`ssh -p 22 ${SSHINFO} "cd backups/${SITENAME}/ ; ls -t *.gz | head -1"`

if [ -z $sqlBackup ]; then
    echo "Unable to extract SQL file name from server."
    exit 1
fi

if [ -z $srcBackup ]; then
    echo "Unable to extract SRC code file name from server."
    exit 1
fi

scp ${SSHINFO}:backups/${SITENAME}/${sqlBackup} Backups/Remote/${SITENAME}/
scp ${SSHINFO}:backups/${SITENAME}/${srcBackup} Backups/Remote/${SITENAME}/
