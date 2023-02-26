import os

from app.tests.images.image_utils import upload_images
from app.tests.tour.tour_utils import add_tour


def test_add_images_to_tour(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")

    image_dir = 'input_images/location1'
    image_list = os.listdir(image_dir)
    image_paths = [f"{image_dir}/{file}" for file in image_list]
    upload_images(client, tour_name, image_paths)
