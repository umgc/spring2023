#! /usr/bin/env python
import os
from app import app, db

port = 5001
if __name__ == '__main__':
    # with app.app_context():
    #     # create table(s) according to the model
    #     # declare this after model base class
    #     db.create_all()
        app.run(host='0.0.0.0', port=port, debug=True)
