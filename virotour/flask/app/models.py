from datetime import datetime
from app import db
# from db.database import Base

# common fields for all entities
class AppBaseModelOrm(db.Model):
    __abstract__ = True
    
    id = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    is_active = db.Column(db.Boolean, default=True)  # soft delete
    created_by = db.Column(db.Integer)
    updated_by = db.Column(db.Integer, default=None)
    created_at = db.Column(db.DateTime(timezone=True), default = datetime.utcnow)
    updated_at = db.Column(db.DateTime(timezone=True), \
                       default=None, onupdate = datetime.utcnow)


class Tour(AppBaseModelOrm):
    __tablename__ = "tour_table_v1"

    # id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.String(255))
    # created_at = db.Column(
    #     db.TIMESTAMP(timezone=True), nullable=False, server_default=db.text("now()")
    # )


    def __init__(self, name, description, is_active = True, created_by = None, created_at= None, updated_by = None, updated_at= None):
        self.name = name
        self.description = description
        self.is_active = is_active
        self.created_at = created_at
        self.created_by = created_by
        self.updated_by = updated_by
        self.updated_at = updated_at

    def __repr__(self):
        return f"<Tour {self.name}>"


class Images(AppBaseModelOrm):
    __tablename__ = "images_table_v1"

    # image_id = db.Column(db.Integer, primary_key=True, nullable=False)
    location_id = db.Column(
        db.Integer,
        db.ForeignKey("locations_table_v1.id", ondelete="CASCADE"),
        nullable=False,
    )
    state_id = db.Column(
        db.Integer, 
        db.ForeignKey("state_table_v1.id", ondelete="CASCADE")
    )
    original = db.Column(db.PickleType)
    panoramic = db.Column(db.String(255))
    blurred = db.Column(db.String(255))

    def __init__(self, location_id, state_id, original, panoramic, blurred):
        self.location_id = location_id
        self.state_id = state_id
        self.original = original
        self.panoramic = panoramic
        self.blurred = blurred

    def __repr__(self):
        return f"<Images {self.panoramic}>"


class Locations(AppBaseModelOrm):
    __tablename__ = "locations_table_v1"

    # location_id = db.Column(db.Integer, primary_key=True)
    position_x = db.Column(db.Integer)
    position_y = db.Column(db.Integer)
    position_z = db.Column(db.Integer)
    image_id = db.Column(db.Integer, nullable=False)
    transitional_hotshots_ids = db.Column(db.PickleType)
    informational_hotshots_ids = db.Column(db.PickleType)
    text_ids = db.Column(db.String(255))

    def __init__(
        self,
        position_x,
        position_y,
        position_z,
        image_id,
        transitional_hotshots_ids,
        informational_hotshots_ids,
        text_ids,
    ):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.image_id = image_id
        self.transitional_hotshots_ids = transitional_hotshots_ids
        self.informational_hotshots_ids = informational_hotshots_ids
        self.text_ids = text_ids

    def __repr__(self):
        return f"<Locations: {self.transitional_hotshots_ids}>"


class State(AppBaseModelOrm):
    __tablename__ = "state_table_v1"

    # state_id = db.Column(db.Integer, primary_key=True, nullable=False)
    setting = db.Column(db.String(8000), nullable=False)
    filter_id = db.Column(
        db.Integer,
        db.ForeignKey("filter_table_v1.id", ondelete="CASCADE"),
        nullable=False,
    )

    def __init__(self, state_id, setting, filter):
        self.state_id = state_id
        self.setting = setting
        self.filter = filter

    def __repr__(self):
        return f"<State  {self.setting}>"


class Filters(AppBaseModelOrm):
    __tablename__ = "filter_table_v1"

    # filter_id = db.Column(db.Integer, primary_key=True, nullable=False)
    type = db.Column(db.String(255), nullable=False)
    settings = db.Column(db.String(8000), nullable=False)

    def __init__(self, type, settings):
        self.type = type
        self.settings = settings

    def __repr__(self):
        return f"<Filters: {self.settings}>"


class Informational_Hotshots(AppBaseModelOrm):
    __tablename__ = "informational_Hotshots_table_v1"

    # informational_id = db.Column(db.Integer, primary_key=True, nullable=False)
    position_x = db.Column(db.Integer, nullable=False)
    position_y = db.Column(db.Integer, nullable=False)
    position_z = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String(8000))

    def __init__(self, position_x, position_y, position_z, content):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.content = content

    def __repr__(self):
        return f"<Informational_Hotshots: {self.content}>"


class Transitional_Hotshots(AppBaseModelOrm):
    __tablename__ = "transitional_Hotshots_table_v1"

    # transitional_id = db.Column(db.Integer, primary_key=True)
    position_x = db.Column(db.Integer, nullable=False)
    position_y = db.Column(db.Integer, nullable=False)
    position_z = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String(8000))

    def __init__(self, position_x, position_y, position_z, content):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.content = content

    def __repr__(self):
        return f"<Transitional_Hotshots: {self.content}>"


class Text(AppBaseModelOrm):
    __tablename__ = "text_table_v1"

    # text_id = db.Column(db.Integer, primary_key=True, nullable=False)
    position_x = db.Column(db.Integer, nullable=False)
    position_y = db.Column(db.Integer, nullable=False)
    position_z = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String(8000))

    def __init__(self, position_x, position_y, position_z, content):
        self.position_x = position_x
        self.position_y = position_y
        self.position_z = position_z
        self.content = content

    def __repr__(self):
        return f"<Text: {self.content}>"
