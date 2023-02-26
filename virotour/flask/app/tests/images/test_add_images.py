import os

from app.tests.images.image_utils import upload_images_with_resp, upload_images
from app.tests.tour.tour_utils import add_tour


def test_add_images_to_tour(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")

    image_dir = os.path.join(os.path.dirname(__file__), 'input_images/location1')
    image_list = os.listdir(image_dir)
    image_paths = [f"{image_dir}/{file}" for file in image_list]
    data = upload_images(client, tour_name, image_paths)

    assert data['tour_id'] == 1
    assert data['server_file_paths'] == {
        'S1.jpg': 'uploads/1/S1.jpg',
        'S2.jpg': 'uploads/1/S2.jpg',
        'S3.jpg': 'uploads/1/S3.jpg',
        'S4.jpg': 'uploads/1/S4.jpg',
        'S5.jpg': 'uploads/1/S5.jpg'
    }
