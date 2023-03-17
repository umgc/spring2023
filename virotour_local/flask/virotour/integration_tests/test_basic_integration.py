import json
import os
from datetime import datetime

import requests
from virotour.tests.common_utils import get_image_paths, get_image_path

# api-endpoint
URL = "https://virotour2023-flask-server.azurewebsites.net/api"


def file_upload_request_builder(image_paths):
    files = {file: open(file, 'rb') for file in image_paths}
    return files


def test_integration():
    # Create Tour
    now = datetime.now()
    current_time = now.strftime("%m_%d_%H_%M_%S")
    tour_name = f'Virtual Tour {current_time}'
    r2 = requests.get(url=f"{URL}/tours", verify=False)
    r1 = requests.post(url=f"{URL}/tour/add", json= {'name': tour_name, 'description': 'test'})

    assert r1.json()["message"] == f"Tour {tour_name} has been created successfully."
    assert r2.json()["count"] > 0

    # Add images
    for location_path in os.listdir(get_image_path('input_images/sample_tour/')):
        files_to_upload = get_image_paths(f'input_images/sample_tour/${location_path}')
        requests.post(url=f"{URL}/tour/add/images/{tour_name}", files=file_upload_request_builder(files_to_upload))

    # Compute tour
    r5 = requests.get(url=f"{URL}/compute-tour/{tour_name}")
    assert r5.status_code == 200

    # Get Tour
    r8 = requests.get(url=f"{URL}/tour/get-tour/{tour_name}")
    print(json.dumps(r8.json(), indent=2))
    assert r8.status_code == 200

    # Perform Search
    search_input = 'SONY'
    r6 = requests.get(url=f"{URL}/tour/search/{tour_name}/{search_input}")
    assert r6.status_code == 200
    assert r6.json()['results'][0]["text_content"] == "SONY"
