from app.api.compute.neighbors import compute_neighbors
from app.tests.common_utils import add_tour
from app.tests.common_utils import upload_images
from app.tests.images.test_add_images import get_image_paths


def test_compute_neighbors(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")
    image_paths = get_image_paths('input_images/location1')
    upload_images(client, tour_name, image_paths)

    # TODO: Need a better test case

    data = compute_neighbors(tour_name, 1)

    assert True == False
