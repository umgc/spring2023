from virotour.api.compute.image_blur_faces import image_blur_faces, image_blur_faces_main, getPathToDetectorFile, \
    grayscaleImage, detectFaces
from virotour.api.compute.panoramic import compute_panoramic
from virotour.tests.images.test_add_images import get_image_paths
from virotour.tests.common_utils import add_tour, upload_images, get_image_path

import cv2


def test_image_blur_faces(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")
    image_paths = get_image_paths('input_images/location1')
    upload_images(client, tour_name, image_paths)
    panoramic_image_path = compute_panoramic(tour_name, 1)

    image_blur_faces_main(panoramic_image_path, "result.jpg")

    assert True



def test_getPathToDetectorFile():
    # Arrange
    expectedPathToDetectorFile = cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
    # Act
    actualFile = getPathToDetectorFile()
    # Assert
    assert actualFile == expectedPathToDetectorFile, "Actual Path to Detector File should be '{expected}' but was '{actual}'".format(
        expected=expectedPathToDetectorFile, actual=actualFile)


def test_grayscaleImage():
    # Arrange
    isGrayscale = False
    imagePath = get_image_path("input_images/location1/S1.jpg")
    image = cv2.imread(imagePath)
    # Act
    greyImage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    if greyImage.any() is not None:
        if len(greyImage.shape) <= 2:
            isGrayscale = True
        elif len(greyImage.shape) == 3:
            isGrayscale = False
    # Assert
    assert isGrayscale == True, "The Image is not grayscale or does not exist."


def test_detectFaces():
    # Arrange
    expectedFacesDetected = 2
    image = get_image_path("input_images/face_blur/messi.png")
    greyImage = grayscaleImage(cv2.imread(cv2.samples.findFile(image)))
    detector = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
    # Act
    faces = detectFaces(greyImage, detector)
    actualFacesDetected = len(faces)
    # Assert
    assert actualFacesDetected == expectedFacesDetected, "Should have detected '{expected}' but was '{actual}'".format(
        expected=expectedFacesDetected, actual=actualFacesDetected)
