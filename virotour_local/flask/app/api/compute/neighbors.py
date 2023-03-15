from app import app
from app.api.compute.neighbor_util import find_hotspot
from app.api.image_upload import api_get_panoramic_images


def compute_neighbors(tour_name):
    image_path_candidates = api_get_panoramic_images(tour_name)[0].json['server_file_paths']
    app.logger.info(f"Input to compute tour: {image_path_candidates}")
    return find_hotspot.main(image_path_candidates)
