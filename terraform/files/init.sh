#!/bin/sh

sudo yum update -y
sudo yum install -y docker

# Start Docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# Download Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
