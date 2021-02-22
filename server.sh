#!/bin/bash

docker build -t rdbox/vgl-client:v0.0.1 .
docker run -it --rm \
  -e VGL_APP=glxgears \
  -e VGL_SERVER_IP=192.168.16.154 \
  -e VGL_SERVER_PORT=54322 \
  -e VGL_DISPLAY=:10.0 \
  -e VGL_LOGO=1 \
  -e VNCPASS=passwd \
  -v /tmp/.xvfb.rdbox.X11-unix:/tmp/.X11-unix \
  -v /home/ubuntu/.ssh:/etc/secret-volume \
  --net=host \
  --name vgl-client rdbox/vgl-client:v0.0.1
