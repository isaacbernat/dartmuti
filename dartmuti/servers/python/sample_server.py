from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import json


class S(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

    def do_POST(self):
        self._set_headers()
        data = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
        self.wfile.write(json.dumps(action_response(data["state"])))
        self.wfile.close()
        return


def action_response(state):
    if state["you"]["position"] != state["general"]["current_player"]:
        return {}  # not your turn
    return {"action": "play", "card_positions": [0]}


def run(port, server_class=HTTPServer, handler_class=S):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print 'Starting httpd...'
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv

    PORT = (len(argv) == 2 and int(argv[1])) or 8081
    run(PORT)
