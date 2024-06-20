#!/bin/bash

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