# WordPress Dev Environment

Use this Docker development environment template to spin up docker images to host a clean Wordpress application. The services used are as follows:

* Wordpress - Latest
* MySQL - 5.7
* PhpMyAdmin - Latest

NOTE: I highly recommned updating the environment section of each service for development or production usage.

## Starting WordPress Environment
Spin up your WordPress environment by running the following command
```
$ docker-compose up -d
```

Open your browser of choice and navigate to localhost:8080 and follow the wizard. 8080 is the port defined in the docker-compose file for the WordPress service.Congrats, your WordPress site is all setup.

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


## Load existing WordPress Application

### Setting Up Existing Database

Download all your WordPress SQL files into the `db` folder. Next, within your `docker-compose.yml` under the MySQL services `uncomment` the volumes section. This will dump the content of your SQL script into the docker container and mount the local and docker directories.

### Setting Up Existing Source Code

Download all your source code files into the `src` folder. Next, within your `docker-compose.yml` under the wordpress services `uncomment` the volumes section. This will establish a symlink of all the files in the src directory and var/www/html in the docker container.