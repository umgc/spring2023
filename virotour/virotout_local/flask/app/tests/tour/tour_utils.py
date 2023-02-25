from app.utils import parse_http_response


def list_tours(client):
    return parse_http_response(client.get('/api/tours'))


def get_tour_by_id(client, id):
    return parse_http_response(client.get(f'/api/tour/{id}'))


def get_tour_by_name(client, name):
    return parse_http_response(get_tour_by_name_with_resp(client, name))


def get_tour_by_name_with_resp(client, name):
    return client.get(f'/api/tour-name/{name}')


def add_tour(client, name, description):
    return parse_http_response(
        client.post('/api/add/tour', json={
            'name': name,
            'description': description
        })
    )


def update_tour(client, name, description):
    return parse_http_response(update_tour_with_resp(client, name, description))


def update_tour_with_resp(client, name, description):
    resp = get_tour_by_name_with_resp(client, name)
    if resp.status_code != 200:
        return resp

    tour = parse_http_response(resp)
    id = tour['id']
    resp = client.post(f'/api/update/tour/{id}', json={
        'name': name,
        'description': description
    })

    return resp


def delete_tour(client, name, description):
    return parse_http_response(delete_tour_with_resp(client, name, description))


def delete_tour_with_resp(client, name, description):
    resp = get_tour_by_name_with_resp(client, name)
    if resp.status_code != 200:
        return resp

    tour = parse_http_response(resp)
    id = tour['id']
    resp = client.post(f'/api/delete/tour/{id}', json={
        'name': name,
        'description': description
    })

    return resp
