import fnmatch
import os
from app.api.compute.image_filter import detect_brightness, adjust_brightness, adjust_hsv, apply_glow
from app.tests.common_utils import add_tour, get_image_path, upload_images

def test_detect_brightness(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    data = detect_brightness(input_file)
    assert data == 'dark'
def test_adjust_brightness(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    output_directory = get_image_path('input_images\\location4\\result').replace("\\", "/")
    brightness_level = 100
    adjust_brightness(input_file, brightness_level, output_directory)
    # Count the number of files in the output directory
    count = len(fnmatch.filter(os.listdir(output_directory), '*.*'))
    assert count > 0

def test_adjust_hsv(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    output_directory = get_image_path('input_images\\location4\\result').replace("\\", "/")
    brightness_level = 100
    adjust_hsv(input_file, brightness_level, output_directory)
    # Count the number of files in the output directory
    count = len(fnmatch.filter(os.listdir(output_directory), '*.*'))
    assert count > 0

def test_apply_glow(client):
    input_file = get_image_path('input_images\\location4\original\\T_1_L_1_pano.png').replace("\\", "/")
    output_directory = get_image_path('input_images\\location4\\result').replace("\\", "/")
    radius = 1
    strength = 1
    apply_glow(input_file, radius, strength, output_directory)
    # Count the number of files in the output directory
    count = len(fnmatch.filter(os.listdir(output_directory), '*.*'))
    assert count > 0
