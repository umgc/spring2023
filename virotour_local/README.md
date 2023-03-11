# ViroTour Local Setup

This folder is used for local testing. We use a Flask server to mock the API endpoints.

## Table of Contents
1. [Setup for Windows](#setup-for-windows)
1. [Setup for MacOS](#setup-for-macos)

## Setup for Windows

### Install Python 3.11.2 (or latest)

See: https://www.python.org/downloads/release/python-3112/

### Create Virtual Environment

```
# Change to this directory
cd flask

# Create virtual environment called 'venv'
python -m venv venv
```

### Activate Virtual Environment

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

### Install flask and dependencies

```
pip install -r requirements.txt
```

Note# If you get "Python Was Not Found" try steps found here https://www.youtube.com/watch?v=uBnbVqUmZaQ

### Run

```
python run.py
```

Navigate to `http://localhost:8081/` to access the Web App frontend and `http://localhost:8081/api/*` to access the REST APIs.

See [app\apis.py](vsp/apis.py) for complete supported REST APIs operation.

Example of REST API endpoints:

```
http://localhost:8081/api/                  -- [GET] hello world
http://localhost:8081/api/tours             -- [GET] get list of tours
http://localhost:8081/api/tour/<id>         -- [GET] get tour by id
http://localhost:8081/api/add/tour          -- [POST] add new tour with JSON data payload:
http://localhost:8081/api/update/tour/<id>  -- [POST/PUT] update tour by id with JSON data payload
http://localhost:8081/api/delete/tour/<id>  -- [POST/DELETE] delete tour by id
http://localhost:8081/api/add/tour/images/  -- [POST] upload images to server

```

## Setup for MacOS

In this folder (virotour_local) run:
```
. ./helpers/setup_macos.sh
```
Go to the flask folder:
```
cd ./flask
```
Install dependencies:
```
pip install -r requirements.txt
```
Start the Flask server:
```
python run.py
```
If you want to run all tests, do:
```
python -m pytest app/tests 
```