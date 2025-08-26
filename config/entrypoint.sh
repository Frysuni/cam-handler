#!/usr/bin/env bash

set -e

chown -R cam:cam /home/cam
chmod 700 /home/cam /home/cam/.ssh
chmod 600 /home/cam/.ssh/*
chmod 644 /home/cam/.ssh/*.pub

mkdir -p /data
chown cam:cam /data
chmod 755 /data

exec /usr/sbin/sshd -D -e -f /etc/ssh/sshd_config
