from flask import url_for

from app import app


@app.after_request
def add_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

@app.route("/api/site-map")
def site_map():
    links = []
    for rule in app.url_map.iter_rules():
        links.append(str(rule))
    return links
