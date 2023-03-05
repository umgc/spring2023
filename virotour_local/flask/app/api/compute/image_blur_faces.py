from app.api.image_upload import api_get_tour_images, api_get_panoramic_image

import cv2

def image_blur_faces(tour_name, location_id):
    image_list = api_get_tour_images(tour_name, location_id)
    blurred_image_list = image_blur_faces_main(image_list)
    return blurred_image_list

def image_blur_faces_main(image_list):
    for image in image_list:
        detectorPath = getPathToDetectorFile()
        detector = loadFaceDetector(detectorPath)
        grayImage = grayscaleImage(image)
        faces = detectFaces(grayImage,detector)
        blurFaces(image, faces)
    return image_list

def getPathToDetectorFile():
    pathToDetector = "haarcascade_frontalface_default.xml"
    return pathToDetector

def loadFaceDetector(pathToDetector):
    detector = cv2.CascadeClassifier(pathToDetector)
    return detector

def grayscaleImage(image):
    grayImage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return grayImage

def detectFaces(grayImage, detector):
    faces = detector.detectMultiScale(grayImage,
                                      scaleFactor=1.05,
                                      minNeighbors=7,
                                      minSize=(30, 30),
                                      flags=cv2.CASCADE_SCALE_IMAGE)
    return faces

def getFacesDetectedLength(faces):
    facesDetected = len(faces)
    return facesDetected

def blurFaces(image, faces):
    for (x, y, w, h) in faces:
        image[y:y + h, x:x + w] = cv2.GaussianBlur(image[y:y + h, x:x + w], (15, 15), cv2.BORDER_DEFAULT)
    return image