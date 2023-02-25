
from app.utils import parse_http_response


def test_hello_world(client):
    resp = client.get('/api/')
    data = parse_http_response(resp)
    assert resp.status_code == 200
    assert 'Hello World! This is the REST APIs starter template.' in data['message']
