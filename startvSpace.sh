#!/bin/sh
# Ubuntu 20.04LTS headless noVNC
# Connect to http://localhost:6080/
REPO=registry.united-imaging.com/mirecon/
IMAGE=umic-vspace-ubuntu-xfce
TAG=0.0.2
URL=http://localhost:6080

if [ -z "$SUDO_UID" ]
then
  # not in sudo
  USER_ID=`id -u`
  USER_NAME=`id -n -u`
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
fi

docker run --rm --detach \
  --publish 6080:80 \
  --volume "${PWD}":/workspace:rw \
  --env USERNAME=${USER_NAME} --env USERID=${USER_ID} \
  --env RESOLUTION=1400x900 \
  --name ${IMAGE} \
  ${REPO}${IMAGE}:${TAG}

sleep 5
