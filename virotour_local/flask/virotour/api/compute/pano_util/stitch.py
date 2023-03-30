# Python 2/3 compatibility
from __future__ import print_function

import argparse
import shutil
import sys

import cv2 as cv

from virotour import app
from virotour.api.tour import api_upload_resolve_path

modes = (cv.Stitcher_PANORAMA, cv.Stitcher_SCANS)

parser = argparse.ArgumentParser(
    prog="stitch.py", description="Rotation model images stitcher"
)
parser.add_argument(
    '--img_names', nargs='+',
    help="Files to stitch", type=str
)
parser.add_argument(
    '--output_path',
    help="File to output", type=str
)
parser.add_argument('--mode',
                    type=int, choices=modes, default=cv.Stitcher_PANORAMA,
                    help='Determines configuration of stitcher. The default is `PANORAMA` (%d), '
                         'mode suitable for creating photo panoramas. Option `SCANS` (%d) is suitable '
                         'for stitching materials under affine transformation, such as scans.' % modes)


def main(in_args):
    args = parser.parse_args(in_args)
    img_names = args.img_names
    output_path = args.output_path
    output_path_resolved = api_upload_resolve_path(output_path)

    # If only one image input, then assume it is panoramic already
    if len(img_names) == 1:
        shutil.copyfile(api_upload_resolve_path(img_names[0]), output_path_resolved)
        return output_path_resolved

    imgs = []
    for name in img_names:
        full_path_of_file = api_upload_resolve_path(name)

        full_img = cv.imread(cv.samples.findFile(full_path_of_file))

        if full_img is None:
            app.logger.info("Cannot read image ", name)
            exit()

        imgs.append(full_img)

    stitcher = cv.Stitcher.create(args.mode)
    status, pano = stitcher.stitch(imgs)

    if status != cv.Stitcher_OK:
        app.logger.info("Can't stitch images, error code = %d" % status)
        return None

    app.logger.info("Success! Stitched {}".format(img_names))
    cv.imwrite(output_path_resolved, pano)
    return output_path_resolved


if __name__ == '__main__':
    main(sys.argv[1:])
