# Docker Dev Environment for WordPress

Use this Docker development environment repo to spin up WordPress a environment for one of many remote server connections. Here are the Docker services used:

* Wordpress - Latest
* MySQL - 5.7
* PhpMyAdmin - Latest

## Working with this Application

This application allows you to maintain multiple imported WordPress sites into individual docker containers. You can start a new site by running the `migration.sh` script. View more details within [ README ](dev/README.md)




## Docker to WordPress Development

In order to start the WordPress migration, follow the following steps:

1. Enter your websites name and site url into the local.config. This will be used with the `migration.sh` script
2. Check out WordPress Development [ README ](dev/README.md) before running the `migration.sh` script.


To start the migration of all source and database code from the remote server you must first run the `migration.sh` script. 
