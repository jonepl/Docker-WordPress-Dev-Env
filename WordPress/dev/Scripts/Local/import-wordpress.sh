#!/bin/bash

if [ $1 == "-c" ]; then
    SITENAME=`cat Scripts/Config/local.config | grep SITENAME | cut -d \= -f 2`
    SSHINFO=`cat Scripts/Config/local.config | grep SSHINFO | cut -d \= -f 2`
elif [ ! -z $1 ]; then
    SITENAME=$1
    SSHINFO=$2
fi

# Pulls src and db code from server
sh Scripts/Local/extract-from-server.sh ${SITENAME} ${SSHINFO}
if [ $? != "0" ]; then
    echo "Unable to extract content from server"
    exit 1
fi

# Prep local db directory
if [ ! -d ../db ]; then
    echo "db directory does not exist. Creating db directory"
    mkdir -p ../db
fi

if [ ! -z "$(ls -A ../db )" ]; then
    echo "db directory contains files. Cleaning db all files from directory"
    rm -rf ../db/*
fi

# Prep local src directory
if [ ! -d ../src ]; then
    echo "src directory does not exist. Creating db directory"
    mkdir -p ../src
fi

if [ ! -z "$(ls -A ../src )" ]; then
    echo "src directory contains files. Cleaning src all files from directory"
    rm -rf ../src/*
    rm -rf ../src/.*
fi


DBPATH=$(find Backups/Remote/${SITENAME}/*.sql)
DB=$(basename ${DBPATH})
SRCPATH=$(find Backups/Remote/${SITENAME}/*.gz)

if [ -z $DBPATH ] | [ -z $SRCPATH ]; then
    echo "Unable to find backup files"
fi

# Copy Backed up data to SRC and DB folder for Docker volumes
echo "Moving SQL files to db folder"
cp ${DBPATH} ../db
mv ../db/${DB} ../db/1-${DB}
cp Scripts/Sql/2-migrate-to-local.sql ../db

echo "Moving WordPress files to src folder"
tar -xzf ${SRCPATH} -C ../src/
if [ $? != "0" ]; then
    echo "Unable to untar src code files."
    exit 1
fi