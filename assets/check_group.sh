#!/bin/bash

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

USER=${PAM_USER}
GROUP=$(echo $REQUEST | awk '{print $2;}' | tr -d '/')
GROUP=$(urldecode "${GROUP}")

# check if user is in group
echo "PAM: Checking if user ${USER} is in group ${GROUP}..." > /dev/stdout
id -Gn ${USER} | tr " " "\n" | grep -xq "${GROUP}"
exit $?
