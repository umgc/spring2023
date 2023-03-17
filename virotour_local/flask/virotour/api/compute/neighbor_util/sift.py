import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt

# gray_img = cv.imread('1.jpg', 0)
#gray = cv.cvtColor(img, cv.COLOR_BAYER_BG2GRAY)

# sift = cv.SIFT_create()
# kp = sift.detect(gray_img, None)

# img = cv.drawKeypoints(gray_img, kp, gray_img)
# cv.imwrite('1_keypoints.jpg', img)

# img=cv.drawKeypoints(gray_img, kp, gray_img,flags=cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
# cv.imwrite('1_keypoints_circle.jpg',img)

img1 = cv.imread('st_1.jpg',cv.IMREAD_GRAYSCALE)
img2 = cv.imread('st_2.jpg',cv.IMREAD_GRAYSCALE) 

# Initiate SIFT detector
sift = cv.SIFT_create()

# find the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1,None)
kp2, des2 = sift.detectAndCompute(img2,None)

# BFMatcher with default params
bf = cv.BFMatcher()
matches = bf.knnMatch(des1,des2,k=2)

# Apply ratio test
good = []
for m,n in matches:
    if m.distance < 0.5*n.distance:
        good.append([m])


# cv.drawMatchesKnn expects list of lists as matches.
img3 = cv.drawMatchesKnn(img1,kp1,img2,kp2,good,None,flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)


cv.imwrite('45.jpg',img3)
#plt.imshow(img3),plt.show()





