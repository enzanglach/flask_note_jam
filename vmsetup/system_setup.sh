#!/bin/bash

apt-get update -y
apt-get install -y curl gnupg
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
apt-get update -y && \
    export ACCEPT_EULA=Y && \
    apt-get install msodbcsql17 mssql-tools unixodbc-dev -y
