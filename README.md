docker-mosquitto
================

Docker image for mosquitto

## Run

    docker run -ti -p 1883:1883 -p 9001:9001 kumarsumit1/mosquitto

Exposes Port 1883 (MQTT) 9001 (Websocket MQTT)


docker run --name mqtt --restart=always --net=host -tid -v /volume1/docker/mqtt/config:/mqtt/config:ro -v /volume1/docker/mqtt/log:/mqtt/log -v /volume1/docker/mqtt/data/:/mqtt/data/ kumarsumit1/mosquitto


docker run tells Docker to run a container with the parameters we’re parsing.

--name mqtt The name flag will allow us to easily identify which container is running MQTT. This is useful if we need to do some commands against the container (like starting, stopping etc) later.

--restart=always This is a powerful and handy flag to set. This will tell Docker to keep trying to re-start the MQTT Broker if it crashes, or on boot of the system. (This is one of the flags you can’t set when using the Synology Docker DSM Interface).

--net=host Another important and powerful flag. This gives your MQTT Broker full network access. This allows you to use 127.0.0.1 as the IP address of your MQTT Broker in Home Assistant, if you followed my setup guide. (This is one of the flags you can’t set when using the Synology Docker DSM Interface).

-itd This is actually three commands in the one. The important one is d. This tells Docker to run in detached mode. Once Docker runs the container, our SSH session is returned to us. If we don’t specify this, we’ll see the output from the MQTT Broker in our SSH console.

-v /volume1/docker/mqtt/config:/mqtt/config:ro Here we’re creating some mount volumes with the various -v flags. This will allow configuration to persist across reboots, as well as data. So, if your MQTT Broker goes down, any persistent messages you may have sent over the Broker should come back up. You can place it in any folder you like. Whatever you choose to use, the folder must exist before you will be able to start the MQTT Broker. If you want to use the same folder as I did above, you can create it by running mkdir -p /volume1/docker/mqtt/config



https://notes.lebster.me/posts/fast-way-to-run-a-secured-mosquitto-mqtt-broker-in-the-docker/

https://stackoverflow.com/questions/56295313/cant-subscribe-to-docker-eclipse-mosquitto-broker


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








