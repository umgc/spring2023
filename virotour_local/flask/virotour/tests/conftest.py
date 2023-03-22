import pytest

from virotour import app, db


@pytest.fixture
def my_app():
    with app.app_context():
        db.create_all()
        yield app   # Note that we changed return for yield, see below for why
        db.session.remove()
        db.drop_all()
    return app

@pytest.fixture
def client(my_app):
    client = my_app.test_client()
    yield client
