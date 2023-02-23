from flask_wtf import FlaskForm
from wtforms import StringField
from wtforms.validators import InputRequired


class TourForm(FlaskForm):
    name = StringField('Name', validators=[InputRequired()])
    description = StringField('Description', validators=[InputRequired()])

class UpdateTourForm(FlaskForm):
    id = StringField('ID', validators=[InputRequired()])
    name = StringField('Name', validators=[InputRequired()])

class DeleteTourForm(FlaskForm):
    id = StringField('ID', validators=[InputRequired()])