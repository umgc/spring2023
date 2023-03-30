from flask import request, jsonify

from virotour import app


@app.route('/api/', methods=['GET'])
def api_hello():
    """
        Test connection (Hello World)
        ---
        responses:
          200:
            description: Success!
            schema:
                 description: Response
                 properties:
                   method:
                     type: string
                   message:
                     type: string
        """
    payload = {
        'method': request.method,
        'message': 'Hello World! This is the REST APIs starter template. (v3)'
    }
    return jsonify(payload), 200