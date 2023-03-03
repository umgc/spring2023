from datetime import datetime

import requests
from app.tests.common_utils import get_image_paths

# api-endpoint
URL = "http://127.0.0.1:8081/api"


def file_upload_request_builder(image_paths):
    files = { file : open(file, 'rb') for file in image_paths}
    return files


def test_integration():
    # Create Tour
    now = datetime.now()
    current_time = now.strftime("%m_%d_%H_%M_%S")
    tour_name = f'Virtual Tour {current_time}'
    json = {'name': tour_name, 'description': 'test'}
    r1 = requests.post(url=f"{URL}/tour/add", json=json)
    r2 = requests.get(url=f"{URL}/tours")

    assert r1.json()["message"] == f"Tour {tour_name} has been created successfully."
    assert r2.json()["count"] > 0

    # Add images
    location1 = get_image_paths('input_images/location1')
    location2 = get_image_paths('input_images/location2')

    r3 = requests.post(url=f"{URL}/tour/add/images/{tour_name}", files=file_upload_request_builder(location1))
    r4 = requests.post(url=f"{URL}/tour/add/images/{tour_name}", files=file_upload_request_builder(location2))

    # Compute tour
    r5 = requests.get(url=f"{URL}/compute-tour/{tour_name}")

    # Perform Searc
    search_input = 'level'
    r6 = requests.get(url=f"{URL}/tour/search/{search_input}")

    # List locations
    r7 = requests.get(url=f"{URL}/tour/locations/{tour_name}")

    assert r1.status_code == 201
    assert r2.status_code == 200
    assert r3.status_code == 200
    assert r4.status_code == 200
    assert r5.status_code == 200
    assert r6.status_code == 200
    assert r6.json()['results'][0]["text_content"] == "~LOWER LEVEL"
    assert r7.status_code == 200
    assert len(r7.json()['results']) == 2
