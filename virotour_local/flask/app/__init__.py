import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from .utils import allowed_file

basedir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)
db = SQLAlchemy()
from . import models

app.config['SECRET_KEY'] = 'secret key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'app.db')
app.config["UPLOAD_FOLDER"] = 'uploads/'
app.config.from_object(__name__)

db.init_app(app)

def create_app():
    from .api import hello
    from .api import tour
    from .api import image_upload
    from .api import after_request

    return app
