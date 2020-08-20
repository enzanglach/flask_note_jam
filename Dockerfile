FROM python:3.8.4-buster

LABEL maintainer="sebastian.m.szuber@gsk.com"

WORKDIR /alnmccp

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD update_assignments.py veeva_vault_api.py /alnmccp/

# Run the command on container startup
CMD python ./update_assignments.py scheduler
