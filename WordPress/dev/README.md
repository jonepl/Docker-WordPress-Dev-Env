# WordPress Development

## Usage

The migration scripts use a local.config file to save and pull sensitive WordPress information. Be sure to keep this in you .gitignore. To execute the below migration script help text use:

```
$ sh migration.sh 
```

## Typical Workflow

1. Update the values in [ local.config.example ](Scripts/Config/local.config.example) and rename the file local.config
2. Run `sh migration.sh -i`. This will import your wordpress from your remote server to your local machine.
3. Run docker-compose up -d
4. To access your WordPress site, use the same login as was used to access the remote server
5. Development your wordpress site
6. Run `sh migration.sh -p`. This will package your WordPress src and db changes into a gzip and sql db backup file.
7. Use the scripts generated in dev/Backups/Local/ to apply to your server using your preferred application method. (GIT, BashScript, Manual, etc)

## Useful Info

The Scripts directory contains all the scripts you will need to import and package your WordPress site for local development. There a multiple scripts that get call in order to retrieve the files from the remote server and package local src and db changes to be applied to the remote server.

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