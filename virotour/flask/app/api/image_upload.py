import os

from flask import request, flash, redirect, jsonify

from app import allowed_file, app, db
from app.models import Tour, Location, Image

@app.route('/api/add/tour/images/<string:name>', methods=['POST', 'GET'])
def api_add_tour_images(name):
    if request.method == 'POST':
        if 'files[]' not in request.files:
            flash('No file part')
            return redirect(request.url)

        files = request.files.getlist('files[]')
        result = {}

        tour = db.session.query(Tour).filter(Tour.name == name).first()
        location = Location(tour.id)
        db.session.add(location)
        db.session.commit()  

        for file in files:
            if file and allowed_file(file.filename):
                filename_raw = file.filename
                filename = os.path.basename(filename_raw)
                target_path = os.path.join(app.config['UPLOAD_FOLDER'], str(tour.id))
                target_file = os.path.join(target_path, filename)
                result[filename] = f'uploads/{tour.id}/{filename}'
                os.makedirs(target_path, exist_ok=True)
                file.save(target_file)

                image = Image(location.location_id, target_path)
                db.session.add(image)
                db.session.commit()

        flash('File(s) successfully uploaded')
        payload = {
            'tour_id': id,
            'server_file_paths': result
        }
        return jsonify(payload), 200
