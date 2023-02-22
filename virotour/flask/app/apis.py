from flask import Flask, request, jsonify

from app import app, db
from .models import Tour


@app.route('/api/', methods=['GET'])
def api_hello():
    payload = {
        'method': request.method,
        'message': 'Hello World! This is the REST APIs starter template.'
    }
    return jsonify(payload), 200


@app.route('/api/tours', methods=['GET'])
def api_get_tours():
    # or tours = Tour.query.all()
    tours = db.session.query(Tour).all()
    result = [{
        'id': tour.id,
        'name': tour.name
    } for tour in tours]
    payload = {
        'count': len(result),
        'tours': result
    }
    return jsonify(payload), 200


@app.route('/api/tour/<int:id>', methods=['GET'])
def api_get_tour(id):
    tour = Tour.query.get_or_404(id)
    payload = {
        'id': tour.id,
        'name': tour.name
    }
    return jsonify(payload), 200


@app.route('/api/add/tour', methods=['POST'])
def api_add_tour():
    if request.is_json:
        data = request.get_json()
        tour = Tour(name=data['name'])
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


@app.route('/api/update/tour/<int:id>', methods=['POST', 'PUT'])
def api_update_tour(id):
    if request.is_json:
        data = request.get_json()
        tour = Tour.query.get_or_404(id)
        tour.name = data['name']
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


@app.route('/api/delete/tour/<int:id>', methods=['POST', 'DELETE'])
def api_delete_tour(id):
    tour = Tour.query.get_or_404(id)
    db.session.delete(tour)
    db.session.commit()
    payload = {
        'message': f'Tour {tour.name} successfully deleted.',
    }
    return jsonify(payload), 200
