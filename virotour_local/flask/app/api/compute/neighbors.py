from app.api.image_upload import api_get_tour_images


def compute_neighbors(tour_name, location_id):
    image_list = api_get_tour_images(tour_name, location_id)
    pass
