#!/usr/bin/env bash

set -e

apt-get install -y dropbear
systemctl disable --now dropbear

mkdir -p ssh data/logs

ssh-keygen -t ecdsa -f ssh/host_ecdsa -N ""
ssh-keygen -t ecdsa -f ssh/id_ecdsa -m PEM -N "" -C "cam"

dropbearconvert openssh dropbear ssh/id_ecdsa ssh/id_ecdsa.pem
rm ssh/id_ecdsa

touch ssh/authorized_keys
cat ssh/id_ecdsa.pub >> ssh/authorized_keys
rm ssh/id_ecdsa.pub
cp ssh/authorized_keys data/authorized_keys

echo "OK. Start: docker compose up -d --build"
echo "Usage: dbclient -y -y -i /dav/id_ecdsa.pem -p 52222 cam@server 'cat /data/abc' > /tmp/file"

