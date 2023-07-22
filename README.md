# Gitea on Docker

Runs a minimal [Gitea](https://gitea.io) Docker deployment built on Debian 12.

## Features

* Built on Debian 12 for portability
* Uses a non-root user for security
* Only runs `git` and `gitea` in the container
* Simple `Dockerfile` and `docker-compose.yml` files
* One step deployment that creates a valid server on localhost

## Configuration

You should replace the [Gitea config file](app.ini) with your own.

See the official Gitea [config-cheat-sheet](https://docs.gitea.io/en-us/config-cheat-sheet/)
for more information on how to configure these settings.

## Build and Deploy

Building the container and deploying the service is simple.

### Build

```sh
docker build --target env-build  . --tag gitea-docker-build
docker build --target env-deploy . --tag gitea-docker
docker swarm init || true  # this only needs to be run once
```

### Deploy

```sh
docker stack deploy -c docker-compose.yml gitea-docker
```

There is also a [`Makefile`](Makefile) with shortcuts to these commands to build
and deploy the server more easily.
