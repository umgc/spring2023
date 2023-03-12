import os

from PIL import Image
from app import app
from app.tests.common_utils import add_tour, get_image_paths, upload_images, compute_tour, get_panoramic_image, \
    get_raw_images, get_search_results, get_tour_locations


def test_compute_tour(client):
    tour_name = "tour-1"
    add_tour(client, tour_name, "Tour Description Example")
    upload_images(client, tour_name, get_image_paths('input_images/location1'))
    upload_images(client, tour_name, get_image_paths('input_images/location2'))
    compute_tour(client, tour_name)

    # Test get relative image path
    pano_image_path = get_panoramic_image(client, tour_name, 1)['server_file_path']
    assert pano_image_path == 'panoramic_images/T_1_L_1_pano_blurred.jpg'

    # Test image exists and is openable
    pano_image_path = os.path.join(app.config['UPLOAD_FOLDER'], pano_image_path)
    Image.open(pano_image_path)
    # img.show()

    # Test that we can still retrieve the original images if needed
    data = get_raw_images(client, "tour-1", 1)
    assert data['count'] == 5
    assert data['server_file_paths'][0] == 'raw_images/T_1_L_1_S1.jpg'

    # Test that we can search (case-insensitive)
    data = get_search_results(client, tour_name, 'welcome')
    assert len(data['results']) == 1
    assert data['results'][0]['location_id'] == 2
    assert data['results'][0]['text_content'] == 'WELCOME'
    assert data['results'][0]['position_x'] == 7959
    assert data['results'][0]['position_y'] == 1907
    assert data['results'][0]['position_z'] == 0

    # Test that we can search (partial match)
    data = get_search_results(client, tour_name, 'level')
    assert len(data['results']) == 2
    assert data['results'][0]['location_id'] == 2
    assert data['results'][1]['location_id'] == 2
    assert data['results'][0]['text_content'] == 'LOWER LEVEL'
    assert data['results'][1]['text_content'] == 'UPPER LEVEL'

    data = get_search_results(client, tour_name, 'Should find nothing!')
    assert len(data['results']) == 0

    data = get_tour_locations(client, tour_name)
    assert data['results'] == [1, 2]
