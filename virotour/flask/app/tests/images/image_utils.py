import io

from app.tests.common_utils import parse_http_response
from app.tests.tour.tour_utils import get_tour_by_name_with_resp


def upload_images(client, name, image_list):
    return parse_http_response(upload_images_with_resp(client, name, image_list))


def upload_images_with_resp(client, name, image_list):
    resp = get_tour_by_name_with_resp(client, name)
    if resp.status_code != 200:
        raise Exception("Error finding tour: " + str(resp))

    tour = parse_http_response(resp)
    id = tour['id']

    files = []
    try:
        files = [open(fpath, 'rb') for fpath in image_list]
        return client.post(f'/api/add/tour/images/{id}', data={
            'files[]': files
        })
    finally:
        for fp in files:
            fp.close()
