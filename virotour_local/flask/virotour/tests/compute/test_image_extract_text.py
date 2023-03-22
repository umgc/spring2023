from virotour.api.compute.image_extract_text import image_extract_text, compute_extracted_text_list
from virotour.tests.common_utils import add_tour, get_image_path, upload_images


def test_extract_text_from_image_with_text(client):
    data = compute_extracted_text_list(get_image_path('input_images/location2/museum.jpg'))

    assert len(data) == 13

    for currentText in data:
        print(currentText)
        assert len(currentText['position']) == 3
        assert currentText['position']['x'] is not None
        assert currentText['position']['y'] is not None
        assert currentText['content'] != ""


def test_extract_text_from_image_with_no_text(client):
    data = compute_extracted_text_list(get_image_path('input_images/location1/S2.jpg'))

    assert len(data) == 0
