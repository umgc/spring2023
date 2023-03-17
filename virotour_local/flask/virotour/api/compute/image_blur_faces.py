import os

import cv2

from virotour.api.image_upload import api_get_panoramic_image, api_upload_resolve_path
from virotour.api.tour import api_get_tour_by_name


def image_blur_faces(tour_name, location_id):
    image_path = api_get_panoramic_image(tour_name, location_id)[0].json['server_file_path']
    if image_path is None:
        return None
    file_extension = os.path.splitext(image_path)[1]
    tour_id = api_get_tour_by_name(tour_name)[0].json['id']
    target_file = f"panoramic_images/T_{tour_id}_L_{location_id}_pano_blurred{file_extension}"
    image_blur_faces_main(image_path, target_file)
    return target_file


def image_blur_faces_main(image_path, target_file):
    output_path_resolved = api_upload_resolve_path(target_file)
    full_path_of_file = api_upload_resolve_path(image_path)
    full_img = cv2.imread(cv2.samples.findFile(full_path_of_file))
    detectorPath = getPathToDetectorFile()
    detector = loadFaceDetector(detectorPath)
    grayImage = grayscaleImage(full_img)
    faces = detectFaces(grayImage, detector)
    result = blurFaces(full_img, faces)
    cv2.imwrite(output_path_resolved, result)
    return target_file


def getPathToDetectorFile():
    pathToDetector = cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
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
