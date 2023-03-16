from flask import jsonify, request

from app import db, app
from app.models import Tour, Location


@app.route('/api/tours', methods=['GET'])
def api_get_tours():
    """
        Get all tours
        ---
        responses:
          200:
            description: Success!
            schema:
                 description: Response
                 properties:
                   count:
                     type: integer
                   tours:
                     type: array
                     items:
                       properties:
                         id:
                           type: integer
                         name:
                           type: string
                         description:
                           type: string
        """
    # or tours = Tour.query.all()
    tours = db.session.query(Tour).all()
    result = [{
        'id': tour.id,
        'name': tour.name,
        'description': tour.description
    } for tour in tours]
    payload = {
        'count': len(result),
        'tours': result
    }
    return jsonify(payload), 200


@app.route('/api/tour/<int:id>', methods=['GET'])
def api_get_tour_by_id(id):
    """
        Get tour by id
        ---
        parameters:
          - in: path
            name: id
            type: integer
            required: true
            description: ID of the tour
        responses:
          200:
            description: Success!
    """
    tour = Tour.query.get_or_404(id)
    payload = {
        'id': tour.id,
        'name': tour.name,
        'description': tour.description
    }
    return jsonify(payload), 200


@app.route('/api/tour-name/<string:name>', methods=['GET'])
def api_get_tour_by_name(name):
    """
        Get tour by name
        ---
        parameters:
          - in: path
            name: name
            type: string
            required: true
            description: Name of the tour
        responses:
          200:
            description: Success!
            schema:
                description: Response
    """
    try:
        tour = db.session.query(Tour).filter(Tour.name == name).first()
        payload = {
            'id': tour.id,
            'name': tour.name,
            'description': tour.description
        }
        return jsonify(payload), 200
    except:
        payload = {
            'message': f'Tour "{name}" not found'
        }
        return jsonify(payload), 404


@app.route('/api/tour/add', methods=['POST'])
def api_add_tour():
    """
        Add new tour
        ---
        parameters:
          - data: name, description
    """
    if request.is_json:
        data = request.get_json()
        tour = Tour(name=data['name'], description=data['description'])
        db.session.add(tour)
        db.session.commit()
        payload = {
            'message': f'Tour {tour.name} has been created successfully.'
        }
        return jsonify(payload), 201
    else:
        payload = {
            'error': 'The request payload is not JSON format.'
        }
        return jsonify(payload), 404


@app.route('/api/tour/update/<int:id>', methods=['POST'])
def api_update_tour(id):
    """
        Update tour by id
        ---
        parameters:
          - id: int
          - data: name, description
    """
    if request.is_json:
        data = request.get_json()
        tour = Tour.query.get_or_404(id)
        tour.name = data['name']
        tour.description = data['description']
        db.session.commit()
        payload = {
            'message': f'Tour {tour.name} has been updated successfully.'
        }
        return jsonify(payload), 200
    else:
        payload = {
            'error': 'The request payload is not JSON format.'
        }
        return jsonify(payload), 404


@app.route('/api/tour/delete/<int:id>', methods=['POST'])
def api_delete_tour(id):
    """
        Delete tour by id. TODO: We need to clean up the rest of the tables and underlying data.
        ---
        parameters:
          - in: path
            name: id
            type: integer
            required: true
            description: Id of the tour
    """
    tour = Tour.query.get_or_404(id)
    db.session.delete(tour)
    db.session.commit()
    payload = {
        'message': f'Tour {tour.name} successfully deleted.',
    }
    return jsonify(payload), 200


@app.route('/api/tour/locations/<string:tour_name>', methods=['GET'])
def api_locations_for_tour(tour_name):
    """
        List all locations of a tour
        ---
        parameters:
          - in: path
            name: tour_name
            type: string
            required: true
            description: Name of the tour
    """
    tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
    # Get Locations
    locations = db.session.query(Location).filter((Location.tour_id == tour.id)).all()
    payload = {
        'results': [
            {
                "location_id": x.location_id,
                "neighbors": str(x.neighbors if x.neighbors is not None else "")
            } for x in locations
        ]
    }
    return jsonify(payload), 200
