#!/bin/bash



CONFIG=Scripts/Config/local.config

if [ ! -f Scripts/Config/local.config ]; then
    echo "Creating local.config"
else
    echo "Do you want to overwrite existing local.config? y/n?"
    read response;

    if [ "$response" == "y" ] || [ "$response" == "yes" ]; then
        echo "Creating new local.config"
        printf "" > $CONFIG
    else
        echo "Unable to understand your response"
    fi
fi

echo "What is the name of your site?"
read SITENAME;

echo "What is the url of this site?"
read WEBSITEURL;

echo "What is the ssh username and host? format user@host"
read SSHINFO;

echo "SITENAME=$SITENAME" >> $CONFIG
echo "WEBSITEURL=$WEBSITEURL" >> $CONFIG
echo "SSHINFO=$SSHINFO" >> $CONFIG
 
# realpath() {
#     [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
# }


# if [ $0 == "new-wp-project.sh" ]; then
#     echo `pwd ../Config/Local.config`
# else

# if

# echo $0

# echo `realpath $0`

