#!/bin/bash

# Create the kraft.service file content
service_content=$(cat <<EOF
[Unit]
Description=Trino Service
After=network.target

[Service]
ExecStart=/usr/local/trino-server/bin/launcher start
ExecStop=/usr/local/trino-server/bin/launcher stop
Type=forking

[Install]
WantedBy=default.target
EOF
)

# Write the content to a file named kraft.service
echo "$service_content" > /etc/systemd/system/trino.service

# Reload systemd to pick up the new service
sudo  systemctl deamon-reload

echo "Trino service configured as a systemd service."
