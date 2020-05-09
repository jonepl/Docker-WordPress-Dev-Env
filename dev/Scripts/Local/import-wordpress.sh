#!/bin/bash

if [ ! -z $1 ] | [ ! -z $2 ]; then
    SITENAME=$1
    SSHINFO=$2
else
    echo "No site name or ssh info."
    exit 1
fi

# Pulls src and db code from server
sh Scripts/Local/extract-from-server.sh ${SITENAME} ${SSHINFO}
if [ $? != "0" ]; then
    echo "$0: Unable to extract content from server"
    exit 1
fi

# Prep local db directory
if [ ! -d ../db ]; then
    echo "$0: db directory does not exist. Creating db directory"
    mkdir -p ../db
fi

if [ ! -z "$(ls -A ../db )" ]; then
    echo "$0: db directory contains files. Cleaning db all files from directory"
    rm -rf ../db/*
fi

# Prep local src directory
if [ ! -d ../src ]; then
    echo "$0: src directory does not exist. Creating db directory"
    mkdir -p ../src
fi

if [ ! -z "$(ls -A ../src )" ]; then
    echo "$0: src directory contains files. Cleaning src all files from directory"
    rm -rf ../src/*
    rm -rf ../src/.*
fi

DBPATH=$(ls -t Backups/${SITENAME}/Remote/*.sql | head -1)
DB=$(basename ${DBPATH})
SRCPATH=$(ls -t Backups/${SITENAME}/Remote/*.gz | head -1)

if [ -z $DBPATH ] || [ -z $SRCPATH ]; then
    echo "$0: Unable to find backup files"
    exit 1
fi

# Copy Backed up data to SRC and DB folder for Docker volumes
echo "$0: Moving extracted SQL files to the shared db folder"
cp ${DBPATH} ../db
mv ../db/${DB} ../db/1-${DB}
cp Scripts/Sql/2-migrate-to-local.sql ../db

echo "$0: Moving extracted WordPress files to the shared src folder ${SRCPATH}"
tar -xzf ${SRCPATH} -C ../src/
if [ $? != "0" ]; then
    echo "$0: Unable to untar src code files."
    exit 1
fi
