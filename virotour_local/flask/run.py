#! /usr/bin/env python
from app import create_app, db

PORT = 8081
if __name__ == '__main__':
    app = create_app()
    with app.app_context():
        db.create_all()
        app.run(host='0.0.0.0', port=PORT, debug=True)
