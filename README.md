docker-mosquitto
================

Docker image for mosquitto

## Run

    docker run -ti -p 1883:1883 -p 9001:9001 kumarsumit1/mosquitto

Exposes Port 1883 (MQTT) 9001 (Websocket MQTT)

## Running with persistence


### Local directories / External Configuration

Alternatively you can use volumes to make the changes
persistent and change the configuration.

    mkdir -p /srv/mqtt/config/
    mkdir -p /srv/mqtt/data/
    mkdir -p /srv/mqtt/log/
    # place your mosquitto.conf in /srv/mqtt/config/
    # NOTE: You have to change the permissions of the directories
    # to allow the user to read/write to data and log and read from
    # config directory
    # For TESTING purposes you can use chmod -R 777 /srv/mqtt/*
    # Better use "-u" with a valid user id on your docker host

    # Copy the files from the config directory of this project
    # into /src/mqtt/config. Change them as needed for your
    # particular needs.

    docker run -ti -p 1883:1883 -p 9001:9001 \
    -v /srv/mqtt/config:/mqtt/config:ro \
    -v /srv/mqtt/log:/mqtt/log \
    -v /srv/mqtt/data/:/mqtt/data/ \
    --name mqtt toke/mosquitto

Volumes: /mqtt/config, /mqtt/data and /mqtt/log

### Docker Volumes for persistence

Using [Docker Volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/) for persistence.

Create a named volume:

    docker volume create --name mosquitto_data

Now it can be attached to docker by using `-v mosquitto_data:/mqtt/data` in the
Example above. Be aware that the permissions within the volumes
are most likely too restrictive.








