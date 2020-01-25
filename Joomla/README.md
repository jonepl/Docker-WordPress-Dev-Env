# Joomla Dev Environment

Use this Docker development environment template to spin up docker images to host a clean Joomla application. The services used are as follows:

* Joomla - Latest
* MySQL - 5.6

NOTE: I Recommned updating the environment section of each service for production usage.

## Starting Joomla Environment
Read about Docker compose to explain what this does
```
$ docker-compose up
```

Next, open your browser of choice and navigate to localhost:8080. 8080 is the port defined in the docker-compose file for the Joomla service.

NOTE: Docker saves all configures from when it was first initiailized. If you would like to start anew use the following command

```
$ docker-compose rm
```

## Load existing Joomla Application

### Setting Up Existing Database

Download all your Joomla SQL files into the `db` folder. Next, within your `docker-compose.yml` under the MySQL services `uncomment` the volumes section. This will dump the content of your SQL script into the docker container and mount the local and docker directories.

### Setting Up Existing Source Code

Download all your source code files into the `src` folder. Next, within your `docker-compose.yml` under the Joomla services `uncomment` the volumes section. This will establish a symlink of all the files in the src directory and var/www/html in the docker container.