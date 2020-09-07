#!/bin/bash

cd /home/njuser/flask_note_jam
source venv/bin/activate
pip install -r requirements.txt
pip install gunicorn
deactivate
