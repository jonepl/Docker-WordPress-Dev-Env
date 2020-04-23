#!/bin/bash

SITENAME=`cat Scripts/Config/local.config | grep SITENAME | cut -d \= -f 2`
WEBSITEURL=`cat Scripts/Config/local.config | grep WEBSITEURL | cut -d \= -f 2`
SSHINFO=`cat Scripts/Config/local.config | grep SSHINFO | cut -d \= -f 2`

if [ -z $SITENAME ]; then
    echo "Please provide a site name within local.config"
    exit 1
fi

if [ -z $WEBSITEURL ]; then
    echo "Please provide the root web site url within local.config"
    exit 1
fi

if [ -z $WEBSITEURL ]; then
    echo "Please provide the <username>:<host> values within local.config to access your remote server."
    exit 1
fi

import_wordpress () {
    echo "Importing Wordpress site from Server..."

    # Download data from Server. Drop SQL in ./db directory and Source code in ./src directory
    sh Scripts/Local/import-wordpress.sh ${1} ${2}
    if [ $? != "0" ]; then
        echo "Unable to import wordpress"
        exit 1
    fi

    # Append WP prefix to config file
    sh Scripts/Local/update-config.sh
    if [ $? != "0" ]; then
        echo "Unable to update config file"
        exit 1
    fi

    # Update sql migration dev
    WPPREFIX=`cat Scripts/Config/local.config | grep PREFIX | cut -d \= -f 2`
    SITEURL=`cat Scripts/Config/local.config | grep WEBSITEURL | cut -d \= -f 2`

    # # TODO: Error handling
    sed -i '' "s/UPDATE.*_options/UPDATE ${WPPREFIX}options/" ../db/2-migrate-to-local.sql
    sed -i '' "s/UPDATE.*_posts/UPDATE ${WPPREFIX}posts/" ../db/2-migrate-to-local.sql
    sed -i '' "s#'https://siteurl.com'#'${SITEURL}'#" ../db/2-migrate-to-local.sql
    
}

package_wordpress () {
    echo "Packaging Wordpress site for Server"
    sh Scripts/Local/package-wordpress.sh
    if [ $? != "0" ]; then
        echo "Unable to package wordpress site"
        exit 1
    fi
}

update_config(){
    echo "Updating local.config from src folder"
    sh Scripts/Local/update-config.sh
}

new_project(){
    echo "Not yet Implemented..."
    # sh Scripts/Local/new-wp-project.sh
}

usage () {
    cat << EOF
usage: $0 options

This script is the entrypoint for importing and packaging your WordPress site remotely and locally

OPTIONS:
    -h      Show help message
    -i      Import WordPress from server
    -r      Package WordPress used by docker Container
EOF
}

usage_import() {
    echo "You must enter a site name and the webDir on the Server from the ~/ directory."
}

if [ $# -le 0 ]; then
    usage
    exit 1
fi

for arg in "$@"
do

    if [ "$arg" == "--import" ] || [ "$arg" == "-i" ]
    then
        import_wordpress ${SITENAME} ${SSHINFO}
        exit 0
    elif [ "$arg" == "--package" ] || [ "$arg" == "-p" ]
    then
        package_wordpress
        exit 0
    elif [ "$arg" == "--update" ] || [ "$arg" == "-u" ]
    then
        update_config
        exit 0
    elif [ "$arg" == "--new" ] || [ "$arg" == "-n" ]
    then
        new_project
        exit 0
    elif [ "$arg" == "--help" ] || [ "$arg" == "-h" ]
    then
        usage
        exit 0
    else 
        echo "Invalid command line arguement.\n"
        usage
        exit 0
    fi
done
