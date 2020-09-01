#!/bin/bash

cd /home/njuser
git clone -b vmimage --single-branch https://github.com/enzanglach/flask_note_jam.git
cd /home/njuser/flask_note_jam
pip3 install virtualenv
~/.local/bin/virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
