import json


def parse_http_response(resp):
    try:
        print(str(resp))
        return json.loads(resp.data.decode())
    except:
        raise Exception(resp.data)