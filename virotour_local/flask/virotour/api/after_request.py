from virotour import app


@app.after_request
def add_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

@app.route("/api/site-map")
def site_map():
    links = {}
    for rule in app.url_map.iter_rules():
        methods = [str(x) for x in rule.methods if (str(x) != 'OPTIONS' and str(x) != 'HEAD')]
        links[str(rule)] = methods
    return links
