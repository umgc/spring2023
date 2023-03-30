import argparse
import sys

import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt

from virotour import app


def draw_contours(img, cnts):  # conts = contours
    img = np.copy(img)
    img = cv.drawContours(img, cnts, -1, (0, 255, 0), 2)
    return img


def find_center(img, cnts, scale):  # conts = contours
    img = np.copy(img)
    center_list = []

    for cnt in cnts:
        (x, y), _ = cv.minEnclosingCircle(cnt)
        center = (int(x) * scale, int(y) * scale)
        # app.logger.info(center)
        center_list.append(center)

    return center_list


def caculate_points(img, scale):
    image = cv.imread(img)
    thresh = cv.Canny(image, 128, 256)

    contours, hierarchy = cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    list = find_center(image, contours, scale)

    return list


def find_hotspot(img_list):
    if len(img_list) < 2:
        return []

    hotspot_list = []
    spot_img = None
    scale = 3

    for i in range(0, len(img_list) - 1):

        img1 = cv.imread(img_list[i], cv.IMREAD_GRAYSCALE)
        img2 = cv.imread(img_list[i + 1], cv.IMREAD_GRAYSCALE)

        w1 = img1.shape[0] // scale
        h1 = img1.shape[1] // scale

        w2 = img2.shape[0] // scale
        h2 = img2.shape[1] // scale

        img1_small = cv.resize(img1, (h1, w1))
        img2_small = cv.resize(img2, (h2, w2))

        cv.imwrite('img1_small.jpg', img1_small)

        w = img1_small.shape[0]
        h = img1_small.shape[1]

        # draw blk image as background
        img_bk = np.zeros((w, h, 3), np.uint8)

        # Initiate SIFT detector
        sift = cv.SIFT_create()

        # find the keypoints and descriptors with SIFT
        kp1, des1 = sift.detectAndCompute(img1_small, None)
        kp2, des2 = sift.detectAndCompute(img2_small, None)

        # FLANN parameters
        FLANN_INDEX_KDTREE = 1
        index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
        search_params = dict(checks=50)  # or pass empty dictionary
        flann = cv.FlannBasedMatcher(index_params, search_params)
        matches = flann.knnMatch(des1, des2, k=2)

        list_kp1 = []
        list_kp2 = []

        # Need to draw only good matches, so create a mask
        matchesMask = [[0, 0] for i in range(len(matches))]

        # ratio test as per Lowe's paper
        for j, (m, n) in enumerate(matches):
            if m.distance < 0.40 * n.distance:
                matchesMask[j] = [1, 0]

                img1_idx = m.queryIdx
                img2_idx = m.trainIdx

                (x1, y1) = kp1[img1_idx].pt
                (x2, y2) = kp2[img2_idx].pt

                list_kp1.append((x1, y1))
                list_kp2.append((x2, y2))

        list_int_kp1 = []


        for k in range(0, len(list_kp1)):
            list_int_kp1.append((int(list_kp1[k][0]), int(list_kp1[k][1])))


        for center in list_int_kp1:
            spot_img = cv.circle(img_bk, center, radius=min(h1, w1) // 8, color=(255, 255, 255), thickness=-1)

        if spot_img is not None:
            cv.imwrite('hotspot.jpg', spot_img)
            list = caculate_points('hotspot.jpg', scale)
            hotspot_list.append(list)

        if i + 1 == len(img_list) - 1:
            list_int_kp2 = []
            for i in range(0, len(list_kp2)):
                list_int_kp2.append((int(list_kp2[i][0]), int(list_kp2[i][1])))

            for center in list_int_kp2:
                spot_img = cv.circle(img_bk, center, radius=min(h1, w1) // 8, color=(255, 255, 255), thickness=-1)

            if spot_img is not None:
                cv.imwrite('hotspot.jpg', spot_img)
                list = caculate_points('hotspot.jpg', scale)
                hotspot_list.append(list)

    return hotspot_list


def main(img_names):
    result = find_hotspot(img_names)
    return result


if __name__ == '__main__':
    main(sys.argv[1:])
