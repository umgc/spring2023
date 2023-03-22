import os

from virotour.tests.common_utils import upload_images, get_raw_images, get_image_paths, add_tour


def test_add_images_to_tour(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")

    image_paths = get_image_paths('input_images/location1')
    data = upload_images(client, tour_name, image_paths)

    assert data['tour_id'] == 1
    assert data['server_file_paths'] == {
        'S1.jpg': 'raw_images/T_1_L_1_S1.jpg',
        'S2.jpg': 'raw_images/T_1_L_1_S2.jpg',
        'S3.jpg': 'raw_images/T_1_L_1_S3.jpg',
        'S4.jpg': 'raw_images/T_1_L_1_S4.jpg',
        'S5.jpg': 'raw_images/T_1_L_1_S5.jpg'
    }

    data = get_raw_images(client, "Tour 1", 1)
    assert data['count'] == 5
    assert data['server_file_paths'] == [
        'raw_images/T_1_L_1_S1.jpg',
        'raw_images/T_1_L_1_S2.jpg',
        'raw_images/T_1_L_1_S3.jpg',
        'raw_images/T_1_L_1_S4.jpg',
        'raw_images/T_1_L_1_S5.jpg'
    ]

def test_add_images_multiple_locations(client):
    """Split input images to simulate different locations"""
    tour_name = "Tour 2"
    add_tour(client, tour_name, "Tour Description Example")

    all_image_paths = get_image_paths('input_images/location1')
    id = 1
    for image_path in all_image_paths:
        data = upload_images(client, tour_name, [image_path])
        assert data['server_file_paths'] == {
            f'S{id}.jpg': f'raw_images/T_1_L_{id}_S{id}.jpg'
        }
        id += 1

    data = get_raw_images(client, tour_name, 1)
    assert data['count'] == 1
    assert data['server_file_paths'] == [
        'raw_images/T_1_L_1_S1.jpg'
    ]

    data = get_raw_images(client, tour_name, 2)
    assert data['count'] == 1
    assert data['server_file_paths'] == [
        'raw_images/T_1_L_2_S2.jpg'
    ]

    data = get_raw_images(client, tour_name, 5)
    assert data['count'] == 1
    assert data['server_file_paths'] == [
        'raw_images/T_1_L_5_S5.jpg'
    ]

