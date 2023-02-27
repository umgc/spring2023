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

class Text(db.Model):
    __tablename__ = 'extracted_text_table_v1'

    text_id = db.Column(db.Integer, primary_key=True)
    location_id = db.Column(db.Integer)
    text_content = db.Column(db.String(255))
    text_xcoord = db.Column(db.Float)
    text_ycoord = db.Column(db.Float)
    text_zcoord = db.Column(db.Float)

    def __init__(self, location_id, text_content, text_xcoord, text_ycoord, text_zcoord):
        self.location_id = location_id
        self.text_content = text_content
        self.text_xcoord = text_xcoord
        self.text_ycoord = text_ycoord
        self.text_zcoord = text_zcoord

    def __repr__(self):
        return '<Text %r>' % self.text_id