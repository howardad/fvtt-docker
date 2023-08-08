# fvtt-docker

This repo provides an easy way to run multiple instances of Foundry Virtual Tabletop using Docker, Traefik and Portainer.

Docker is a container system that is used to deploy the services and Foundry instances running on your server.  Each Docker container runs a single service in isolation from the other containers running on your server.

Traefik is a reverse-proxy service that can take incoming requests to your server and route them to the correct backend.  In this case, one or more subdomains can be configured to point at your server (e.g. `foundry-prod.myserver.com` and `foundry-dev.myserver.com`), and Traefik figures out which Foundry instance to connect you to based on the subdomain used.

Portainer is a container management system that makes it easier to monitor, configure and manage the Docker containers deployed on your server.

Inspired by this guide: https://benprice.dev/posts/fvtt-docker-tutorial/
Using Felddy's Foundry image: https://github.com/felddy/foundryvtt-docker

# Guide

## Prerequisites

 - This guide assumes basic familiarity with Linux.  In particular, this guide was written with Debian in mind and the scripts are written for the Bash shell.  But this guide can likely be adapted relatively easily for other Linux distributions or shells.  
 - Docker and docker-compose
 - A valid domain pointing at your server.
 - Two subdomains to be used for Traefik and Portainer (e.g. `monitor.mysite.com` for Traefik and `manage.mysite.com` for Portainer).
 - Additional subdomains for each instance of Foundry you plan on running (you can start with one; more can easily be added later).
 - A [Foundry VTT](https://foundryvtt.com/) account.  Please follow [Foundry's license agreement](https://foundryvtt.com/article/license/) and ensure you have an appropriate number of software licenses purchased based on the number of Foundry instances you will be running and their intended usage.

## Traefik and Portainer

After cloning the repo, run `init_traefik.sh` and `init_portainer.sh` from the repo's root directory.  These scripts will prompt you for all the inputs necessary to generate the files needed for these services.  The following files will be generated:

 - traefik/docker-compose.yaml
 - traefik/traefik.yml
 - traefik/dynamic\_conf.yml
 - portainer/docker-compose.yaml

Further customization can be made as needed to the generated files; they will not be tracked by git.  However, rerunning these scripts will reinitialize and overwrite the generated files.

Run the following commands to bring up both services:

```
cd traefik
docker-compose up -d
cd ../portainer
docker-compose up -d
cd ..
```

Wait a few minutes, and both services should become available at the hosts you provided to the init scripts.  If you need to reconfigure either service, simply `cd` into the directory for that service, run `docker-compose down`, make your changes, then bring the service back up with `docker-compose up -d`.

## Foundry

First, ensure you have a secrets.json with the following contents (placed in the `fvtt` directory):

```
{
  "foundry_admin_key": "<admin password you will use to manage your foundry instance>",
  "foundry_password": "<password used to log into your foundry account at foundryvtt.com>",
  "foundry_username": "<username used to log into your foundry account at foundryvtt.com>"
}
```

Next, make sure you have a directory established for the instance of Foundry you'll be running.  Once you do, update `docker-compose.yaml` with the correct path under `services.foundry.volumes.source`.  You don't have to use `${INSTANCE_NAME}` in the path, but doing so can help keep the directories for your various instances organized.

To bring up a default instance of Foundry, simply run the following:

```
cd fvtt
docker-compose --env_file=.config/.env.default up -d
cd ..
```

To customize your instances, simply copy `.config/.env.default` and modify the contents as needed.  Then, when bringing up a new foundry instance, specify your desired env file in the `env_file` argument as with the above example.

### Env Variables

- `COMPOSE_PROJECT_NAME` - Unique name for this docker-compose project.  This _must_ be unique across all running instances of Foundry.  Recommended that this be the same as `INSTANCE_NAME`, but it doesn't have to be.
- `INSTANCE_NAME` - The subdomain you are using for this foundry instance (e.g. if you intend to use `foundry-prod.mysite.com` to access this instance, this should be `foundry-prod`. 
- `FOUNDRY_LICENSE_KEY` - License key to be used for this foundry instance.  Can either be the raw value of the key itself, or an index (starting from 1) of the key as listed in your account details on foundryvtt.com.  If unset, a random key will be chosen from your account.
- `DEFAULT_WORLD` - Optional.  The world that should be launched by default for this instance whenever it is started.
