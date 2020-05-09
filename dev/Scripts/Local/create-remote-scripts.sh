#!/bin/bash

# Creates scripts Directories
SITENAME=$1
GITROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep GITROOTDIR | cut -d \= -f 2`
DEVROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep DEVROOTDIR | cut -d \= -f 2`
WEBROOTDIR=`cat Scripts/Config/${SITENAME}/local.config | grep WEBROOTDIR | cut -d \= -f 2`
WEBSITEURL=`cat Scripts/Config/${SITENAME}/local.config | grep WEBSITEURL | cut -d \= -f 2`

if [ -z $SITENAME ] || [ -z $GITROOTDIR ] || [ -z $DEVROOTDIR ] || [ -z $WEBROOTDIR ] || [ -z $WEBSITEURL ]; then
    echo "$0: Unable to read local.config"
    exit 1;
fi

GITDIR=${GITROOTDIR}${SITENAME}/${SITENAME}.git/
TEMPWEBDIR=${GITROOTDIR}www/
WEBDIR=${WEBROOTDIR}
SCRIPTDIR=${DEVROOTDIR}${SITENAME}/


if [ ! -d Scripts/Remote/${SITENAME}/ ]; then
    echo "$0: The local directory for Remote script does not exist. Creating directory..."
    mkdir -p Scripts/Remote/${SITENAME}/
else
    echo "$0: Local directory for Remote scripts found."
fi

cp -R Scripts/Remote/TemplateScripts/. Scripts/Remote/${SITENAME}/

# Generate server-init-repo.sh
sed -i '' "s#SITENAME=.*#SITENAME=$SITENAME#" Scripts/Remote/${SITENAME}/server-init-repo.sh.example
sed -i '' "s#GITROOTDIR=.*#GITROOTDIR=$GITROOTDIR#" Scripts/Remote/${SITENAME}/server-init-repo.sh.example
sed -i '' "s#DEVROOTDIR=.*#DEVROOTDIR=$DEVROOTDIR#" Scripts/Remote/${SITENAME}/server-init-repo.sh.example
sed -i '' "s#WEBROOTDIR=.*#WEBROOTDIR=$WEBDIR#" Scripts/Remote/${SITENAME}/server-init-repo.sh.example
mv Scripts/Remote/${SITENAME}/server-init-repo.sh.example Scripts/Remote/${SITENAME}/server-init-repo.sh

# Generate post-receive
sed -i '' "s#SITENAME=.*#SITENAME=$SITENAME#" Scripts/Remote/${SITENAME}/post-receive.example
sed -i '' "s#GITROOTDIR=.*#GITROOTDIR=$GITROOTDIR#" Scripts/Remote/${SITENAME}/post-receive.example
sed -i '' "s#DEVROOTDIR=.*#DEVROOTDIR=$DEVROOTDIR#" Scripts/Remote/${SITENAME}/post-receive.example
sed -i '' "s#WEBROOTDIR=.*#WEBROOTDIR=$WEBDIR#" Scripts/Remote/${SITENAME}/post-receive.example
sed -i '' "s#WEBSITEURL=.*#WEBSITEURL=$WEBSITEURL#" Scripts/Remote/${SITENAME}/post-receive.example
mv Scripts/Remote/${SITENAME}/post-receive.example Scripts/Remote/${SITENAME}/post-receive

# Generate server-wp-backup.sh.example
sed -i '' "s#SITENAME=.*#SITENAME=$SITENAME#" Scripts/Remote/${SITENAME}/server-wp-backup.sh.example
sed -i '' "s#GITROOTDIR=.*#GITROOTDIR=$GITROOTDIR#" Scripts/Remote/${SITENAME}/server-wp-backup.sh.example
sed -i '' "s#DEVROOTDIR=.*#DEVROOTDIR=$DEVROOTDIR#" Scripts/Remote/${SITENAME}/server-wp-backup.sh.example
sed -i '' "s#WEBROOTDIR=.*#WEBROOTDIR=$WEBDIR#" Scripts/Remote/${SITENAME}/server-wp-backup.sh.example
mv Scripts/Remote/${SITENAME}/server-wp-backup.sh.example Scripts/Remote/${SITENAME}/server-wp-backup.sh

# Generate server-wp-import.sh.example
sed -i '' "s#SITENAME=.*#SITENAME=$SITENAME#" Scripts/Remote/${SITENAME}/server-wp-import.sh.example
sed -i '' "s#GITROOTDIR=.*#GITROOTDIR=$GITROOTDIR#" Scripts/Remote/${SITENAME}/server-wp-import.sh.example
sed -i '' "s#DEVROOTDIR=.*#DEVROOTDIR=$DEVROOTDIR#" Scripts/Remote/${SITENAME}/server-wp-import.sh.example
sed -i '' "s#WEBROOTDIR=.*#WEBROOTDIR=$WEBDIR#" Scripts/Remote/${SITENAME}/server-wp-import.sh.example
sed -i '' "s#SITEURL=.*#SITEURL=$WEBSITEURL#" Scripts/Remote/${SITENAME}/server-wp-import.sh.example
mv Scripts/Remote/${SITENAME}/server-wp-import.sh.example Scripts/Remote/${SITENAME}/server-wp-import.sh
