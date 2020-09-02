#!/bin/bash

apt-get update -y
apt-get upgrade -y
apt-get install -y curl gnupg git python3-dev python3-pip build-essential libssl-dev libffi-dev python3-setuptools python3-venv nginx
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
apt-get update -y && \
    export ACCEPT_EULA=Y && \
    apt-get install msodbcsql17 mssql-tools unixodbc-dev -y
cat > /etc/odbc.ini <<EOF
# [DSN name]
[sqlserver01pyapp]
Driver = ODBC Driver 17 for SQL Server
# Server = [protocol:]server[,port]
Server = tcp:sqlserver01pyapp.database.windows.net,1433
Database = notejamdb01
#
# Note:
# Port is not a valid keyword in the odbc.ini file
# for the Microsoft ODBC driver on Linux or macOS
#
EOF
adduser njuser --home /home/njuser --shell /bin/bash --disabled-password
echo 'njuser       ALL=(ALL:ALL) ALL' >> /etc/sudoers
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/njuser/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/njuser/.bashrc
cd /home/azureuser
chown njuser:njuser /home/njuser/.bash_profile
