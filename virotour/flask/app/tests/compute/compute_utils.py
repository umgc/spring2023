import io

from app.tests.common_utils import parse_http_response
from app.tests.tour.tour_utils import get_tour_by_name_with_resp


def compute_tour(client, name):
    return parse_http_response(compute_tour_with_resp(client, name))


def compute_tour_with_resp(client, name):
    target = f'/api/compute-tour/{name}'
    return client.get(f'/api/compute-tour/{name}')

