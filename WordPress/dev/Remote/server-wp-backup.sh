#!/bin/bash

if [ ! -z $1 ]; then
    SITENAME=$1
else
    echo "Please provide a site name."
    exit 1
fi

baseDir=~/
webDir=public_html/${SITENAME}/

# Create Backup Directory
timeStamp=$(date +%Y-%m-%d_%H-%M)
currBackupDir=${baseDir}backups/${SITENAME}/

# Pulls Datbase Information
WPDBNAME=`cat ${baseDir}${webDir}wp-config.php | grep DB_NAME | cut -d \' -f 4`
WPDBUSER=`cat ${baseDir}${webDir}wp-config.php | grep DB_USER | cut -d \' -f 4`
WPDBPASS=`cat ${baseDir}${webDir}wp-config.php | grep DB_PASSWORD | cut -d \' -f 4`
WPPREFIX=`cat ${baseDir}${webDir}wp-config.php | grep table_prefix | cut -d \' -f 2`

if [ -z ${WPDBNAME} ] | [ -z ${WPDBUSER} ] | [ -z ${WPDBPASS} ]; then
    echo "Unable to extract Database Information";
    exit 1
fi

# Create Parent Backups directory if not exists
if [ ! -d "${currBackupDir}" ]; then
    echo "Creating Backup directory..."
    mkdir -p ${currBackupDir}
fi

# Package Source Code
tar -C ${baseDir}${webDir} -cvzf ${currBackupDir}wp-src-${timeStamp}.gz .

# Package Database Code
mysqldump --user ${WPDBUSER} --password="${WPDBPASS}" ${WPDBNAME} > ${currBackupDir}wp-db-${timeStamp}.sql
