#!/bin/bash

## ? Install debian-utrains-jenkins1

### ----------- Get IP Server Address --------------
IP=$(hostname -I | awk '{print $2}')
echo "START - install jenkins - "$IP

### ----------- Installation : git, sshpass, wget, ansible, gnupg2 and curl --------------
echo "[1]: install utils & ansible"
apt-get update -qq >/dev/null
apt-get install -qq -y git sshpass wget ansible gnupg2 curl >/dev/null

### ----------- Installation : Java 11 and Jenkins --------------
echo "[2]: install java & jenkins"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update -qq >/dev/null
apt-get install -qq -y default-jre jenkins >/dev/null

### ----------- Enable and Start Jenkins --------------
systemctl enable jenkins
systemctl start jenkins

### ----------- Installation and customization for Ansible --------------
echo "[3]: ansible custom"
sed -i 's/.*pipelining.*/pipelining = True/' /etc/ansible/ansible.cfg
sed -i 's/.*allow_world_readable_tmpfiles.*/allow_world_readable_tmpfiles = True/' /etc/ansible/ansible.cfg

### ----------- Installation docker and docker-compose --------------
echo "[4]: install docker & docker-composer"
curl -fsSL https://get.docker.com | sh; >/dev/null
usermod -aG docker jenkins # authorize docker for jenkins user
curl -sL "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "[5]: use registry without ssl"
echo "
{
 \"insecure-registries\" : [\"192.168.5.5:5000\"]
}
" >/etc/docker/daemon.json

### ----------- Enable and Start Docker --------------
systemctl daemon-reload
systemctl restart docker

echo "END - install jenkins"

