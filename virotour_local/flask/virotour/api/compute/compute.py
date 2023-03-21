from flask import jsonify

from virotour import app, db
from virotour.api.compute.image_blur_faces import image_blur_faces
from virotour.api.compute.image_extract_text import image_extract_text
from virotour.api.compute.neighbors import compute_neighbors
from virotour.api.compute.panoramic import compute_panoramic
from virotour.api.image_upload import api_set_panoramic_image
from virotour.api.text import api_set_text_search_results
from virotour.api.tour import api_get_tour_by_name, api_set_neighbors
from virotour.models import Location, Tour


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
    app.logger.info(f"Computing Tour for {tour_name}")
    # Get Tour
    tour = db.session.query(Tour).filter(Tour.name == tour_name).first()

    # For all locations, compute panoramic_images image
    locations = Location.query.filter(Location.tour_id == tour.id).all()
    for location in locations:
        app.logger.info(f"Computing Panoramic for location_id:{location.location_id}")
        output_path = compute_panoramic(tour_name, location.location_id)
        location.state = 'panoramic'
        db.session.commit()
        app.logger.info(f'State of location_id {location.location_id} updated to panoramic')
        api_set_panoramic_image(tour_name, location.location_id, output_path)

    # For all locations, compute neighbors
    app.logger.info(f"Computing hotspots")
    hotspot_results = compute_neighbors(locations)
    app.logger.info(f'hotspot results: {hotspot_results}')
    api_set_neighbors(tour_name, hotspot_results)

    # For all images, blur faces
    for location in locations:
        app.logger.info(f"Computing Blur Faces for location_id:{location.location_id}")
        output_path = image_blur_faces(tour_name, location.location_id)
        api_set_panoramic_image(tour_name, location.location_id, output_path)

    # For all images, extract text
    for location in locations:
        app.logger.info(f"Computing Text Extraction for location_id:{location.location_id}")
        hotspot_results = image_extract_text(tour_name, location.location_id)
        api_set_text_search_results(tour.id, location.location_id, hotspot_results)

    return jsonify({}), 200
