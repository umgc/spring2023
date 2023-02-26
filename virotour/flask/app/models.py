from app import db


class Tour(db.Model):
    __tablename__ = 'tour_table_v1'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    description = db.Column(db.String(255))

    def __init__(self, name, description):
        self.name = name
        self.description = description

    def __repr__(self):
        return '<Tour %r>' % self.name

class Location(db.Model):
    __tablename__ = 'locations_table_v1'

    location_id = db.Column(db.Integer, primary_key=True)
    tour_id = db.Column(db.Integer)   
    
    def __init__(self, tour_id):
        self.tour_id = tour_id

    def __repr__(self):
        return '<Locations %r>' % self.location_id
    
class Image(db.Model):
    __tablename__ = 'images_table_v1'

    image_id = db.Column(db.Integer, primary_key=True)
    location_id = db.Column(db.Integer)
    file_path = db.Column(db.String(255))
    
    def __init__(self, location_id, file_path):
        self.location_id = location_id
        self.file_path = file_path


    def __repr__(self):
        return '<Images %r>' % self.image_id
    