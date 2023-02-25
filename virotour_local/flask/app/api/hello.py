from flask import request, jsonify

from app import app


@app.route('/api/', methods=['GET'])
def api_hello():
    payload = {
        'method': request.method,
        'message': 'Hello World! This is the REST APIs starter template.'
    }
    return jsonify(payload), 200