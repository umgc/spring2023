from app.tests.common_utils import parse_http_response


def test_get_sitemap(client):
    print(parse_http_response(client.get(f'/api/site-map')))