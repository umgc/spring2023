# USAGE
# python haar_face_detector.py --image images/adrian_01.png

# import the necessary packages
import argparse
import imutils
import cv2

# construct the argument parser and parse the arguments
# TODO: This will be a method with the image passed in the cascade we use should always be the same.
#	We might be able to find different cascade face detectors if this one isn't working well.
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", type=str, required=True,
	help="path to input image")
ap.add_argument("-c", "--cascade", type=str,
	default="haarcascade_frontalface_default.xml",
	help="path to haar cascade face detector")
args = vars(ap.parse_args())



# load the haar cascade face detector from
print("[INFO] loading face detector...")
detector = cv2.CascadeClassifier(args["cascade"])

# load the input image from disk, resize it, and convert it to
# grayscale
image = cv2.imread(args["image"])
image = imutils.resize(image, width=500)  # TODO: We'll have to size these images properly or not at all.
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# detect faces in the input image using the haar cascade face
# detector
print("[INFO] performing face detection...")
# TODO: We'll have to alter these variables to our panoramas.
# scaleFactor - Layers that the detector will search through for faces. Smaller & Bigger faces
# 	The more layers the more false positives and longer it takes, we could miss faces that are too
#	large or small.
# minNeighbors - Neighbors of positive face detection. Can reduce false positives. Increase this first.
# minSize - Won't detect smaller
rects = detector.detectMultiScale(gray, scaleFactor=1.05,
	minNeighbors=5, minSize=(30, 30),
	flags=cv2.CASCADE_SCALE_IMAGE)
print("[INFO] {} faces detected...".format(len(rects)))

# loop over the bounding boxes
for (x, y, w, h) in rects:
	# draw the face bounding box on the image
	# TODO: Instead of drawing a bounding box we will blur what is in the box.
	cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)


# show the output image
# TODO: Store the output image instead of
cv2.imshow("Image", image)
cv2.waitKey(0)