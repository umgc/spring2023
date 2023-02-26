# Setup
## Install Python 3.11.2 (or latest)

See: https://www.python.org/downloads/release/python-3112/

## Create Virtual Environment

```
# Change to this directory
cd flask

# Create virtual environment called 'venv'
python -m venv venv
```

## Activate Virtual Environment

Linux
```
source venv/bin/activate
```

Windows
```
venv\Scripts\activate
```

Note, if you get "cannot be loaded because its operation is blocked by software restriction       
policies, such as those created by using Group Policy."

Then run ```Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process``` and try again

## Install flask and dependencies

```
pip install -r requirements.txt
```

## Run Tests

To run all tests
```
pytest app/tests/
```

To run just one test class
```
pytest app/tests/tour/tour_update_test.py
```

## Run Server

```
python run.py
```

To run integration tests. This will populate test data.
```
pytest app/integration_tests
```

Navigate to `api/site-map` to access the REST APIs.

See [app\apis.py](vsp/apis.py) for complete supported REST APIs operation.

Example of REST API endpoints:

```
/api/                  -- [GET] hello world
/api/tours             -- [GET] get list of tours
/api/tour/<id>         -- [GET] get tour by id
/api/tour-name/<name>  -- [GET] get tour by name
/api/tour/add          -- [POST] add new tour with JSON data payload:
/api/update/tour/<id>  -- [POST/PUT] update tour by id with JSON data payload
/api/delete/tour/<id>  -- [POST/DELETE] delete tour by id
/api/tour/add/images/  -- [POST] upload images to server
/api/tour/images/<string:tour_name>/<int:location_id>  -- [GET] Retrieve raw image paths for a given tour name and location_id
```