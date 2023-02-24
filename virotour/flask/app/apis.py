import os

from flask import Flask, request, jsonify, flash, redirect

from app import app, db
from .file_utils import allowed_file
from .models import Tour


@app.after_request
def add_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


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
        'name': tour.name,
        'description': tour.description
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
        'name': tour.name,
        'description': tour.description
    }
    return jsonify(payload), 200


@app.route('/api/add/tour', methods=['POST'])
def api_add_tour():
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


@app.route('/api/update/tour/<int:id>', methods=['POST', 'PUT'])
def api_update_tour(id):
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


@app.route('/api/delete/tour/<int:id>', methods=['POST', 'DELETE'])
def api_delete_tour(id):
    tour = Tour.query.f.get_or_404(id)
    db.session.delete(tour)
    db.session.commit()
    payload = {
        'message': f'Tour {tour.name} successfully deleted.',
    }
    return jsonify(payload), 200


@app.route('/api/add/tour/images', methods=['POST'])
def api_add_tour_images():
    if request.method == 'POST':
        if 'files[]' not in request.files:
            flash('No file part')
            return redirect(request.url)

        files = request.files.getlist('files[]')

        for file in files:
            if file and allowed_file(file.filename):
                filename = file.filename
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        flash('File(s) successfully uploaded')
        return redirect('/')
