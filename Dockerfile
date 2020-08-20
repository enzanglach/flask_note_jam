FROM python:3.8.4-buster

LABEL maintainer="sebastian.szuber@outlook.com"

RUN apt-get update -y

RUN apt-get install -y curl gnupg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
RUN apt-get update -y && \
    export ACCEPT_EULA=Y && \
    apt-get install msodbcsql17 mssql-tools unixodbc-dev -y
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN export PATH="$PATH:/opt/mssql-tools/bin"

COPY odbc.ini /etc/odbc.ini

COPY . /flaskapp
WORKDIR /flaskapp
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Run the command on container startup
CMD export FLASK_APP=notejam && \
    export FLASK_ENV=development && \
    flask run --host 0.0.0.0 --port=80

EXPOSE 80
