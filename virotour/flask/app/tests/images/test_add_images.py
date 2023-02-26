import os

from app.tests.images.image_utils import upload_images_with_resp, upload_images
from app.tests.tour.tour_utils import add_tour


def get_image_paths(path):
    image_dir = os.path.join(os.path.dirname(__file__), path)
    image_list = os.listdir(image_dir)
    return [f"{image_dir}/{file}" for file in image_list]
    pass


def test_add_images_to_tour(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")

    image_paths = get_image_paths('input_images/location1')
    data = upload_images(client, tour_name, image_paths)

    assert data['tour_id'] == 1
    assert data['server_file_paths'] == {
        'S1.jpg': 'uploads/tour_id=1/location_id=1/S1.jpg',
        'S2.jpg': 'uploads/tour_id=1/location_id=1/S2.jpg',
        'S3.jpg': 'uploads/tour_id=1/location_id=1/S3.jpg',
        'S4.jpg': 'uploads/tour_id=1/location_id=1/S4.jpg',
        'S5.jpg': 'uploads/tour_id=1/location_id=1/S5.jpg'
    }

    # TODO: Add validations to retrieve image paths!


def test_add_images_multiple_locations(client):
    """Split input images to simulate different locations"""
    tour_name = "Tour 2"
    add_tour(client, tour_name, "Tour Description Example")

    all_image_paths = get_image_paths('input_images/location1')
    id = 1
    for image_path in all_image_paths:
        data = upload_images(client, tour_name, [image_path])
        assert data['server_file_paths'] == {
            f'S{id}.jpg': f'uploads/tour_id=1/location_id={id}/S{id}.jpg'
        }
        id += 1