import os

from flask import request, flash, redirect, jsonify, send_file

from virotour import app, db
from virotour.api.compute.image_filter import apply_glow_effect
from virotour.models import Tour, Location, Image


@app.route('/api/tour/add/images/<string:tour_name>', methods=['POST'])
def api_add_tour_images(tour_name):
    """
        Upload images to server. In one request, you upload a set of images. This represents one "location". Multiple locations comprise a tour.
        ---
        parameters:
          - in: path
            name: tour_name
            type: string
            required: true
            description: Name of the tour
          - name: file
            required: true
            in: formData
            type: file
    """
    if request.method == 'POST':
        if not request.files:
            flash('No file part')
            app.logger.error(f'Could not find images')
            app.logger.info(request)
            return redirect(request.url)
        app.logger.info(f"{request.files}")
        if request.files.get('files[]'):
            files = request.files.getlist('files[]')
        else:
            files = request.files.to_dict()
        app.logger.info(f"Uploading images as a new location: {files}")
        result = {}

        tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
        location = Location(tour.id)
        db.session.add(location)
        db.session.commit()

        for file in files:
            if file:
                if request.files.get('files[]'):
                    filename_raw = file.filename
                else:
                    filename_raw = file
                filename = os.path.basename(filename_raw)
                target_path = os.path.join(app.config['UPLOAD_FOLDER'], 'raw_images/')
                target_file = f'T_{tour.id}_L_{location.location_id}_{filename}'
                target_file_full = os.path.join(target_path, target_file)

                # To return to user
                result[filename] = f'raw_images/{target_file}'

                # Make directory & save
                os.makedirs(target_path, exist_ok=True)

                if request.files.get('files[]'):
                    file.save(target_file_full)
                else:
                    files[file].save(target_file_full)

                image = Image(tour.id, location.location_id, result[filename])
                db.session.add(image)
                db.session.commit()

        # update state of uploaded images to original
        location.state = "original"
        db.session.commit()
        app.logger.info(f'State of location_id {location.location_id} is {location.state}')

        flash('File(s) successfully uploaded')
        payload = {
            'tour_id': tour.id,
            'server_file_paths': result
        }
        return jsonify(payload), 200


@app.route('/api/tour/images/raw-images/<string:tour_name>/<int:location_id>', methods=['GET'])
def api_get_tour_images(tour_name, location_id):
    """
        Retrieve raw image paths for a given tour and location.
        ---
        parameters:
          - in: path
            name: tour_name
            type: string
            required: true
            description: Name of the tour
          - in: path
            name: location_id
            type: integer
            required: true
            description: Location ID
    """

    app.logger.info(f'Retrieving images for: {tour_name}, location_id {location_id}')
    result = list()
    # Get Tour
    tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
    # Get Location
    location = db.session.query(Location).filter((Location.tour_id == tour.id) &
                                                 (Location.location_id == location_id)).first()
    # Get Images
    images = db.session.query(Image).filter(Image.location_id == location.location_id).all()
    for image in images:
        result.append(image.file_path)

    payload = {
        'count': len(result),
        'server_file_paths': result
    }
    return jsonify(payload), 200


def api_upload_resolve_path(relative_path):
    """
    This is an internal call, so there is not a user-facing route.

    Additional note: if the path to the file is not sufficient, and we need to return the full contents of the file,
    we will need to change the endpoints to use "flask.send_file(...)" or "flask.send_from_directory(...).

    https://flask.palletsprojects.com/en/2.2.x/api/#flask.send_file
    """
    return os.path.abspath(os.path.join(app.config["UPLOAD_FOLDER"], relative_path))


def api_set_panoramic_image(tour_name, location_id, path):
    """This is an internal call, so there is not a user-facing route."""
    # Get Tour
    tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
    # Get Location
    location = db.session.query(Location).filter((Location.tour_id == tour.id) &
                                                 (Location.location_id == location_id)).first()
    location.pano_file_path = path
    db.session.commit()
    return None


@app.route('/api/tour/images/panoramic-image/<string:tour_name>/<int:location_id>', methods=['GET'])
def api_get_panoramic_image(tour_name, location_id):
    """
        After you've computed the tour, you can retrieve the path to the panoramic image.
        ---
        parameters:
          - in: path
            name: tour_name
            type: string
            required: true
            description: Name of the tour
          - in: path
            name: location_id
            type: integer
            required: true
            description: Location ID
    """
    # Get Tour
    tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
    # Get Location
    location = db.session.query(Location).filter((Location.tour_id == tour.id) &
                                                 (Location.location_id == location_id)).first()
    pano_image = location.pano_file_path
    payload = {
        'server_file_path': pano_image
    }
    return jsonify(payload), 200


@app.route('/api/tour/images/panoramic-images/<string:tour_name>', methods=['GET'])
def api_get_panoramic_images(tour_name):
    """
        After you've computed the tour, you can retrieve all panoramic images.
        ---
        parameters:
          - in: path
            name: tour_name
            type: string
            required: true
            description: Name of the tour
    """
    # Get Tour
    tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
    # Get Location
    locations = db.session.query(Location).filter((Location.tour_id == tour.id)).all()

    pano_images = [{
        'pano_file_path': location.pano_file_path,
        'location_id': location.location_id
    } for location in locations]

    payload = {
        'server_file_paths': pano_images
    }

    return jsonify(payload), 200


@app.route('/api/tour/images/panoramic-image-file/<string:tour_name>/<int:location_id>', methods=['GET'])
def api_get_panoramic_image_file(tour_name, location_id):
    """
        After you've computed the tour, you can retrieve the image for a given tour name and location_id.
        ---
        parameters:
          - in: path
            name: tour_name
            type: string
            required: true
            description: Name of the tour
    """
    try:
        # Get Tour
        tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
        # Get Location
        location = db.session.query(Location).filter((Location.tour_id == tour.id) &
                                                     (Location.location_id == location_id)).first()
        pano_image_file = api_upload_resolve_path(location.pano_file_path)

        return send_file(pano_image_file)
    except Exception as e:
        return str(e)


@app.route('/api/tour/images/glow-panoramic-image-file/<string:tour_name>/<int:location_id>/<int:value>',
           methods=['GET'])
def api_get_glow_panoramic_image_file(tour_name, location_id, value):
    """
        After you've computed the tour, you can retrieve the image for a given tour name and location_id.
        ---
        parameters:
          - in: path
            name: tour_name
            value: brightness value
            type: string
            required: true
            description: Name of the tour
    """
    try:
        # Get Tour
        tour = db.session.query(Tour).filter(Tour.name == tour_name).first()
        # Get Location
        location = db.session.query(Location).filter((Location.tour_id == tour.id) &
                                                     (Location.location_id == location_id)).first()
        # brighten the image by applying the glow effect
        apply_glow_effect(location.location_id, value)
        pano_image_file = api_upload_resolve_path(location.pano_file_path)

        return send_file(pano_image_file)
    except Exception as e:
        return str(e)
