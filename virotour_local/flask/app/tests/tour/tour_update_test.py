from app.tests.tour.tour_utils import add_tour, update_tour, update_tour_with_resp, get_tour_by_id


def test_update_tour(client):
    add_tour(client, "Tour 1A", "_")
    update_tour(client, "Tour 1A", "New Description")

    data = get_tour_by_id(client, 1)
    assert data['name'] == "Tour 1A"
    assert data['description'] == "New Description"


def test_update_non_existing(client):
    resp = update_tour_with_resp(client, "Tour 1B", "Desc")
    assert resp.status_code == 404
    assert resp.status == "404 NOT FOUND"
