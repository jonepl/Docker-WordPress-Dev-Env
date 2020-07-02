#!/bin/bash

SITENAME=null

# FUTURE UPDATE: Set SITENAME from imported data instead of running new command
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
    sed -i '' "s#'https://siteurl.com'#'${SITEURL%/}'#" ../db/2-migrate-to-local.sql
    sed -i '' "s#WORDPRESS_TABLE_PREFIX:.*#WORDPRESS_TABLE_PREFIX: ${WPPREFIX}#" ../docker-compose.yml
}

package_wordpress () {

    WPDBNAME=`cat Scripts/Config/${SITENAME}/local.config | grep DBNAME | cut -d \= -f 2`
    WPDBPASS=`cat Scripts/Config/${SITENAME}/local.config | grep DBPASS | cut -d \= -f 2`
    REMOTESYNC=`cat Scripts/Config/${SITENAME}/local.config | grep REMOTESYNC | cut -d \= -f 2`
    
    echo "$0: Packaging Wordpress site for Server"
    sh Scripts/Local/package-wordpress.sh $SITENAME

    if [ $? != "0" ]; then
        echo "$0: Unable to package wordpress site"
        exit 1
    fi

    sh Scripts/Local/prep-repos.sh $SITENAME
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

    if [ $? == "0" ]; then
        SITEPATH=`ls -td Backups/*/ | head -1`
        SITENAME=`basename $SITEPATH`
        REMOTESYNC=`cat Scripts/Config/${SITENAME}/local.config | grep REMOTESYNC | cut -d \= -f 2`

        if [ $REMOTESYNC == "enabled" ] || [ $REMOTESYNC == "ENABLED" ]; then
            echo "$0: Uploading scripts to remote server..."
            sh Scripts/Local/upload-server-scripts.sh $SITENAME
        fi
    fi

}

remove_wp_site(){

    echo "$0: Cleaning up Wordpress site ${SITENAME}..."
    sh Scripts/Local/remove-wp-site.sh ${SITENAME}

    DEVPATH=`pwd`

    CONFIGDIR="${DEVPATH}/Scripts/Config/${SITENAME}/"
    if [ -d $CONFIGDIR ]; then
        echo "$0: removing ${CONFIGDIR}"
        rm -rf ${CONFIGDIR}
    fi

    SCRIPTDIR="${DEVPATH}/Scripts/Remote/${SITENAME}/"
    if [ -d $SCRIPTDIR ]; then
        echo "$0: removing $SCRIPTDIR"
        rm -rf ${SCRIPTDIR}
    fi

    BACKUPDIR="${DEVPATH}/Backups/${SITENAME}/"
    if [ -d $BACKUPDIR ]; then
        echo "$0: removing ${BACKUPDIR}"
        rm -rf ${BACKUPDIR}
    fi
}

get_sitename(){
    sites=()
    INDEX=0

    echo "$0: Choose an option from your available sites:"

    for i in `find Scripts/Config/* -type d`
    do
        echo ${INDEX}. $(basename $i)
        sites+=($i)
        let INDEX=${INDEX}+1
    done

    if [ $INDEX == 0 ]; then
        echo "$0: You do not have any site available. Create on using the -n flag."
        exit 1
    fi
    
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

list_sitename(){

    sites=()
    INDEX=0
    
    echo "$0: Here is a list of site you have"

    for i in `find Scripts/Config/* -type d`
    do
        echo ${INDEX}. $(basename $i)
        sites+=($i)
        let INDEX=${INDEX}+1
    done

    if [ $INDEX == 0 ]; then
        echo "$0: You do not have any site available. Create on using the -n flag."
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
    -n      Start a new WordPress project
    -r      Remove an existing WordPress project
    -i      Import WordPress from server
    -p      Package WordPress used by docker Container
    -u      Upload server scripts
    -l      List all WordPress site names
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
        upload_server_scripts ${SITENAME}
        
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
    elif [ "$arg" == "--remove" ] || [ "$arg" == "-r" ]
    then
        get_sitename
        remove_wp_site        
        exit 0
    elif [ "$arg" == "--list" ] || [ "$arg" == "-l" ]
    then
        list_sitename
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
