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

## Install flask and dependencies

```
pip install -r requirements.txt
```

## Run

```
$ pip install -r requirements.txt
$ python run.py
```

Navigate to `http://localhost:5000/` to access the Web App frontend and `http://localhost:5000/api/*` to access the REST APIs.

See [app\apis.py](app/apis.py) for complete supported REST APIs operation.

Example of REST API endpoints:

```
http://localhost:5000/api/ -- hello world
http://localhost:5000/api/tours  -- get list of tours
http://localhost:5000/api/tour/<id>  -- get tour by id
http://localhost:5000/api/add/tour  -- add new tour with JSON data payload:
http://localhost:5000/api/update/tour/<id>  -- update tour by id with JSON data payload
http://localhost:5000/api/delete/tour/<id>  -- delete tour by id
```