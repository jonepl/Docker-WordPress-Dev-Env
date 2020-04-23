#!/bin/bash

if [ $1 == "-c" ] | [ $1 == "--config"]; then
    DBNAME=`cat Scripts/Config/local.config | grep SITENAME | cut -d \= -f 2`
elif [ ! -z $1 ]; then
    DBNAME=$1
fi

WPDBUSER=root
WPDBNAME=`cat ../docker-compose.yml | grep MYSQL_DATABASE | cut -d \: -f 2 | sed -e 's/^[[:space:]]*//'`
WPDBPASS=`cat ../docker-compose.yml | grep MYSQL_ROOT_PASSWORD | cut -d \: -f 2 | sed -e 's/^[[:space:]]*//'`


echo "Starting Docker..."
docker-compose up -d

# Packages source code
echo "Executing docker backup script for src changes."
docker exec wordpress sh /wp-dev/Scripts/Local/docker-wp-backup.sh

# Packages database code
echo "Executing docker backup script for src changes."
docker exec mysql sh /wp-dev/Scripts/Local/docker-db-backup.sh ${WPDBUSER} ${WPDBNAME} ${WPDBPASS}
