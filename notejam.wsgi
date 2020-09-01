#!/usr/bin/python3
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/home/njuser/flask_note_jam")

from notejam import app as application
application.secret_key = 'Add your secret key'
