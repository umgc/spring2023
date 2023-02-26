# importing the requests library
import requests

# api-endpoint
URL = "http://127.0.0.1:5000/api"


def test_integration_add_tour():
    json = {'name': 'vt1', 'description': 'test'}
    r1 = requests.post(url=f"{URL}/add/tour", json=json)
    r2 = requests.get(url=f"{URL}/tours")

    assert r1.json()["message"] == "Tour vt1 has been created successfully."
    assert r2.json()["count"] > 0
