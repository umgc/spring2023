from app import db


class Tour(db.Model):
    __tablename__ = 'tour_table'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))

    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return '<Tour %r>' % self.name
