from app.tests.common_utils import list_tours, add_tour, update_tour_with_resp, delete_tour


def test_delete_tour(client):
    add_tour(client, "Tour 1A", "_")
    add_tour(client, "Tour 1B", "_")
    delete_tour(client, "Tour 1B", "_")

    # Tour 1A should still be there
    data = list_tours(client)
    assert data['count'] == 1

    # Tour 1B should be gone
    resp = update_tour_with_resp(client, "Tour 1B", "Desc")
    assert resp.status_code == 404
    assert resp.status == "404 NOT FOUND"

