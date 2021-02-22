#!/bin/bash
set -e

# Import Secret ##########
mkdir /root/.ssh
chmod 700 /root/.ssh
cat /etc/secret-volume/id_rsa > /root/.ssh/id_rsa
cat /etc/secret-volume/authorized_keys > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/id_rsa
chmod 600 /root/.ssh/authorized_keys
chown -R root:root /root/.ssh
##########################

# Setup backgroud service #
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
sleep 2
x11vnc -display :11 -passwd "$VNCPASS" -xkb -forever &
sleep 2
###########################
exec "$@"
