#!/bin/bash

SITENAME=null

import_wordpress () {
    echo "$0: Importing Wordpress site from Server..."

    # Download data from Server. Drop SQL in ./db directory and Source code in ./src directory
    sh Scripts/Local/import-wordpress.sh ${1} ${2}
    if [ $? != "0" ]; then
        echo "$0: Unable to import wordpress"
        exit 1
    fi

    # Append WP credentials into local.config file
    sh Scripts/Local/update-config.sh ${1}
    if [ $? != "0" ]; then
        echo "$0: Unable to update config file"
        exit 1
    fi

    # Update sql migration dev
    WPPREFIX=`cat Scripts/Config/${SITENAME}/local.config | grep PREFIX | cut -d \= -f 2`
    SITEURL=`cat Scripts/Config/${SITENAME}/local.config | grep WEBSITEURL | cut -d \= -f 2`

    if [ -z $WPPREFIX ] || [ -z $SITEURL ]; then
        echo "$0: Unable to retrieve WPPREFIX or SITEURL from local.config."
        exit 1
    fi

    # # TODO: Error handling
    sed -i '' "s/UPDATE.*_options/UPDATE ${WPPREFIX}options/" ../db/2-migrate-to-local.sql
    sed -i '' "s/UPDATE.*_posts/UPDATE ${WPPREFIX}posts/" ../db/2-migrate-to-local.sql
    sed -i '' "s#'https://siteurl.com'#'${SITEURL}'#" ../db/2-migrate-to-local.sql
    
}

package_wordpress () {
    echo "$0: Packaging Wordpress site for Server"
    sh Scripts/Local/package-wordpress.sh $SITENAME
    if [ $? != "0" ]; then
        echo "$0: Unable to package wordpress site"
        exit 1
    fi
}

update_config(){
    echo "$0: Updating local.config from src folder"
    sh Scripts/Local/update-config.sh
}

validate_server_dir(){
    echo "$0: Validating server directory in local.config"
    sh Scripts/Local/validate-server.sh
}

new_wp_site(){
    echo "$0: Creating new Wordpress site..."
    sh Scripts/Local/new-wp-site.sh
}

get_sitename(){
    sites=()
    INDEX=0

    for i in `find Scripts/Config/* -type d`
    do
        echo ${INDEX}. $(basename $i)
        sites+=($i)
        let INDEX=${INDEX}+1
    done

    echo "$0: Which site would you like to use?"
    read choice;

    re='^[0-9]+$'
    if [ $choice -lt 0 ] || [ $choice -ge ${#sites[@]} ] || [ -z $choice ] || ! [[ $choice =~ $re ]]; then

        echo "Invalid options..."
        exit 1;
    fi

    SITENAME=$(basename ${sites[$choice]})
    WEBSITEURL=`cat Scripts/Config/${SITENAME}/local.config | grep WEBSITEURL | cut -d \= -f 2`
    SSHINFO=`cat Scripts/Config/${SITENAME}/local.config | grep SSHINFO | cut -d \= -f 2`

    if [ -z $SITENAME ]; then
    echo "$0: Please provide a site name within local.config"
    exit 1
    fi

    if [ -z $WEBSITEURL ]; then
        echo "$0: Please provide the root web site url within local.config"
        exit 1
    fi

    if [ -z $WEBSITEURL ]; then
        echo "$0: Please provide the <username>:<host> values within local.config to access your remote server."
        exit 1
    fi
}

upload_server_scripts(){
    echo "$0: Updating server scripts"
    sh Scripts/Local/upload-server-scripts.sh $SITENAME
}

usage () {
    cat << EOF
usage: $0 options

This script is the entrypoint for importing and packaging your WordPress site remotely and locally

OPTIONS:
    -h      Show help message
    -i      Import WordPress from server
    -p      Package WordPress used by docker Container
    -u      Update local WordPress configuration information
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
        get_sitename
        import_wordpress ${SITENAME} ${SSHINFO}
        exit 0
    elif [ "$arg" == "--package" ] || [ "$arg" == "-p" ]
    then
        get_sitename
        package_wordpress ${SITENAME}
        exit 0
    elif [ "$arg" == "--upload" ] || [ "$arg" == "-u" ]
    then
        get_sitename
        upload_server_scripts
        #update_config ${SITENAME}
        
        exit 0
    elif [ "$arg" == "--validate" ] || [ "$arg" == "-v" ]
    then
        get_sitename
        validate_server_dir ${SITENAME}
        exit 0
    elif [ "$arg" == "--new" ] || [ "$arg" == "-n" ]
    then
        new_wp_site
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
