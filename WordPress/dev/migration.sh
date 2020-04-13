#!/bin/bash

SITENAME=`cat Local/local.config | grep SITENAME | cut -d \= -f 2`
WEBSITEURL=`cat Local/local.config | grep WEBSITEURL | cut -d \= -f 2`
SSHINFO=`cat Local/local.config | grep SSHINFO | cut -d \= -f 2`

if [ -z $SITENAME ]; then
    echo "Please provide a site name within local.config"
    exit 1
fi

if [ -z $WEBSITEURL ]; then
    echo "Please provide the root web site url within local.config"
    exit 1
fi

import_wordpress () {
    echo "Importing Wordpress site from Server..."

    # Download data from Server. Drop SQL in ./db directory and Source code in ./src directory
    sh Local/import-wordpress.sh ${1} ${2}
    if [ $? != "0" ]; then
        echo "Unable to import wordpress"
        exit 1
    fi

    # Append WP prefix to config file
    sh Local/update-config.sh
    if [ $? != "0" ]; then
        echo "Unable to update config file"
        exit 1
    fi

    # Update sql migration dev
    WPPREFIX=`cat Local/local.config | grep PREFIX | cut -d \= -f 2`
    SITEURL=`cat Local/local.config | grep WEBSITEURL | cut -d \= -f 2`

    # # TODO: Error handling
    sed -i '' "s/UPDATE.*_options/UPDATE ${WPPREFIX}options/" ../db/2-migrate-to-local.sql
    sed -i '' "s/UPDATE.*_posts/UPDATE ${WPPREFIX}posts/" ../db/2-migrate-to-local.sql
    sed -i '' "s#'https://siteurl.com'#'${SITEURL}'#" ../db/2-migrate-to-local.sql
    
}

package_wordpress () {
    echo "Packaging Wordpress site for Server"
    sh Local/package-wordpress.sh
    if [ $? != "0" ]; then
        echo "Unable to package wordpress site"
        exit 1
    fi
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
