from app import app
from app.api.image_upload import api_get_panoramic_image, api_upload_resolve_path

import easyocr


def image_extract_text(tour_name, location_id):
    rel_path = api_get_panoramic_image(tour_name, location_id)[0].json['server_file_path']
    full_path = api_upload_resolve_path(rel_path)
    extractTextList = compute_extracted_text_list(full_path)
    return extractTextList


def compute_extracted_text_list(image_url):
    listOfExtractedTexts = []
    reader = easyocr.Reader(['en'])
    result = reader.readtext(image_url)

    # Note: explore confidence percentage level / threshold (0.05)

    for textObj in result:

        # each extracted text object provides a confidence level [0 to 1], determining the accuracy of the match
        # needed to filter out extracted text objects from being returned (chosen value: 0.05 or 5% confidence level)
        confidenceLevel = textObj[2]

        if confidenceLevel > 0.05:
            # the [x, y] coordinates of the four corners that encapsulates the extracted text
            bottomLeftCoords = textObj[0][0]
            bottomRightCoords = textObj[0][1]
            topRightCoords = textObj[0][2]
            topLeftCoords = textObj[0][3]

            # determine average x and y coordinates based on the width and height of box surrounding the text
            averagePositionX = round((topRightCoords[0] + topLeftCoords[0]) / 2)
            averagePositionY = round((topLeftCoords[1] + bottomLeftCoords[1]) / 2)

            currentExtractedTextObj = {
                "position": {"x": averagePositionX, "y": averagePositionY, "z": 0},
                "content": textObj[1]
            }
            print(currentExtractedTextObj)
            listOfExtractedTexts.append(currentExtractedTextObj)

    return listOfExtractedTexts
