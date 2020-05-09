#!/bin/bash

SITENAME=$1
SSHINFO=`cat Scripts/Config/${SITENAME}/local.config | grep SSHINFO | cut -d \= -f 2`
DEVROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep DEVROOTDIR | cut -d \= -f 2`
BACKUPROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep BACKUPROOTDIR | cut -d \= -f 2`

if [ -z $SITENAME ] || [ -z $SSHINFO ] || [ -z $DEVROOTDIR ] || [ -z $BACKUPROOTDIR ]; then
    echo "$0: Invalid site name, SSHINFO, DEVROOTDIR or BACKUPROOOT"
    exit 1
fi

# Backup Src and DB on Server
echo "Executing backup server script on remote server"
ssh -p 22 ${SSHINFO} "sh ${DEVROOTDIR}scripts/${SITENAME}/server-wp-backup.sh ${SITENAME}"

if [ $? != "0" ]; then
    echo "$0: Unable to backup wordpress on server"
    exit 1
fi

echo "Cleaning up existing backups from Backups/Remote/${SITENAME}"
if [ ! -d "Backups/Remote/${SITENAME}/" ]; then
    mkdir -p Backups/Remote/${SITENAME}
else 
    rm -rf Backups/Remote/${SITENAME}/*
fi

# Grab latest src and db files
sqlBackup=`ssh -p 22 ${SSHINFO} cd "backups/${SITENAME}/ ; ls -t *.sql | head -1"`
srcBackup=`ssh -p 22 ${SSHINFO} cd "backups/${SITENAME}/ ; ls -t *.gz | head -1"`


if [ -z $sqlBackup ]; then
    echo "$0: Unable to extract SQL file name from server."
    exit 1
fi

if [ -z $srcBackup ]; then
    echo "$0: Unable to extract SRC code file name from server."
    exit 1
fi

echo "Copying backup sql script from remote server"
scp ${SSHINFO}:backups/${SITENAME}/${sqlBackup} Backups/${SITENAME}/Remote/
if [ $? != "0" ]; then
    echo "$0: Unable to copy sql backup scripts from remote server"
    exit 1
fi

echo "Copying backup src zip from remote server"
scp ${SSHINFO}:backups/${SITENAME}/${srcBackup} Backups/${SITENAME}/Remote/
if [ $? != "0" ]; then
    echo "$0: Unable to copy db backup scripts from remote server"
    exit 1
fi

exit 0