import os
from os.path import join, dirname, realpath

from flasgger import Swagger

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from .utils import allowed_file

basedir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)
Swagger(app)
from logging.config import dictConfig

dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': 'ext://sys.stdout',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})
app.config['SECRET_KEY'] = 'secret key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'app.db')
app.config["UPLOAD_FOLDER"] = os.path.abspath(join(dirname(realpath(__file__)), '../uploads'))
app.config.from_object(__name__)

db = SQLAlchemy(app)
# db.init_app(app)
app.config.from_object(__name__)

from . import models
from .api import hello
from .api import tour
from .api import image_upload
from .api import text
from .api.compute import compute
from .api import after_request
