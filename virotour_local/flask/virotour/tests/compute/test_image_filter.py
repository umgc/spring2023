import fnmatch
import os

from virotour import db
from virotour.api.compute.image_filter import detect_brightness, adjust_contrast_brightness, adjust_hue_saturation_value, \
    apply_gaussian_filter, apply_glow_effect
from virotour.api.image_upload import api_upload_resolve_path
from virotour.models import Filter, Location
from virotour.tests.common_utils import add_tour, get_image_path, upload_images, get_image_paths, compute_tour, \
    get_panoramic_image


def test_detect_brightness(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    data = detect_brightness(input_file)
    assert data == 'dark'


def test_adjust_contrast_brightness(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    output_directory = get_image_path('input_images\\location4\\result').replace("\\", "/")
    brightness_level = 100
    adjust_contrast_brightness(input_file, brightness_level, output_directory)
    # Count the number of files in the output directory
    count = len(fnmatch.filter(os.listdir(output_directory), '*.*'))
    assert count > 0


def test_adjust_hue_saturation_value(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    output_directory = get_image_path('input_images\\location4\\result').replace("\\", "/")
    brightness_level = 100
    adjust_hue_saturation_value(input_file, brightness_level, output_directory)
    # Count the number of files in the output directory
    count = len(fnmatch.filter(os.listdir(output_directory), '*.*'))
    assert count > 0


def test_apply_gaussian_filter(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    output_file = get_image_path('input_images\\location4\\result\\T_1_L_1_pano.png').replace("\\", "/")
    output_directory = get_image_path('input_images\\location4\\result').replace("\\", "/")
    radius = 1
    strength = 1
    # Detect dark image
    data = detect_brightness(input_file)
    assert data == 'dark'
    # Apply gaussian filter
    apply_gaussian_filter(input_file, radius, strength, output_directory)
    # Count the number of files in the output directory
    count = len(fnmatch.filter(os.listdir(output_directory), '*.*'))
    assert count > 0
    # Detect brighter image
    data = detect_brightness(output_file)
    assert data == 'light'


def test_apply_glow_effect(client):
    tour_name = "tour-1"
    brightness = 100
    location_id = 1
    add_tour(client, tour_name, "Tour Description Example")
    upload_images(client, tour_name, get_image_paths('input_images/location1'))
    compute_tour(client, tour_name)

    # Test get relative image path
    pano_image_path = get_panoramic_image(client, tour_name, 1)['server_file_path']
    assert pano_image_path == 'panoramic_images/T_1_L_1_pano_blurred.jpg'
    # Detect dark image
    before = detect_brightness(api_upload_resolve_path(pano_image_path))
    # Calls image_filter.adjust_contrast_brightness()
    apply_glow_effect(location_id, brightness)
    # Detect brighter image
    after = detect_brightness(api_upload_resolve_path(pano_image_path))
    assert before != after

    # Verify filter setting for glow effect was saved to the database
    location = db.session.query(Location).filter(Location.location_id == location_id).first()
    filter = db.session.query(Filter).filter(Filter.filter_id == location.filter_id).first()
    assert filter.filter_name == 'glow'
    assert filter.setting == brightness

