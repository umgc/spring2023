#! /usr/bin/env python
import os
from app import app

port = 5000
if __name__ == '__main__':
    if port != 0:
        app.run(host='0.0.0.0', port=port, debug=True)
    else:
        app.run()
