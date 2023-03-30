import os

from virotour import app
from virotour.api.compute.pano_util import stitch
from virotour.api.image_upload import api_get_tour_images
from virotour.api.tour import api_get_tour_by_name


def compute_panoramic(tour_name, location_id):
    image_list = api_get_tour_images(tour_name, location_id)
    tour_id = api_get_tour_by_name(tour_name)[0].json['id']
    file_paths = [x for x in image_list[0].json['server_file_paths']]
    file_extension = os.path.splitext(file_paths[0])[1]
    target_file = f"panoramic_images/T_{tour_id}_L_{location_id}_pano{file_extension}"
    args = ["--img_names", file_paths, "--output_path", f"{target_file}"]
    flatlist = []
    for element in args:
        if type(element) == str:
            flatlist.append(element)
        else:
            for inner_element in element:
                flatlist.append(inner_element)
    app.logger.info(f'Input to panoramic compute: {flatlist}')

    return stitch.main(flatlist)
