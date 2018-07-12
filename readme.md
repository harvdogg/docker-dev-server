# Introduction
This is a very simplistic PHP development environment setup for doing real-time development of a PHP application, with mySQL and phpMyAdmin, via Docker.

# How to Use
The first step is to checkout this repo to a local working copy.

Once you have the copy locally, navigate to the directory you checked the repo out to and build the Dockerfile found here which will create a Docker Image available locally that is based on Alpine and features PHP 7.2

```
  docker build . -t dev-server:latest
```

From there, you can use the reference docker-compose file in order to setup whatever development environment you need. For your local projects, use the example defined in the sample "my_site".  Make sure you update the mounted volumes so that your local project directory gets correctly mounted to /var/app within the container.  By doing this, you're able to edit your files directly on your machine and see the changes in real-time wihtin Docker without the need to restart or rebuild the container.

The sample docker-compose file also contains a mySQL instance that will run MySQL 8 and exposes itself as 3306 to other machines and 3307 to your host machine. So if you have a locally installed mySQL client you can connect to it by directing  your client to "127.0.0.1:3307".
