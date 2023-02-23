from flask import render_template, request, redirect, url_for, flash

from app import app, db
from .forms import TourForm
from .forms import UpdateTourForm
from .forms import DeleteTourForm
from .models import Tour


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/about/')
def about():
    return render_template('about.html', name="Starter Template CRUD App using Flask and SQLite")


@app.route('/upload-images/')
def upload_images():
    return render_template('upload-images.html', name="Starter Template CRUD App using Flask and SQLite")


@app.route('/tours')
def show_tours():
    # or tours = Tour.query.all()
    tours = db.session.query(Tour).all()
    return render_template('show_tours.html', tours=tours)


@app.route('/add-tour', methods=['GET', 'POST'])
def add_tour():
    tour_form = TourForm()

    if request.method == 'POST':
        if tour_form.validate_on_submit():
            # Get validated data from form
            # You could also have used request.form['name']
            name = tour_form.name.data
            # You could also have used request.form['email']
            description = tour_form.description.data

            # save tour to database
            tour = Tour(name, description)
            db.session.add(tour)
            db.session.commit()

            flash('Tour successfully added.')
            return redirect(url_for('show_tours'))

    flash_errors(tour_form)
    return render_template('add_tour.html', form=tour_form)


@app.route('/update-tour', methods=['GET', 'POST', 'PUT'])
def update_tour():
    update_tour_form = UpdateTourForm()

    if request.method == 'POST' or request.method == 'PUT':
        if update_tour_form.validate_on_submit():
            # Get validated data from form
            id = update_tour_form.id.data
            updated_name = update_tour_form.name.data
            updated_description = update_tour_form.description.data

            # update tour from database
            tour = db.session.query(Tour).filter(Tour.id == id).first()
            tour.name = updated_name
            tour.description = updated_description
            db.session.commit()

            flash('Tour successfully updated.')
            return redirect(url_for('show_tours'))

    flash_errors(update_tour_form)
    return render_template('update_tour.html', form=update_tour_form)


@app.route('/delete-tour', methods=['GET', 'POST'])
def delete_tour():
    delete_tour_form = DeleteTourForm()

    if request.method == 'POST':
        if delete_tour_form.validate_on_submit():
            # Get validated data from form
            id = delete_tour_form.id.data

            # delete tour from database
            tour = db.session.query(Tour).filter(Tour.id == id).first()
            db.session.delete(tour)
            db.session.commit()

            flash('Tour successfully deleted.')
            return redirect(url_for('show_tours'))

    flash_errors(delete_tour_form)
    return render_template('delete_tour.html', form=delete_tour_form)

# Flash errors from the form if validation fails


def flash_errors(form):
    for field, errors in form.errors.items():
        for error in errors:
            flash(u"Error in the %s field - %s" % (
                getattr(form, field).label.text,
                error
            ))


@app.after_request
def add_header(response):
    """
    Add headers to both force latest IE rendering engine or Chrome Frame,
    and also to cache the rendered page for 10 minutes.
    """
    response.headers['X-UA-Compatible'] = 'IE=Edge,chrome=1'
    response.headers['Cache-Control'] = 'public, max-age=600'
    return response


@app.errorhandler(404)
def page_not_found(error):
    """Custom 404 page."""
    return render_template('404.html'), 404
