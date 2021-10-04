#!/bin/bash

## install debian utrains cours

IP=$(hostname -I | awk '{print $2}')


echo "[1]: Update the server ====> "$IP
apt-get update -qq >/dev/null
apt-get install -qq -y git sshpass wget ansible gnupg2 curl >/dev/null

echo "[3]: install docker & docker-composer"
curl -fsSL https://get.docker.com | sh; >/dev/null

curl -sL "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose 

echo "[4]: use registry without ssl"
echo "
{
 \"insecure-registries\" : [\"192.168.5.5:5000\"]
}
" >/etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker


