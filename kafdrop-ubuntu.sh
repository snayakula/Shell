#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Start the Docker service
sudo service docker start

# pull kafdrop image
sudo docker pull obsidiandynamics/kafdrop:latest

# run kafdrop on docker
# get VM-ip address with az cli
sudo docker run -d  -p 9000:9000 --restart unless-stopped --name kafdrop -e KAFKA_BROKERCONNECT=privateipaddress:9092 -e JVM_OPTS="-Xms32M -Xmx64M" -e SERVER_SERVLET_CONTEXTPATH="/" obsidiandynamics/kafdrop