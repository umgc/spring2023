from virotour import app
from virotour.api.compute.neighbor_util import find_hotspot


def compute_neighbors(locations):
    ids = [x.location_id for x in locations]
    image_path_candidates = [x.pano_file_path for x in locations]
    app.logger.info(f"Input to compute tour: {image_path_candidates}")
    hotspots = find_hotspot.main(image_path_candidates)
    if len(hotspots) > 0:
        result = dict(zip(ids, hotspots))
    else:
        result = dict()
    return result
