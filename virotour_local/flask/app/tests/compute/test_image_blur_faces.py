<<<<<<< HEAD
from app.api.compute.image_blur_faces import image_blur_faces
=======
from app.api.compute.image_blur_faces import image_blur_faces, image_blur_faces_main, getPathToDetectorFile, \
    grayscaleImage, detectFaces
from app.api.compute.panoramic import compute_panoramic
>>>>>>> development
from app.tests.images.test_add_images import get_image_paths
from app.tests.common_utils import add_tour, upload_images, get_image_path

import cv2

<<<<<<< HEAD
=======

>>>>>>> development
def test_image_blur_faces(client):
    tour_name = "Tour 1"
    add_tour(client, tour_name, "Tour Description Example")
    image_paths = get_image_paths('input_images/location1')
    upload_images(client, tour_name, image_paths)
<<<<<<< HEAD

    data = image_blur_faces(tour_name, 1)

    assert True == True
    #TODO: Include test images and what they will output

def test_image_blur_faces_main():
    # Arrange
    # Act
    # Assert

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
=======
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

>>>>>>> development

def test_grayscaleImage():
    # Arrange
    isGrayscale = False
<<<<<<< HEAD
    imagePath = ""
    image = cv2.imread(imagePath)
    # Act
    greyImage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    if greyImage.any() != None:
        if (len(greyImage.shape) < 2):
=======
    imagePath = get_image_path("input_images/location1/S1.jpg")
    image = cv2.imread(imagePath)
    # Act
    greyImage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    if greyImage.any() is not None:
        if len(greyImage.shape) <= 2:
>>>>>>> development
            isGrayscale = True
        elif len(greyImage.shape) == 3:
            isGrayscale = False
    # Assert
    assert isGrayscale == True, "The Image is not grayscale or does not exist."

<<<<<<< HEAD
def test_detectFaces():
    # Arrange
    expectedFacesDetected = 2
    image = get_image_path("../images/input_images/face_blur/messi.png")
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
    originalImage = get_image_path("../images/input_images/face_blur/messi.png")
    greyImage = image_blur_faces.grayscaleImage(originalImage)
    detector = cv2.CascadeClassifier("../../api/compute/blur_faces_util/haarcascade_frontalface_default.xml")
    faces = image_blur_faces.detectFaces(greyImage, detector)
    # Act
    blurredImage = image_blur_faces.blurFaces(originalImage, faces)
    # Assert
    assert originalImage != blurredImage, "The image did not properly blur faces."
=======

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
>>>>>>> development
