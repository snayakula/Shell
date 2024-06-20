#!/bin/bash
# Update package information -18s
sudo yum update -y

# Install OpenJDK 11 (you can replace 11 with a different version if needed) -60s
sudo dnf install java-17-openjdk -y

# Download Apache Kafka
sudo wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz

# Extract the downloaded tarball
sudo tar -xzf kafka_2.13-3.7.0.tgz

# Move the extracted folder and rename it to 'kafka'
sudo mv kafka_2.13-3.7.0/ /usr/local/kafka
cd /usr/local
sudo chmod -R +x kafka/

# Create a directory for Kafka logs
cd /
sudo mkdir -p /kafka-data

# Change permissions of the logs directory
sudo chmod 777 /kafka-data

# Define the kafka-data file path
properties_file="/usr/local/kafka/config/kraft/server.properties"
# Step 1: Find the line - log.dirs=/tmp/kraft-combined-logs
if grep -q "log.dirs=/tmp/kraft-combined-logs" "$properties_file"; then
    echo "Line found."
# Step 2: Edit the line (comment it out)
    sudo sed -i '/log.dirs=\/tmp\/kraft-combined-logs/ s/^/#/' "$properties_file"
    echo "Line commented out."
# Step 3: Add a new line
    echo "log.dirs=/kafka-data" | sudo tee -a "$properties_file" > /dev/null
    echo "New line added."
else
    echo "The line does not exist in the file."
fi

# Define the listeners=PLAINTEXT://:9092,CONTROLLER://:9093 file path
# Step 1: Find the line
if grep -q "listeners=PLAINTEXT://:9092,CONTROLLER://:9093" "$properties_file"; then
    echo "Line listeners=PLAINTEXT://:9092,CONTROLLER://:9093 found. Commenting it out and adding the new line."
# Step 2: Edit the line (comment it out)
    sudo sed -i '/listeners=PLAINTEXT:\/\/:9092,CONTROLLER:\/\/:9093/ s/^/#/' "$properties_file"
    echo "Line commented out"
# Step 3: Add a new line
    echo "listeners=PLAINTEXT://0.0.0.0:9092,CONTROLLER://:9093" | sudo tee -a "$properties_file" > /dev/null
    echo "New line added"
else
    echo "The line does not exist in the file."
fi

# Define the advertised.listeners=PLAINTEXT://localhost:9092 file path
# Step 1: Find the line
if grep -q "advertised.listeners=PLAINTEXT://localhost:9092" "$properties_file"; then
    echo "Line advertised.listeners=PLAINTEXT://localhost:9092 found. Commenting it out and adding the new line."
# Step 2: Edit the line (comment it out)
    sudo sed -i '/advertised.listeners=PLAINTEXT:\/\/localhost:9092/ s/^/#/' "$properties_file"
    echo "line commented"
# Step 3: Add a new line
    echo "advertised.listeners=PLAINTEXT://<private_ip>:9092" | sudo tee -a "$properties_file" > /dev/null
    echo "New line added"
else
    echo "The line does not exist in the file."
fi

# Generate a random UUID for the Kafka cluster ID
cd /usr/local/kafka
KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"
sudo bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/kraft/server.properties

# Create a timestamp with the current date and time
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
sudo touch cluster-ids.txt
sudo chmod 777 cluster-ids.txt
# Combine cluster ID and timestamp
CONTENT="Cluster ID: $KAFKA_CLUSTER_ID\nGenerated at: $TIMESTAMP"

# Write content to the "cluster-id.txt" file
echo -e "$CONTENT" > cluster-ids.txt
echo "Cluster ID and timestamp written to cluster-id.txt file."

# Install Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install Docker engine along with containerd and docker-compose
# sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# pull kafdrop image
sudo docker pull obsidiandynamics/kafdrop:latest

# run kafdrop on docker
# MAKE SURE TO CHANGE VM_IP ADDRESS HERE< USE AZURE CLI TO GET VM_IP ADDRESS
sudo docker run -d  -p 9000:9000 --restart unless-stopped --name kafdrop -e KAFKA_BROKERCONNECT=privateipaddress:9092 -e JVM_OPTS="-Xms32M -Xmx64M" -e SERVER_SERVLET_CONTEXTPATH="/" obsidiandynamics/kafdrop

# Create the kraft.service file content
service_content=$(cat <<EOF
[Unit]
Description=Apache Kafka Server
Documentation=http://kafka.apache.org/documentation.html

[Service]
Type=simple
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.11.0.9-2.el8.x86_64"
ExecStart=/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/kraft/server.properties
ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh

[Install]
WantedBy=multi-user.target
EOF
)

# Write the content to a file named kraft.service
echo "$service_content" > /etc/systemd/system/kraft.service

# Reload systemd to pick up the new service
sudo systemctl daemon-reload

echo "Kafka service configured as a systemd service."