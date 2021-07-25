#!/bin/bash

sudo apt update
sudo apt upgrade

# Install docker, docker-compose
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo -ne '\n' | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
sudo apt update
sudo apt install -y docker-ce docker-compose
usermod -aG docker $USER

# install grafana
sudo apt install -y apt-transport-https
sudo apt install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
echo "deb https://packages.grafana.com/enterprise/deb beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt update
sudo apt install -y grafana-enterprise

sudo systemctl daemon-reload
sudo systemctl start grafana-server

sudo systemctl enable grafana-server.service


firewall-cmd --permanent --zone=public --add-rich-rule='rule priority="-31000" family="ipv4" source address="0.0.0.0/0" port port="3000" protocol="tcp" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule priority="-31000" family="ipv4" source address="0.0.0.0/0" port port="9090" protocol="tcp" accept'

firewall-cmd --reload
firewall-cmd --complete-reload

docker-compose up -d --build