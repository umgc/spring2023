from virotour.tests.common_utils import parse_http_response


def test_get_sitemap(client):
    for item in sorted(parse_http_response(client.get(f'/api/site-map')).items()):
        request_type = "/".join(item[1])
        request_path = item[0]
        print(f"{request_type} {request_path}")
