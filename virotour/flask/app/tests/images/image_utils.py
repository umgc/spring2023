import io

from app.tests.common_utils import parse_http_response
from app.tests.tour.tour_utils import get_tour_by_name_with_resp


def upload_images(client, name, image_list):
    return parse_http_response(upload_images_with_resp(client, name, image_list))


def upload_images_with_resp(client, name, image_list):
    files = []
    try:
        files = [open(fpath, 'rb') for fpath in image_list]
        return client.post(f'/api/add/tour/images/{name}', data={
            'files[]': files
        })
    finally:
        for fp in files:
            fp.close()


def get_images(client, tour_name, location_id):
    return parse_http_response(get_images_with_resp(client, tour_name, location_id))


def get_images_with_resp(client, tour_name, location_id):
    return client.get(f'/api/tour/images/{tour_name}/{location_id}')
