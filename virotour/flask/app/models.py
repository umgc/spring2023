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
