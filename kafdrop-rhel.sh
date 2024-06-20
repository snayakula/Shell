#!/bin/bash
#Set up Docker repo
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install Docker engine along with containerd and docker-compose
# sudo yum install docker-ce docker-ce-cli containerd.io
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add $USER to docker group
# sudo usermod -aG docker your_username

# pull kafdrop image
sudo docker pull obsidiandynamics/kafdrop:latest

# run kafdrop on docker
# MAKE SURE TO CHANGE VM_IP ADDRESS HERE< USE AZURE CLI TO GET VM_IP ADDRESS
sudo docker run -d  -p 9000:9000 --restart unless-stopped --name kafdrop -e KAFKA_BROKERCONNECT=privateipaddress:9092 -e JVM_OPTS="-Xms32M -Xmx64M" -e SERVER_SERVLET_CONTEXTPATH="/" obsidiandynamics/kafdrop

