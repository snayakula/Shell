#!/bin/bash

# Create the kraft.service file content
service_content=$(cat <<EOF
[Adoptium]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/rhel/$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF
)

# Write the content to a file named kraft.service
echo "$service_content" > /etc/yum.repos.d/adoptium.repo

echo "adoptium repo is ready to install temurin-22-jdk"