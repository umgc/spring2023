#! /usr/bin/env python
from virotour import app, db

PORT = 8081
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        app.run(host='0.0.0.0', port=PORT, debug=True)
