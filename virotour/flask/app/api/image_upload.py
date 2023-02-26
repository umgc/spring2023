import os

from flask import request, flash, redirect, jsonify

from app import allowed_file, app


@app.route('/api/add/tour/images/<int:id>', methods=['POST', 'GET'])
def api_add_tour_images(id):
    if request.method == 'POST':
        if 'files[]' not in request.files:
            flash('No file part')
            return redirect(request.url)

        files = request.files.getlist('files[]')
        result = {}

        for file in files:
            if file and allowed_file(file.filename):
                filename_raw = file.filename
                filename = os.path.basename(filename_raw)
                target_path = os.path.join(app.config['UPLOAD_FOLDER'], str(id))
                target_file = os.path.join(target_path, filename)
                result[filename] = f'uploads/{id}/{filename}'
                os.makedirs(target_path, exist_ok=True)
                file.save(target_file)

        flash('File(s) successfully uploaded')
        payload = {
            'tour_id': id,
            'server_file_paths': result
        }
        return jsonify(payload), 200
