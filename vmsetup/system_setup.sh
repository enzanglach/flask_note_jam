#!/bin/bash

apt-get update -y
apt-get install -y curl gnupg git apache2 libapache2-mod-wsgi python3-dev python3-pip
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
GITHUB_PAT=`cat github_personal_access_token`
echo "export GITHUB_PAT=$GITHUB_PAT" >> /home/njuser/.bash_profile
echo "export GITHUB_PAT=$GITHUB_PAT" >> /home/njuser/.bashrc
SQLALCHEMY_DATABASE_URI=`cat sqlalchemy_database_uri`
echo "export SQLALCHEMY_DATABASE_URI=$SQLALCHEMY_DATABASE_URI" >> /home/njuser/.bash_profile
echo "export SQLALCHEMY_DATABASE_URI=$SQLALCHEMY_DATABASE_URI" >> /home/njuser/.bashrc
echo 'export FLASK_APP=notejam' >> /home/njuser/.bash_profile
echo 'export FLASK_APP=notejam' >> /home/njuser/.bashrc
echo 'export FLASK_ENV=production' >> /home/njuser/.bash_profile
echo 'export FLASK_ENV=production' >> /home/njuser/.bashrc
chown njuser:njuser /home/njuser/.bash_profile
a2enmod wsgi
