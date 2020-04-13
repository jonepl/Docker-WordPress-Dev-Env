# WordPress Dev Environment

Use this Docker development environment template to spin up docker images to host a clean Wordpress application. The services used are as follows:

* Wordpress - Latest
* MySQL - 5.7
* PhpMyAdmin - Latest

NOTE: I highly recommned updating the environment section of each service for development or production usage.

## Starting WordPress Environment

1. Create a `src` folder and `db` folder for you docker to mount to.

2. Spin up your WordPress environment by running the following command
```
$ docker-compose up -d
```

3. Open your browser of choice and navigate to localhost:8080 and follow the wizard. 8080 is the port defined in the docker-compose file for the WordPress service.Congrats, your WordPress site is all setup.

## Using PhpMyAdmin

To access your PhpMyAdmin navigate to localhost:8082. Enter your username: `root` and password `dbpassword` to gain access. Boom, you're in.

## Stopping WordPress Environment
```
$ docker-compose down
```

## Cleaning up WordPress Environment

This will wipe all stored data of your Wordpress instance.

```
$ docker-compose rm -s
```

NOTE: Docker saves all configures from when it was first initiailized. If you would like to start anew use the following command


## Docker to WordPress Development

In order to start the WordPress migration, follow the following steps:

1. Enter your websites name and site url into the local.config. This will be used with the `migration.sh` script
2. Check out WordPress Development [ README ](dev/WPDEV.md) before running the `migration.sh` script.


To start the migration of all source and database code from the remote server you must first run the `migration.sh` script. 
