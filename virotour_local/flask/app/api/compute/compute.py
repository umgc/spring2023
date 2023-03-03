from flask import jsonify

from app import app
from app.api.compute.image_blur_faces import image_blur_faces
from app.api.compute.image_extract_text import image_extract_text
from app.api.compute.neighbors import compute_neighbors
from app.api.compute.panoramic import compute_panoramic
from app.api.image_upload import api_set_panoramic_image
from app.api.text import api_set_text_search_results
from app.api.tour import api_get_tour_by_name
from app.models import Location


@app.route('/api/compute-tour/<string:tour_name>', methods=['GET'])
def api_compute_tour(tour_name):
    """
        After you have uploaded all images, compute the tour

        1. Compute panoramic for all locations.
        2. Compute neighbors
        3. Blur faces
        4. Extract text
        ---
        parameters:
          - in: path
            name: name
            type: string
            required: true
            description: Name of the tour
        responses:
          500:
            description: Error The language is not awesome!
          200:
            description: It worked!
        """
    tour_id = api_get_tour_by_name(tour_name)[0].json['id']


    # For all locations, compute panoramic_images image
    locations = Location.query.filter(Location.tour_id == tour_id).all()
    for location in locations:
        output_path = compute_panoramic(tour_name, location.location_id)
        api_set_panoramic_image(tour_name, location.location_id, output_path)

    # For all locations, compute neighbors
    for location in locations:
        compute_neighbors(tour_name, location.location_id)

    # For all images, blur faces
    for location in locations:
        image_blur_faces(tour_name, location.location_id)

    # For all images, extract text
    for location in locations:
        result = image_extract_text(tour_name, location.location_id)
        api_set_text_search_results(location.location_id, result)

    return jsonify({}), 200
