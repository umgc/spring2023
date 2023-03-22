from virotour.tests.common_utils import list_tours, add_tour


def test_add_tour(client):
    data = add_tour(client, "Tour 1", "Tour Description Example")
    assert data['message'] == "Tour Tour 1 has been created successfully."

    data = add_tour(client, "Tour 2", "Tour Description Example 2")
    assert data['message'] == "Tour Tour 2 has been created successfully."

    data = list_tours(client)
    assert data['count'] == 2
