#!bin/bash

# Pulls Database Information
SITENAME=$1
WPDBUSER=$2
WPDBNAME=$3
WPDBPASS=$4

# Validation
if [ -z ${WPDBUSER} ] | [ -z ${WPDBNAME} ] | [ -z ${WPDBPASS} ]; then
    echo "You must provide user, db name and password."
    exit
fi

# Create Backup Directory
timeStamp=$(date +%Y-%m-%d_%H-%M)
backupDir=/wp-dev/Backups/${SITENAME}/Local/

if [ -z ${WPDBNAME} ] | [ -z ${WPDBUSER} ] | [ -z ${WPDBPASS} ]; then
    echo "WordPress db name, username or password not specified. Unable to retrieve Database Information";
    exit 1
fi

# Package Database Code
mysqldump --user ${WPDBUSER} --password=${WPDBPASS} ${WPDBNAME} > ${backupDir}wp-db-${timeStamp}.sql
