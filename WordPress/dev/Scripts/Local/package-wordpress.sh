#!/bin/bash

SITENAME=$1
WPDBUSER=root
WPDBNAME=`cat ../docker-compose.yml | grep MYSQL_DATABASE | cut -d \: -f 2 | sed -e 's/^[[:space:]]*//'`
WPDBPASS=`cat ../docker-compose.yml | grep MYSQL_ROOT_PASSWORD | cut -d \: -f 2 | sed -e 's/^[[:space:]]*//'`

if [ -z $SITENAME ] || [ -z $WPDBNAME] || [ -z $WPDBPASS]; then
    echo "$0: Invalid site name, db name or db password."
    exit 1
fi

#TODO: Cleaup directory before packaging
rm -rf Backups/${SITENAME}/Local/*.sql
rm -rf Backups/${SITENAME}/Local/*.gz

echo "Starting Docker..."
docker-compose up -d

# Packages source code
echo "$0: Executing docker backup script for src changes."
docker exec wordpress sh /wp-dev/Scripts/Local/docker-wp-backup.sh ${SITENAME}

# Packages database code
echo "$0: Executing docker backup script for src changes."
docker exec mysql sh /wp-dev/Scripts/Local/docker-db-backup.sh ${SITENAME} ${WPDBUSER} ${WPDBNAME} ${WPDBPASS}

cp Scripts/Sql/2-migrate-to-server.sql Backups/${SITENAME}/Local/

echo "$0: Completed packaging of Local WordPress site."
exit 0