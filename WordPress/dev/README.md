# WordPress Development

## Usage


The `migration.sh` scripts use a local.config file for each website. This file holds site credentials and app information which the development scripts use to integrated between Remote and Local environments. Be sure to keep this in you `.gitignore`. To see helpful application usage run command:

```
$ sh migration.sh -h
```
## Typical Workflow

1. Create/Retrieve WordPress sitename, site url and SSH information. 
2. Start a new site project `sh migration.sh -n`. Once created update, Update the local.config file with Scripts/Config/${SITENAME}/
3. Upload remote scripts to remote server. `sh migration.sh -u`
4. Import remote website into project. `sh migration.sh -i`
5. Start `docker-compose up -d`
6. Develop your wordpress site. Access site in your browser using localhost:8080 and PhpMyAdmin localhost:8082
7. Package wordpress. `sh migration.sh -p`
8. Apply to remote server using you method of choice (GIT, BashScript, Manual, etc).

*NOTE: You are not required to a remote WordPress environment to use this tool. Just run step #2 and #5 start developing you local WordPress site.*

## Working with Docker 

### Start Docker Wordpress container

```
$ docker-compose up -d
```

### Stop WordPress Environment
```
$ docker-compose down
```

### Clean up WordPress Environment

This will wipe all stored data of your Wordpress instance.

```
$ docker-compose rm -s
```

## Using PhpMyAdmin

To access your PhpMyAdmin navigate to localhost:8082. Enter your username: `root` and password `password` to gain access. Boom, you're in.

## Useful Info

The Scripts/Local directory contains all the scripts you will need to import and package your WordPress site for local development. There a multiple scripts that get call in order to retrieve the files from the remote server and package local src and db changes to be applied to the remote server.

### Scripts Call Stack 

```
migration.sh
|_ import-wordpress.sh          
  | |_ extract-from-server.sh
  |    |_ server-wp-backup.sh
  |_ update-config.sh
|_ package-wordpress.sh
   |_ docker-wp-backup.sh
   |_ docker-db-backup.sh
|_ upload-server-scripts.sh
```

NOTES:
* You should carefully examine `extract-from-server.sh` and `server-wp-backup.sh` before using. The paths used in this example may not be to your liking.
* The `server-wp-backup.sh` file must uploaded to your remote server. The path of this file should be updated within `extract-from-server.sh` 