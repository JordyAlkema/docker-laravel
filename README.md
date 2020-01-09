# Docker Laravel
Easily run Laravel in docker for production and development environments.

## Usage
1. Copy the ```Dockerfile``` into the root of the Laravel project.
2. Create a new (or copy an existing) ```.env``` file and name it ```.env.docker```, this is the env file the docker container will use.
3. Build the container using ```docker image build .``` while in the project folder

## Thanks to...
[richarvey/nginx-php-fpm](https://github.com/richarvey/nginx-php-fpm) - For the awesome docker container this is based on.