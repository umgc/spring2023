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

## Run

```
python run.py
```

Navigate to `http://localhost:5000/` to access the Web App frontend and `http://localhost:5000/api/*` to access the REST APIs.

See [app\apis.py](vsp/apis.py) for complete supported REST APIs operation.

Example of REST API endpoints:

```
http://localhost:5000/api/                  -- [GET] hello world
http://localhost:5000/api/tours             -- [GET] get list of tours
http://localhost:5000/api/tour/<id>         -- [GET] get tour by id
http://localhost:5000/api/tour-name/<name>  -- [GET] get tour by name
http://localhost:5000/api/add/tour          -- [POST] add new tour with JSON data payload:
http://localhost:5000/api/update/tour/<id>  -- [POST/PUT] update tour by id with JSON data payload
http://localhost:5000/api/delete/tour/<id>  -- [POST/DELETE] delete tour by id
http://localhost:5000/api/add/tour/images/  -- [POST] upload images to server
```