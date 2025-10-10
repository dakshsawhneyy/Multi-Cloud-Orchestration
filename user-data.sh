#!/bin/bash

set -ex

# Update all packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker and AWS CLI
sudo apt-get install docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu

# Run NginX
docker run --name nginx \
    -p 80:80 \
    -d nginx:latest