#!/bin/bash

# Install/upgrade to python3.11 
sudo yum install python3.11 -y

# Install/upgrade to pip
sudo yum install python3.11-pip -y

# set python3.11 as default version
# sudo update-alternatives --config python3

# install wheel dependency - RUN OPTIONALLY
pip3 install wheel setuptools 

# upgrade setuptools - RUN OPTIONALLY
sudo pip3 install --upgrade setuptools

# Install pyiceberg
pip install "pyiceberg[adlfs]"

# Check version
pip show pyiceberg
Pip3 show pyiceberg