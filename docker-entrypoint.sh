#!/bin/sh

#exit script if any command fails (non-zero value)
set -e

exec "$@"
# typically used to make the entrypoint a pass through that then runs the docker command. 
#It will replace the current running shell with the command that "$@" is pointing to. 
#By default, that variable points to the command line arguments.


#If you have an image with an entrypoint pointing to entrypoint.sh, 
#and you run your container as docker run my_image server start, 
#that will translate to running entrypoint.sh server start in the container.
# At the exec line entrypoint.sh, the shell running as pid 1 will replace itself with the command server start.

#This is critical for signal handling. Without using exec, 
#the server start in the above example would run as another pid, and after it exits, 
#you would return to your shell script. With a shell in pid 1, a SIGTERM will be ignored by default.
# That means the graceful stop signal that docker stop sends to your container, 
#would never be received by the server process. After 10 seconds (by default), 
#docker stop would give up on the graceful shutdown and send a SIGKILL that
# will force your app to exit, but with potential data loss or closed network
# connections, that app developers could have coded around if they received the signal.
# It also means your container will always take the 10 seconds to stop.

#https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts