#!/bin/bash

# Installing docker, you can change the version below
curl -sL https://releases.rancher.com/install-docker/${docker_version}.sh | sh

# Installing docker compose
mkdir -p /root/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-x86_64 -o /root/.docker/cli-plugins/docker-compose
chmod +x /root/.docker/cli-plugins/docker-compose

# Configuring the firewall

sudo ufw allow http
sudo ufw allow https
sudo ufw allow ssh
sudo ufw reload

sudo systemctl start ufw
sudo systemctl enable ufw
sudo ufw enable

# Installing Snapd

sudo apt update
sudo apt install snapd

sudo snap install core
sudo snap refresh core

# Installing Certbot
sudo apt remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Request Certificate. The certificate and key are saved at  /etc/letsencrypt/live/${dns_record}
sudo certbot certonly --non-interactive --standalone -d ${dns_record} --agree-tos -m ${email}

# Install Harbor
mkdir -p /opt/harbor
cd /opt/harbor

curl -s https://api.github.com/repos/goharbor/harbor/releases/latest \
| grep "browser_download_url.*harbor-offline-installer.*.tgz\"" \
| tail -n 1 \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -O harbor-offline-installer.tgz -qi -

tar xzvf harbor-offline-installer.tgz

cd harbor
cp harbor.yml.tmpl harbor.yml

sed -i 's/reg.mydomain.com/${dns_record}/g' harbor.yml
sed -i 's/\/your\/certificate\/path/\/etc\/letsencrypt\/live\/${dns_record}\/fullchain.pem/g' harbor.yml
sed -i 's/\/your\/private\/key\/path/\/etc\/letsencrypt\/live\/${dns_record}\/privkey.pem/g' harbor.yml
sed -i 's/Harbor12345/${harbor_password}/g' harbor.yml
sed -i 's/root123/${harbor_password}/g' harbor.yml

sudo ./install.sh


