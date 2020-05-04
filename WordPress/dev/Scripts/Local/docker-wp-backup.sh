#!bin/bash

SITENAME=$1
if [-z ${SITENAME}]; then
    echo "$0: Invalid Sitename."
    exit 1
fi

# Default local for all wordpress files in docker container
webDir=/var/www/html/

# Pulls Datbase Information
WPDBNAME=`cat ${webDir}wp-config.php | grep DB_NAME | cut -d \' -f 4`
WPDBUSER=`cat ${webDir}wp-config.php | grep DB_USER | cut -d \' -f 4`
WPDBPASS=`cat ${webDir}wp-config.php | grep DB_PASSWORD | cut -d \' -f 4`
WPPREFIX=`cat ${webDir}wp-config.php | grep table_prefix | cut -d \' -f 2`

if [-z ${WPDBNAME} ] || [-z ${WPDBUSER} ] || [-z ${WPDBPASS} ] || [-z ${WPPREFIX} ]; then
    echo "$0: Unable to pull site information from local.config"
    exit 1
fi

# Create Backup Directory Path
timeStamp=$(date +%Y-%m-%d_%H-%M)
backupDir=/wp-dev/Backups/${SITENAME}/Local/

# Create Backup Directory
if [ ! -d "${backupDir}" ]; then
    echo "Creating parent backups directory..."
    mkdir -p ${backupDir}
fi

# Package Source Code
tar -C ${webDir} --overwrite -cvzf ${backupDir}wp-src-${timeStamp}.gz .
