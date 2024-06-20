#!/bin/bash
# Update package information -18s
# sudo yum update -y --> taking morethan 3 minutes to update

# Install JDK 22
sudo yum install temurin-22-jdk

#set JAVA_HOME and check java version
export JAVA_HOME=/usr/lib/jvm/temurin-22
java --version

# Download Trino
sudo wget https://repo1.maven.org/maven2/io/trino/trino-server/448/trino-server-448.tar.gz 

# Extract the downloaded tarball
sudo tar -xzf trino-server-448.tar.gz

# Move the extracted folder and rename it to 'trino-server'
sudo mv trino-server-448 /usr/local/trino-server
cd /usr/local
sudo chmod -R +x trino-server/

# Create a directory for trino data to match the node.properties file
cd /var/
sudo mkdir -p trino/data

# Change permissions of the logs directory
sudo chmod 777 trino/data

# Download etc properties
cd /usr/local/trino-server
sudo wget https://helicaltech.com/wp-content/uploads/2023/07/etc.zip
sudo unzip etc.zip -d etc



