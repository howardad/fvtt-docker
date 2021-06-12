# fvtt-docker

This repo provides an easy way to dockerize multiple instances of Foundry Virtual Tabletop using Traefik and Portainer.

Inspired by this guide: https://benprice.dev/posts/fvtt-docker-tutorial/
Using Felddy's Foundry image: https://github.com/felddy/foundryvtt-docker

# Guide

## Prerequisites

 - Docker and docker-compose

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

First, ensure you have a secrets.json with the following contents:

```
{
  "foundry_admin_key": "<password used to log into your foundry instance>"
  "foundry_password": "<password used to log into your foundry account at foundryvtt.com>"
  "foundry_username": "<username used to log into your foundry account at foundryvtt.com>"
}
```

To bring up a default instance of Foundry, simply run the following:

```
cd fvtt
docker-compose --env_file=.config/.env.default up -d
cd ..
```

To customize your instances, simply copy `.config/.env.default` and modify the contents as needed.  Then, when bringing up a new foundry instance, specify your desired env file in the `env_file` argument as with the above example.

### Env Variables

- COMPOSE\_PROJECT\_NAME - Unique name for this docker-compose project.  I recommend using `foundry-<instance_name>` for consistency.  This _must_ be unique across all running instances of Foundry.
- INSTANCE\_NAME - Unique name for this foundry instance (e.g. 'prod' or 'dev').  This should also be unique across all running instances of foundry.
- FOUNDRY\_LICENSE\_KEY - License key to be used for this foundry instance.  Can either be the raw value of the key itself, or an index (starting from 1) of the key as listed in your account details on foundryvtt.com.  If unset, a random key will be chosen from your account.
- DEFAULT\_WORLD - Optional.  The world that should be launched by default for this instance whenever it is started.
