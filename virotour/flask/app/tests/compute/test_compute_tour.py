from app.tests.compute.compute_utils import compute_tour
from app.tests.images.image_utils import upload_images
from app.tests.images.test_add_images import get_image_paths
from app.tests.tour.tour_utils import add_tour


def test_compute_tour(client):
    tour_name = "tour-1"
    add_tour(client, tour_name, "Tour Description Example")
    image_paths = get_image_paths('input_images/location1')
    upload_images(client, tour_name, image_paths)

    compute_tour(client, tour_name)

    assert True == False