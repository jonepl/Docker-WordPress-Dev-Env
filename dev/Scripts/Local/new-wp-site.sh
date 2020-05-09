#!/bin/bash

CONFIG=Scripts/Config/local.config.example

create_site_config(){
    echo "$0: Creating Config, Scripts and Backup directory"
    cat Scripts/Config/local.config.example > Scripts/Config/${SITENAME}/local.config
    sed -i '' "s#SITENAME=.*#SITENAME=$SITENAME#" Scripts/Config/${SITENAME}/local.config
    sed -i '' "s#WEBSITEURL=.*#WEBSITEURL=$WEBSITEURL#" Scripts/Config/${SITENAME}/local.config
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

    if [ ! -d Scripts/Config/$SITENAME/ ]; then
        echo "$0: Generating ${SITENAME} folders and files..."
        mkdir -p Scripts/Config/$SITENAME/
    fi

    create_site_config
    create_remote_scripts 
    create_site_backupDir
else
    echo "$0: Unable to find local.config.example"
    exit 1
fi
