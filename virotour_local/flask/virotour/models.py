import enum
from enum import Enum

from virotour import db


class Tour(db.Model):
    __tablename__ = 'tour_table_v1'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    description = db.Column(db.String(255))

    def __init__(self, name=None, description=None):
        self.name = name
        self.description = description

    def __repr__(self):
        return '<Tour %r>' % self.name


class Location(db.Model):
    __tablename__ = 'locations_table_v1'

    location_id = db.Column(db.Integer, primary_key=True)
    tour_id = db.Column(db.Integer)
    pano_file_path = db.Column(db.String(255))
    neighbors = db.Column(db.PickleType)
    state = db.Column(db.String(255))
    filter_id = db.Column(db.Integer)

    def __init__(self, tour_id=None, pano_file_path=None, neighbors=None, state=None, filter_id=None):
        if neighbors is None:
            neighbors = []
        self.tour_id = tour_id
        self.pano_file_path = pano_file_path
        self.neighbors = neighbors
        self.state = state
        self.filter_id = filter_id

    def __repr__(self):
        return '<Locations %r>' % self.location_id


class Image(db.Model):
    __tablename__ = 'images_table_v1'

    image_id = db.Column(db.Integer, primary_key=True)
    tour_id = db.Column(db.Integer)
    location_id = db.Column(db.Integer)
    file_path = db.Column(db.String(255))

    def __init__(self, tour_id=None, location_id=None, file_path=None):
        self.tour_id = tour_id
        self.location_id = location_id
        self.file_path = file_path

    def __repr__(self):
        return '<Images %r>' % self.image_id


class Text(db.Model):
    __tablename__ = 'extracted_text_table_v1'

    text_id = db.Column(db.Integer, primary_key=True)
    tour_id = db.Column(db.Integer)
    location_id = db.Column(db.Integer)
    text_content = db.Column(db.String(8000))
    position_x = db.Column(db.Integer)
    position_y = db.Column(db.Integer)
    position_z = db.Column(db.Integer)

    def __init__(self, tour_id, location_id=None, text_content=None, position_x=None, position_y=None, position_z=None):
        self.tour_id = tour_id
        self.location_id = location_id
        self.text_content = text_content
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z

    def __repr__(self):
        return '<Text %r>' % self.text_id


class Filter(db.Model):
    __tablename__ = 'filter_table_v1'

    filter_id = db.Column(db.Integer, primary_key=True)
    filter_name = db.Column(db.String(255))
    setting = db.Column(db.Integer)

    def __init__(self, setting=None):
        self.setting = setting

    def __repr__(self):
        return '<States %r>' % self.filter_id
