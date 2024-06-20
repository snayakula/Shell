#!/bin/bash
# Download postgresql rpm package
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable any old config
sudo dnf -qy module disable postgresql

#install postgresql16
sudo dnf install -y postgresql16-server

#Optional commands to setup DB and manage
# sudo /usr/pgsql-16/bin/postgresql-16-setup initdb

# sudo systemctl enable postgresql-16
# sudo systemctl start postgresql-16
# sudo systemctl status postgresql-16
# sudo systemctl stop postgresql-16