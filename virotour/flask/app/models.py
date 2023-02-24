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
    location_id = db.Column(db.Integer, db.ForeignKey('locations_table_v1.location_id'), nullable=False)
    state_id = db.Column(db.String(255), db.ForeignKey('state_table_v1.state_id'))
    original = db.Column(db.SPickleType) 
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
    transitional_hotshots_ids = db.Column(db.SPickleType) 
    informational_hotshots_ids  = db.Column(db.SPickleType) 
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
    filter_id = db.Column(db.String(255), db.ForeignKey('filter_table_v1.filter_id'), nullable=False) 
    
    def __init__(self, state_id, setting, filter):
        self.state_id = state_id
        self.setting = setting
        self.filter = filter

    def __repr__(self):
        return '<State %r>' % self.setting
    
class Filters(db.Model):
    __tablename__ = 'filter_table_v1'
    
    filter_id = db.Column(db.String, primary_key=True)
    type = db.Column(db.String(255), nullable=False)
    settings = db.Column(db.String(max), nullable=False) 
    
    def __init__(self, type, settings):
        self.type = type
        self.settings = settings

    def __repr__(self):
        return '<Filters %r>' % self.settings
    
class Informational_Hotshots(db.Model):
    __tablename__ = 'Informational_Hotshots_table_v1'
    
    Informational_id = db.Column(db.String, primary_key=True)
    position_x = db.Column(db.Integer, nullable=False)
    position_y = db.Column(db.Integer, nullable=False)
    position_z = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String(max)) 
    
    def __init__(self, position_x, position_y, position_z, content):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.content = content

    def __repr__(self):
        return '<Informational_Hotshots %r>' % self.content
    
class Transitional_Hotshots(db.Model):
    __tablename__ = 'Transitional_Hotshots_table_v1'
    
    Transitional_id = db.Column(db.String, primary_key=True)
    position_x = db.Column(db.Integer, nullable=False)
    position_y = db.Column(db.Integer, nullable=False)
    position_z = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String(max)) 
    
    def __init__(self, position_x, position_y, position_z, content):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.content = content

    def __repr__(self):
        return '<Transitional_Hotshots %r>' % self.content
    
class Text(db.Model):
    __tablename__ = 'Text_table_v1'
    
    Text_id = db.Column(db.String, primary_key=True)
    position_x = db.Column(db.Integer, nullable=False)
    position_y = db.Column(db.Integer, nullable=False)
    position_z = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String(max)) 
    
    def __init__(self, position_x, position_y, position_z, content):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.content = content

    def __repr__(self):
        return '<Text %r>' % self.content
    
    
