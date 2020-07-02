#!/bin/bash

CONFIG=Scripts/Config/local.config.example
CONFIGDIR=Scripts/Config/

create_site_config(){
    echo "$0: Creating Config, Scripts and Backup directory"
    cat ${CONFIGDIR}local.config.example > ${CONFIGDIR}${SITENAME}/local.config
    sed -i '' "s#SITENAME=.*#SITENAME=$SITENAME#" ${CONFIGDIR}${SITENAME}/local.config
    sed -i '' "s#WEBSITEURL=.*#WEBSITEURL=$WEBSITEURL#" ${CONFIGDIR}${SITENAME}/local.config

    if [ $REMOTESYNC == "Y" ] || [ $REMOTESYNC == 'y' ]; then
        sed -i '' "s#REMOTESYNC=.*#REMOTESYNC=ENABLED#" ${CONFIGDIR}${SITENAME}/local.config
    else
        sed -i '' "s#WEBSITEURL=.*#WEBSITEURL=DISABLED#" ${CONFIGDIR}${SITENAME}/local.config
    fi

    if [ -f "${CONFIGDIR}private.config" ]; then
        echo "$0: Updating local.config with private info values..."
        SSHINFO=`cat ${CONFIGDIR}private.config | grep SSHINFO | cut -d \= -f 2`
        sed -i '' "s#SSHINFO=.*#SSHINFO=$SSHINFO#" ${CONFIGDIR}${SITENAME}/local.config
    fi
}

create_remote_scripts(){
    echo "$0: Creating remote scripts..."
    sh Scripts/Local/create-remote-scripts.sh ${SITENAME}
}

create_site_backupDir(){
    echo "$0: Creating backup directory..."
    mkdir -p Backups/${SITENAME}/Local/
    mkdir -p Backups/${SITENAME}/Remote/
}

if [ ! -e CONFIG ]; then
    echo "Enter your site name."
    read response;
    SITENAME=$response;

    echo "Enter your website url."
    read response;
    WEBSITEURL=$response;

    echo "Would you like to synchronousize site to your web server? (Y/N)"
    read response;
    REMOTESYNC=$response;

    if [ ! -d Scripts/Config/$SITENAME/ ]; then
        echo "$0: Generating ${SITENAME} folders and files..."
        mkdir -p Scripts/Config/$SITENAME/
    fi

    create_site_config
    create_remote_scripts 
    create_site_backupDir

    exit 0;
else
    echo "$0: Unable to find local.config.example"
    exit 1
fi
