#!/bin/sh

sudo yum update -y
sudo yum install -y docker

# Start Docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# Download Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo yum install -y git
cd /opt
git clone https://github.com/ryanrishi/covid-19-grafana.git
cd covid-19-grafana

GF_SERVER_DOMAIN=stage.ryanrishi.com \
GF_SERVER_SERVE_FROM_SUB_PATH=true \
GF_SERVER_ROOT_URL=https://stage.ryanrishi.com/covid-19-dashboard/ \
docker-compose up -d
