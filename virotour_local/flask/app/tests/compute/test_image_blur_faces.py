from app.api.compute.image_blur_faces import image_blur_faces
from app.tests.images.test_add_images import get_image_paths
from app.tests.common_utils import add_tour, upload_images, get_image_path

import cv2

def test_image_blur_faces(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")
    image_paths = get_image_paths('input_images/location1')
    upload_images(client, tour_name, image_paths)

    data = image_blur_faces(tour_name, 1)

    assert True == True
    #TODO: Include test images and what they will output

def test_image_blur_faces_main():
    # Arrange
    # Act
    # Assert
    return None

def test_getPathToDetectorFile():
    # Arrange
    expectedPathToDetectorFile = "../api/compute/blur_faces_util/haarcascade_frontalface_default.xml"
    # Act
    actualFile = image_blur_faces.getPathToDetectorFile()
    # Assert
    assert actualFile == expectedPathToDetectorFile, "Actual Path to Detector File should be '{expected}' but was '{actual}'".format(expected = expectedPathToDetectorFile, actual = actualFile)

def test_loadFaceDetector():
    # Arrange
    expectedDetector = cv2.CascadeClassifier("../../api/compute/blur_faces_util/haarcascade_frontalface_default.xml")
    # Act
    actualDetector = cv2.CascadeClassifier("../../api/compute/blur_faces_util/haarcascade_frontalface_default.xml")
    # Assert
    assert actualDetector == expectedDetector, "Actual Detector is not the expected Detector."

def test_grayscaleImage():
    # Arrange
    isGrayscale = False
    imagePath = ""
    image = cv2.imread(imagePath)
    # Act
    greyImage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    if greyImage.any() != None:
        if (len(greyImage.shape) < 2):
            isGrayscale = True
        elif len(greyImage.shape) == 3:
            isGrayscale = False
    # Assert
    assert isGrayscale == True, "The Image is not grayscale or does not exist."

def test_detectFaces():
    # Arrange
    expectedFacesDetected = 2
    image = get_image_path("input_images/face_blur/messi.png")
    greyImage = image_blur_faces.grayscaleImage(image)
    detector = cv2.CascadeClassifier("../../api/compute/blur_faces_util/haarcascade_frontalface_default.xml")
    # Act
    faces = image_blur_faces.detectFaces(greyImage, detector)
    actualFacesDetected = image_blur_faces.getFacesDetectedLength(faces)
    # Assert
    assert actualFacesDetected == expectedFacesDetected, "Should have detected '{expected}' but was '{actual}'".format(expected = expectedFacesDetected, actual = actualFacesDetected)

def getFacesDetectedLength():
    # Arrange
    faces = ["pic1", "pic2", "pic"]
    expectedFacesLength = 3
    # Act
    actualFacesLength = image_blur_faces.getFacesDetectedLength(faces)
    # Assert
    assert actualFacesLength == expectedFacesLength, "Should have length '{expected}' but was '{actual}'".format(expected=expectedFacesLength, actual=actualFacesLength)

def blurFaces():
    # Arrange
    originalImage = get_image_path("input_images/face_blur/messi.png")
    greyImage = image_blur_faces.grayscaleImage(originalImage)
    detector = cv2.CascadeClassifier("../../api/compute/blur_faces_util/haarcascade_frontalface_default.xml")
    faces = image_blur_faces.detectFaces(greyImage, detector)
    # Act
    blurredImage = image_blur_faces.blurFaces(originalImage, faces)
    # Assert
    assert originalImage != blurredImage, "The image did not properly blur faces."