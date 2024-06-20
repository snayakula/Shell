#!/bin/bash

# if dev-tools not in place
sudo yum groupinstall 'Development Tools' -y

# Install/upgrade to python3.11 
sudo yum install python3.11 -y

# Install/upgrade to pip
sudo yum install python3.11-pip -y

# set python3.11 as default version
# sudo update-alternatives --config python3

# install wheel dependency - RUN OPTIONALLY
pip3 install wheel setuptools 

# Install Airflow with constraints:
AIRFLOW_VERSION=2.9.2
PYTHON_VERSION="$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow[postgres]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# set AIRFLOW_HOME
export AIRFLOW_HOME=~/airflow

# Check Version
airflow version

# Optional commands
# # initialize DB
# airflow db init

# # create User and assign role
# airflow users  create --role Admin --username admin --email admin --firstname admin --lastname admin --password admin

# # Run airflow webserver
# airflow webserver -p 8080

# airflow scheduler

# -----------------------------------


