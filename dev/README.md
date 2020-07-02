# WordPress Development

## Usage


The `migration.sh` scripts use a local.config file for each website. This file holds site credentials and app information which the development scripts use to integrated between Remote and Local environments. Be sure to keep this in you `.gitignore`. To see helpful application usage run command:

```
$ sh migration.sh -h
```
## Typical Workflow

1. Start a new site project `sh migration.sh -n`. 
   - This will generate **Config**, remote **Script** and **Backup** which contains a corresponding *SITENAME* directory that holds the WordPress site information for each new WordPress site. If synchronize site is Y, the app will automatically push remote bash scripts to your web server

2. Update the newly generate local.config file within dev/Config/${SITENAME} with your ssh host information. 

    ``` 
    SSHINFO=123.456.78.901 
    ```

   * Your app can contain a private.config file that specifies person information that can automatically populate repetitve information. Ex SSHINFO. You can manually perform the same action with step 3

3. Upload remote scripts to remote server using `sh migration.sh -u`. 
   - This will generate remote scripts within dev/Remote/${SITENAME} and upload them to you remote server
4. Import existing remote website into project. `sh migration.sh -i`
   * This step is recommended if you are planning to push your local WordPress environment up to a remote web server. There are a few differences between a web host's installation of WordPress and a Docker WordPress image that will make the migration process more difficult if you attempt to export WordPress for the Docker image.
5. Start `docker-compose up -d`
6. Develop your wordpress site. Access site in your browser using localhost:8080 and PhpMyAdmin localhost:8082
7. Package wordpress. `sh migration.sh -p`. 
   * This step will gzip all source code and creaet a sql backup and store it with `dev/Backups/${SITENAME}/Local` and initialize empty repository there and . 
8. Set up SSH from your GIT repo to your Web Host and the PROD_SERVER repository variable and push your changes. GIT will maintain all previous versions of WordPress. ENSURE YOUR REPOSITORY IS PRIVATE FOR PRODUCTION USE. 

*NOTE: You are not required to a remote WordPress environment to use this tool. Just run step #2 and #6 start developing you local WordPress site.*


*NOTE: *

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