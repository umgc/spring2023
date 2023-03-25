import numpy as np
import cv2
import os
import argparse
import sys

from virotour.models import Location, Filter
from virotour.api.tour import api_upload_resolve_path
from virotour import app, db
from flask import jsonify

# Instantiate the parser
parser = argparse.ArgumentParser(description='Increase the brightness of an image')
# Construct the arguments
parser.add_argument("-i", "--image", type=str, required=True, help="path to input image")
parser.add_argument("-o", "--output", type=str, required=True, help="output path")
parser.add_argument("-m", "--mode", type=str, required=True, choices=['b', 'h', 'g'], help="mode")
parser.add_argument("-v", "--value", type=int, help="brightness value")
parser.add_argument("-r", "--radius", type=int, help="glow radius")
parser.add_argument("-s", "--strength", type=int, help="glow strength")

'''
There are three different methods to apply a filter to illuminate a single image:

adjust_contrast_brightness(): 
Calculates the brightness of an image. If the image mean brightness of the image is calculated to be less than 50%,
it uses the alpha/beta pixel values to adjust brightness of the image. This maybe useful to invoke during the image upload process.
command =>  filter.py --image 'path to input image/filename' --output 'path to write new image' --mode 'b' --value [integer]

adjust_hue_saturation_value(): 
Calculates the brightness of an image. If the image mean brightness of the image is calculated to be less than 50%,
it uses the hue and saturation values to adjust the brightness of the image. This maybe useful to invoke during the image upload process.
command =>  filter.py --image 'path to input image/filename' --output 'path to write new image' --mode 'h' --value [integer]

apply_gaussian_filter() 
uses a Gaussian blurring effect to brighten the image.  Front-end can change the effect of the image by passing in two arguments
radius and strength 
command =>  filter.py --image 'path to input image/filename' --output 'path to write new image' --mode 'g' --radius [integer] --strength [integer]

apply_glow_effect() 
Is the api end point that triggers the adjust_contrast_brightness()

'''


def detect_brightness(image_path):
    try:
        # Check if file exists
        os.path.exists(image_path)
        img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
        filename = os.path.basename(image_path)
        # Calculate mean brightness as percentage
        mean_percent = np.mean(img) * 100 / 255
        classification = "dark" if mean_percent < 49 else "light"
        app.logger.info(f'{filename}: {classification} ({mean_percent:.1f}%)')
        return classification
    except:
        FileNotFoundError


def adjust_contrast_brightness(image_path, brightness, output):
    # Check if file exists
    if os.path.exists(image_path):
        # Apply filter if mean brightness was below 50%
        filename = os.path.basename(image_path)
        #if detect_brightness(image_path) == "dark":
        img = cv2.imread(image_path)
        dst = img.copy()
        if brightness != 0:
            if brightness > 0:
                shadow = brightness
                highlight = 255
            else:
                shadow = 0
                highlight = 255 + brightness

        alpha_b = (highlight - shadow) / 255
        gamma_b = shadow
        adjusted_image = cv2.convertScaleAbs(img, dst, alpha_b, gamma_b)
        # Check if output folder exists
        if not os.path.exists(output):
            os.makedirs(output)
        # Write the image to the output path
        cv2.imwrite(os.path.join(output, f'{filename}'), adjusted_image)
        return os.path.join(output, filename)


def adjust_hue_saturation_value(image_path, brightness, output):
    # Check if file exists
    if os.path.exists(image_path):
        # Apply filter if mean brightness was below 50%
        filename = os.path.basename(image_path)
        if detect_brightness(image_path) == "dark":
            img = cv2.imread(image_path)
            hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
            h, s, v = cv2.split(hsv)

            lim = 255 - brightness
            v[v > lim] = 255
            v[v <= lim] += brightness

            final_hsv = cv2.merge((h, s, v))
            adjusted_image = cv2.cvtColor(final_hsv, cv2.COLOR_HSV2BGR)
            # Check if output folder exists
            if not os.path.exists(output):
                os.makedirs(output)
            # Write the image to the output path
            cv2.imwrite(os.path.join(output, f'{filename}'), adjusted_image)
            return os.path.join(output, filename)


def apply_gaussian_filter(image_path, radius, strength, output):
    # Check if file exists
    if os.path.exists(image_path):
        filename = os.path.basename(image_path)
        img = cv2.imread(image_path, cv2.IMREAD_COLOR)
        img_blurred = cv2.GaussianBlur(img, (radius, radius), 1)
        adjusted_image = cv2.addWeighted(img, 1, img_blurred, strength, 0)
        # Check if output folder exists
        if not os.path.exists(output):
            os.makedirs(output)
        # Write the image to the output path
        cv2.imwrite(os.path.join(output, f'{filename}'), adjusted_image)
        return os.path.join(output, filename)


@app.route('/api/glow-effect/update/<int:location_id>/<int:brightness>', methods=['POST'])
def apply_glow_effect(location_id, brightness):
    # Get Location
    location = db.session.query(Location).filter(Location.location_id == location_id).first()
    # Get the absolute file path of the panoramic image
    image_path = api_upload_resolve_path(location.pano_file_path).replace("\\", "/")
    # Strip the filename from the output path
    output = api_upload_resolve_path(os.path.dirname(location.pano_file_path)).replace("\\", "/")
    # applies brightness value to the image
    adjust_contrast_brightness(image_path, brightness, output)
    # store filter value
    filter = Filter(brightness)
    db.session.add(filter)
    db.session.commit()
    # Save filter settings of panoramic image
    location.filter_id = filter.filter_id
    filter.filter_name = 'glow'
    db.session.commit()
    app.logger.info(f'State of location_id {location_id} is {location.state}')
    app.logger.info(f'Glow effect applied to {image_path} ')
    payload = {
            'message': f'Glow effect was applied successfully.'
        }
    return jsonify(payload), 200


def main(in_args):
    args = parser.parse_args(in_args)

    if args['mode'] == 'b':
        adjust_contrast_brightness(args['image'], args['value'], args['output'])
    elif args['mode'] == 'h':
        adjust_hue_saturation_value(args['image'], args['value'], args['output'])
    elif args['mode'] == 'g':
        apply_gaussian_filter(args['image'], args['radius'], args['strength'], args['output'])


if __name__ == "__main__":
    main(sys.argv[1:])
