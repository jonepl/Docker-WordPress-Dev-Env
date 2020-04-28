#!/bin/bash

if [ ! -f "../src/wp-config.php" ]; then
    echo "Your source code folder does not contain a wp-config.php file. Please import Wordpress files."
    exit 1
fi

SITENAME=$1

if [ -z $SITENAME ]; then
    echo "$0: Invalid Site name"
    exit 1
fi

DBNAME=`cat Scripts/Config/${SITENAME}/local.config | grep DBNAME | cut -d \= -f 2`
DBUSER=`cat Scripts/Config/${SITENAME}/local.config | grep DBUSER | cut -d \' -f 2`
DBPASS=`cat Scripts/Config/${SITENAME}/local.config | grep DBPASS | cut -d \' -f 2`
PREFIX=`cat Scripts/Config/${SITENAME}/local.config | grep PREFIX | cut -d \' -f 2`

WPDBNAME=`cat ../src/wp-config.php | grep DB_NAME | cut -d \' -f 4`
WPDBUSER=`cat ../src/wp-config.php | grep DB_USER | cut -d \' -f 4`
WPDBPASS=`cat ../src/wp-config.php | grep DB_PASSWORD | cut -d \' -f 4`
WPPREFIX=`cat ../src/wp-config.php | grep table_prefix | cut -d \' -f 2`

if [ -z $WPDBNAME ] | [ -z $WPDBNAME ] | [ -z $WPDBNAME ] | [ -z $WPDBNAME ]; then
    echo "Something went wrong extracting database information from wp-config.php."
    exit 1
fi


if [ -z $DBNAME ]; then
    echo "$0: Appending Database name to local.config"
    echo "" >> ./Scripts/Config/${SITENAME}/local.config
    echo "DBNAME=${WPDBNAME}" >> ./Scripts/Config/${SITENAME}/local.config
else
    # TODO: complete logic
    echo "$0: Updating Database name in local.config"
fi

if [ -z $DBUSER ]; then
    echo "$0: Appending Database user to local.config"
    echo "DBUSER=${WPDBUSER}" >> ./Scripts/Config/${SITENAME}/local.config
else
    # TODO: complete logic
    echo "$0: Updating Database user in local.config"
fi

if [ -z $PREFIX ]; then
    echo "$0: Appending Database prefix to local.config"
    echo "PREFIX=${WPPREFIX}" >> ./Scripts/Config/${SITENAME}/local.config
else
    # TODO: complete logic
    echo "$0: Updating Database prefix in local.config"
fi

if [ -z $DBPASS ]; then
    echo "$0: Appending Database password to local.config"
    echo "DBPASS=$WPDBPASS" >> ./Scripts/Config/${SITENAME}/local.config
else
    # TODO: complete logic
    echo "$0: Updating Database password in local.config"
fi
