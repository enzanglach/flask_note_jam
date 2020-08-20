FROM python:3.8.4-buster

LABEL maintainer="sebastian.szuber@outlook.com"

RUN apt-get update -y \
    && apt-get install -y \
    gunicorn

COPY . /flaskapp
WORKDIR /flaskapp
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Run the command on container startup
CMD export FLASK_APP=notejam && \
    export FLASK_ENV=development && \
    flask run --host 0.0.0.0 --port=80

EXPOSE 80
