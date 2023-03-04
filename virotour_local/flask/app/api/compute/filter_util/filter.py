import numpy as np
import cv2
import os
import argparse

# Instantiate the parser
parser = argparse.ArgumentParser(description='Increase the brightness of an image')
# Construct the arguments
parser.add_argument("-i", "--image", type=str, required=True, help="path to input image")
parser.add_argument("-o", "--output", type=str, required=True, help="output path")
parser.add_argument("-m", "--mode", type=str, required=True, choices=['b', 'h', 'g'], help="mode")
parser.add_argument("-v", "--value", type=int, help="brightness value")
parser.add_argument("-r", "--radius", type=int, help="glow radius")
parser.add_argument("-s", "--strength", type=int, help="glow strength")
args = vars(parser.parse_args())

image_path = args["image"]
mode = args["mode"]
filename = os.path.basename(args["image"])
brightness = args["value"]
output = args["output"]
radius = args["radius"]
strength = args["strength"]

'''
There are three different methods to apply a filter to illuminate a single image:

adjust_brightness(): 
Calculates the brightness of an image. If the image mean brightness of the image is calculated to be less than 50%,
it uses the alpha/beta pixel values to adjust brightness of the image. This maybe useful to invoke during the image upload process.
command =>  filter.py --image 'path to input image/filename' --output 'path to write new image' --mode 'b' --value [integer]

adjust_hsv(): 
Calculates the brightness of an image. If the image mean brightness of the image is calculated to be less than 50%,
it uses the hue and saturation values to adjust the brightness of the image. This maybe useful to invoke during the image upload process.
command =>  filter.py --image 'path to input image/filename' --output 'path to write new image' --mode 'h' --value [integer]

apply_glow() 
uses a Gaussian blurring effect to brighten the image.  Front-end can change the effect of the image by passing in two arguments
radius and strength 
command =>  filter.py --image 'path to input image/filename' --output 'path to write new image' --mode 'g' --radius [integer] --strength [integer]

TO DO: Append some indicator to filename to indicate filter was applied
TO DO: Add file extension validation
'''


def detect_brightness(image_path, filename):
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    # Calculate mean brightness as percentage
    mean_percent = np.mean(img) * 100 / 255
    classification = "dark" if mean_percent < 49 else "light"
    print(f'{filename}: {classification} ({mean_percent:.1f}%)')
    return classification


def adjust_brightness(image_path, filename, brightness, output):
    # Apply filter if mean brightness was below 50%
    if detect_brightness(image_path, filename) == "dark":
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
        # Write the image to the output path
        cv2.imwrite(os.path.join(output, f'{filename}'), adjusted_image)


def adjust_hsv(image_path, filename, brightness, output):
    # Apply filter if mean brightness was below 50%
    if detect_brightness(image_path, filename) == "dark":
        img = cv2.imread(image_path)
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        h, s, v = cv2.split(hsv)

        lim = 255 - brightness
        v[v > lim] = 255
        v[v <= lim] += brightness

        final_hsv = cv2.merge((h, s, v))
        adjusted_image = cv2.cvtColor(final_hsv, cv2.COLOR_HSV2BGR)
        # Write the image to the output path
        cv2.imwrite(os.path.join(output, f'{filename}'), adjusted_image)


def apply_glow(image_path, filename, radius, strength, output):
    img = cv2.imread(image_path, cv2.IMREAD_COLOR)
    img_blurred = cv2.GaussianBlur(img, (radius, radius), 1)
    adjusted_image = cv2.addWeighted(img, 1, img_blurred, strength, 0)
    # Write the image to the output path
    cv2.imwrite(os.path.join(output, f'{filename}'), adjusted_image)


def main():
    if mode == 'b':
        adjust_brightness(image_path, filename, brightness, output)
    elif mode == 'h':
        adjust_hsv(image_path, filename, brightness, output)
    elif mode == 'g':
        apply_glow(image_path, filename, radius, strength, output)


if __name__ == "__main__":
    main()
