#!/bin/bash

USER=${PAM_USER}
GROUP=$(echo $REQUEST | awk '{print $2;}' | tr -d '/')

# check if user is in group
echo "PAM: Checking if user ${USER} is in group ${GROUP}..." > /dev/console
id -Gn ${USER} | tr " " "\n" | grep -xq ${GROUP}
exit $?