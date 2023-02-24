import json


def test_hello_world(app):
    client = app.test_client()
    resp = client.get('/api/')
    data = json.loads(resp.data.decode())
    assert resp.status_code == 200
    assert 'Hello World! This is the REST APIs starter template.' in data['message']

def test_no_tours(app):
    client = app.test_client()
    resp = client.get('/api/tours')
    data = json.loads(resp.data.decode())
    assert resp.status_code == 200
    assert data['count'] == 0
    assert data['tours'] == []

def test_add_tour(app):
    client = app.test_client()

    resp = client.post('/api/tour/', data={
        'id': 1,
        'name': "Tour 1",
        'description': "Tour Description Example"
    })

    data = json.loads(resp.data.decode())
    assert resp.status_code == 200
    assert data['count'] == 1
    assert data['tours']['id'] == 1
    assert data['tours']['name'] == "Tour 1"
    assert data['tours']['description'] == "Tour Description Example"
