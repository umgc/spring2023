import json
import os


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
        client.post('/api/tour/add', json={
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
    resp = client.post(f'/api/tour/update/{id}', json={
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
    resp = client.post(f'/api/tour/delete/{id}', json={
        'name': name,
        'description': description
    })

    return resp


def upload_images(client, name, image_list):
    return parse_http_response(upload_images_with_resp(client, name, image_list))


def upload_images_with_resp(client, name, image_list):
    files = {fpath: open(fpath, 'rb') for fpath in image_list}
    return client.post(f'/api/tour/add/images/{name}', data=files)


def get_image_paths(path):
    image_dir = os.path.join(os.path.dirname(__file__), 'images', path)
    image_list = os.listdir(image_dir)
    return [f"{image_dir}/{file}" for file in image_list]
    pass


def get_image_path(relative_path):
    """Get image path from 'images' folder"""
    image_path = os.path.join(os.path.dirname(__file__), 'images', relative_path)
    return image_path


def get_raw_images(client, tour_name, location_id):
    return parse_http_response(get_raw_images_with_resp(client, tour_name, location_id))


def get_raw_images_with_resp(client, tour_name, location_id):
    return client.get(f'/api/tour/images/raw-images/{tour_name}/{location_id}')


def compute_tour(client, name):
    return parse_http_response(compute_tour_with_resp(client, name))


def compute_tour_with_resp(client, name):
    return client.get(f'/api/compute-tour/{name}')


def get_panoramic_image(client, tour_name, location_id):
    return parse_http_response(get_panoramic_image_with_resp(client, tour_name, location_id))


def get_panoramic_image_with_resp(client, tour_name, location_id):
    return client.get(f'/api/tour/images/panoramic-image/{tour_name}/{location_id}')


def get_panoramic_image_file(client, tour_name, location_id):
    return get_panoramic_image_file_with_resp(client, tour_name, location_id)


def get_panoramic_image_file_with_resp(client, tour_name, location_id):
    return client.get(f'/api/tour/images/panoramic-image-file/{tour_name}/{location_id}')

def set_panoramic_image(client, tour_name, location_id, path):
    return parse_http_response(get_raw_images_with_resp(client, tour_name, location_id, path))


def set_panoramic_image_with_resp(client, tour_name, location_id, path):
    return client.post(f'/api/tour/images/panoramic-image/{tour_name}/{location_id}', data={
        'panoramic_path': path
    })


def get_search_results(client, tour_name, search_input):
    return parse_http_response(get_search_results_with_resp(client, tour_name, search_input))


def get_search_results_with_resp(client, tour_name, search_input):
    return client.get(f'/api/tour/search/{tour_name}/{search_input}')


def get_tour_locations(client, search_input):
    return parse_http_response(get_tour_locations_with_resp(client, search_input))


def get_tour_locations_with_resp(client, tour_name):
    return client.get(f'/api/tour/locations/{tour_name}')


def parse_http_response(resp):
    try:
        print(str(resp))
        return json.loads(resp.data.decode())
    except:
        raise Exception(resp.data)
