#!/bin/bash
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
# Step 3: Add a new line - ADD VM_IP ADDRESS HERE
    echo "advertised.listeners=PLAINTEXT://privateipaddress:9092" | sudo tee -a "$properties_file" > /dev/null
    echo "New line added"
else
    echo "The line does not exist in the file."
fi