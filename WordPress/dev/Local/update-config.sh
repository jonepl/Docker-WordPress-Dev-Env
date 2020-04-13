#!/bin/bash

if [ ! -f "../src/wp-config.php" ]; then
    echo "Your source code folder does not contain a wp-config.php file. Please import Wordpress files."
    exit 1
fi

DBNAME=`cat Local/local.config | grep DBNAME | cut -d \= -f 2`
DBUSER=`cat Local/local.config | grep DBUSER | cut -d \' -f 2`
DBPASS=`cat Local/local.config | grep DBPASS | cut -d \' -f 2`
PREFIX=`cat Local/local.config | grep PREFIX | cut -d \' -f 2`

WPDBNAME=`cat ../src/wp-config.php | grep DB_NAME | cut -d \' -f 4`
WPDBUSER=`cat ../src/wp-config.php | grep DB_USER | cut -d \' -f 4`
WPDBPASS=`cat ../src/wp-config.php | grep DB_PASSWORD | cut -d \' -f 4`
WPPREFIX=`cat ../src/wp-config.php | grep table_prefix | cut -d \' -f 2`

if [ -z $WPDBNAME ] | [ -z $WPDBNAME ] | [ -z $WPDBNAME ] | [ -z $WPDBNAME ]; then
    echo "Something went wrong extracting database information from wp-config.php."
    exit 1
fi


if [ -z $DBNAME ]; then
    echo "Appending Database name to local.config"
    echo "" >> ./Local/local.config
    echo "DBNAME=${WPDBNAME}" >> ./Local/local.config
else
    # TODO: complete logic
    echo "Updating Database name in local.config"
fi

if [ -z $DBUSER ]; then
    echo "Appending Database user to local.config"
    echo "DBUSER=${WPDBUSER}" >> ./Local/local.config
else
    # TODO: complete logic
    echo "Updating Database user in local.config"
fi

if [ -z $PREFIX ]; then
    echo "Appending Database prefix to local.config"
    echo "PREFIX=${WPPREFIX}" >> ./Local/local.config
else
    # TODO: complete logic
    echo "Updating Database prefix in local.config"
fi

if [ -z $DBPASS ]; then
    echo "Appending Database password to local.config"
    echo "DBPASS=$WPDBPASS" >> ./Local/local.config
else
    # TODO: complete logic
    echo "Updating Database password in local.config"
fi
