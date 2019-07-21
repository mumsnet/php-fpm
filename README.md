# PHP image with FPM (FastCGI) support

This repo is used to generate base PHP images that include FPM, the FastCGI processor commonly used for PHP webapps.
All the usual extensions are already built in the image, including support for mysql.  `composer` is also installed
in the image to allow you to manage your packages within Docker.  Currently PHP version 7.3 is supports, but new
versions can be added easily - just follow the instructions below.

## FPM port number

The default port number for FPM is 9000 and as Mumsnet runs multiple microservices, all running on PHP,
it's important that each one runs on a unique port.  Follow the instructions below when building your 
new Docker image to ensure it runs on a unique port.

## How to use this as a base image

Just create a Dockerfile like this:

```
FROM mumsnet/php-fpm:7.3

# Install whatever framework you need like lumen, laravel etc
# RUN apt-get install -y ...

# Set the FPM port number.  Change 9000 to your own number
ENV FPM_PORT 9000
RUN sed -i "s/9000/${FPM_PORT}/" /usr/local/etc/php-fpm.d/zz-docker.conf
EXPOSE ${FPM_PORT}
```

## How to add support for new versions of PHP

Let's say you want to add support for PHP 7.4:

1. Duplicate the `v7.3` folder to `v7.4`
2. Edit the Dockerfile and change `7.3` to `7.4`
3. Build the image with `docker build -t php-fpm .` to ensure you have no errors
4. Login to our central hub.docker.com account
5. Click on "Configure automated builds" for the php-fpm repo
6. Under build rules, click `+` to add a new build rule
7. Make it the same as the 7.3 rule, but use 7.4 for the values
8. Click Save
9. Push your changes to the master branch of this repo

That will then trigger an automated build on docker and you'll have your new image in a short while.

