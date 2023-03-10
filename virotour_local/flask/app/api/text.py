from flask import jsonify

from app import db, app
from app.models import Text, Tour


def api_set_text_search_results(tour_id, location_id, data):
    """This is an internal call, so there is not a user-facing route."""
    if len(data) <= 0:
        return

    for text_entry in data:
        db_text_entry = Text(tour_id,
                             location_id,
                             text_entry['content'],
                             text_entry['position']['x'],
                             text_entry['position']['y'],
                             text_entry['position']['z'])
        db.session.add(db_text_entry)
        db.session.commit()
    return None


@app.route('/api/tour/search/<string:tour_name>/<string:search_input>', methods=['GET'])
def api_set_text_search(tour_name, search_input):
    """
        Return location information for a given search criteria.
        ---
        parameters:
          - tour_name: string
          - search_input: string
        responses:
          200:
            description: Success! TODO Add return type.
    """
    try:
        # Get Tour
        tour = db.session.query(Tour).filter(Tour.name == tour_name).first()

        # Search text
        search_results = db.session.query(Text).filter((Text.tour_id == tour.id) & (Text.text_content.ilike(f"%{search_input}%"))).all()

        # Return results
        results = [{
            'location_id': result.location_id,
            'text_content': result.text_content,
            'position_x': result.position_x,
            'position_y': result.position_y,
            'position_z': result.position_z,
        } for result in search_results]

        payload = {
            'results': results
        }
        return jsonify(payload), 200
    except:
        payload = {
            'message': f'There was an issue with the search request'
        }
        return jsonify(payload), 404
