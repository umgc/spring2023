import os

from virotour.api.compute.compute import compute_panoramic
from virotour.tests.common_utils import add_tour, upload_images, get_image_path
from virotour.tests.images.test_add_images import get_image_paths


def test_compute_panoramic(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")
    image_paths = get_image_paths('input_images/location1')
    upload_images(client, tour_name, image_paths)

    data = compute_panoramic(tour_name, 1)

def test_compute_panoramic_full(client):
    tour_name = "sample-tour"
    add_tour(client, tour_name, "")
    id = 1
    for location_path in os.listdir(get_image_path('input_images/sample_tour/')):
        upload_images(client, tour_name, get_image_paths(f'input_images/sample_tour/{location_path}'))
        compute_panoramic(tour_name, id)
        id += 1
