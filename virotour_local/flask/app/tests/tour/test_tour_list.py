from app.tests.tour.tour_utils import list_tours, add_tour, update_tour, get_tour_by_id, get_tour_by_name
from app.tests.common_utils import parse_http_response


def test_no_tours(client):
    data = list_tours(client)
    assert data['count'] == 0
    assert data['tours'] == []


def test_get_tour(client):
    add_tour(client, "T1", "Desc4")
    add_tour(client, "T2", "Desc3")
    add_tour(client, "T3", "Desc2")
    add_tour(client, "T4", "Desc1")

    # List & count tours
    data = list_tours(client)
    assert data['count'] == 4

    # Search by ID
    data = get_tour_by_id(client, 3)
    assert data['id'] == 3
    assert data['name'] == "T3"
    assert data['description'] == "Desc2"

    # Search by Name
    data = get_tour_by_name(client, "T4")
    assert data['id'] == 4
    assert data['name'] == "T4"
    assert data['description'] == "Desc1"
