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
    
    
class Images(db.Model):
    __tablename__ = 'images_table_v1'

    image_id = db.Column(db.String, primary_key=True)
    location_id = db.Column(db.Integer, db.ForeignKey('location_id'), nullable=False)
    state_id = db.Column(db.String(255), db.ForeignKey('state_id'))
    original = db.Column(db.String(255))
    panoramic = db.Column(db.String(255))
    blurred = db.Column(db.String(255))
    
    def __init__(self, location_id, state_id, original, panoramic, blurred):
        self.location_id = location_id
        self.state_id = state_id
        self.original = original
        self.panoramic = panoramic
        self.blurred = blurred

    def __repr__(self):
        return '<Images %r>' % self.panoramic
    
class Locations(db.Model):
    __tablename__ = 'locations_table_v1'

    location_id = db.Column(db.String, primary_key=True)
    position_x = db.Column(db.Integer)
    position_y = db.Column(db.Integer)
    position_z = db.Column(db.Integer)
    image_id = db.Column(db.String(255), nullable=False)
    transitional_hotshots_ids = db.Column(db.String(255))
    informational_hotshots_ids  = db.Column(db.String(255))
    text_ids = db.Column(db.String(255))
    
    def __init__(self, position_x, position_y, position_z, image_id, transitional_hotshots_ids, informational_hotshots_ids, text_ids):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.image_id = image_id
        self.transitional_hotshots_ids = transitional_hotshots_ids
        self.informational_hotshots_ids = informational_hotshots_ids
        self.text_ids = text_ids

    def __repr__(self):
        return '<Locations %r>' % self.transitional_hotshots_ids
    
class State(db.Model):
    __tablename__ = 'state_table_v1'
    
    state_id = db.Column(db.String, primary_key=True)
    setting = db.Column(db.String(255), nullable=False)
    filter = db.Column(db.String(255))
    
    def __init__(self, state_id, setting, filter):
        self.state_id = state_id
        self.setting = setting
        self.filter = filter

    def __repr__(self):
        return '<State %r>' % self.setting
