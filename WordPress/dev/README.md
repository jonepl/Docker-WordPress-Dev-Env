# WordPress Development

## Usage

The migration scripts use a local.config file to save and pull sensitive WordPress information. Be sure to keep this in you .gitignore. To execute the below migration script help text use:

```
$ sh migration.sh 
```

## Useful Info

This directory contains all the scripts you will need to import and package your WordPress site for local development. There a multiple scripts that get call in order to retrieve the files from the remote server.

### Scripts Call Stack 

```
migration.sh
|_ import-wordpress.sh          
    |_ extract-from-server.sh
    |   |_ server-wp-backup.sh
    |_ update-config.sh
|_ package-wordpress.sh
   |_ docker-wp-backup.sh
   |_ docker-db-backup.sh
```

NOTES:
* You should carefully examine `extract-from-server.sh` and `server-wp-backup.sh` before using. The paths used in this example may not be to your liking.
* The `server-wp-backup.sh` file must uploaded to your remote server. The path of this file should be updated within `extract-from-server.sh` 