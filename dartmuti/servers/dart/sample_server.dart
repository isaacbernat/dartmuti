import 'dart:io';
import 'dart:convert';

final HOST = "127.0.0.1"; // eg: localhost
final PORT = 8081;

Map state = {};

void main() {
  HttpServer.bind(HOST, PORT).then((server) {
    server.listen((HttpRequest request) {
      HttpResponse res = request.response;
      addCorsHeaders(res);
      res.statusCode = HttpStatus.OK;
      switch (request.method) {
        case "POST":
          handlePost(request, res);
          break;
        default:
          defaultHandler(request, res);
      }
    }, onError: printError);
    print("Listening on http://$HOST:$PORT");
  }, onError: printError);
}

void handlePost(HttpRequest req, HttpResponse res) {
  Future<String> content = UTF8.decodeStream(req).then((data) {
    state = JSON.decode(data)["init_state"];
  });
  res.close();
}

void defaultHandler(HttpRequest req, HttpResponse res) {
  res.statusCode = HttpStatus.NOT_FOUND;
  res.addString("Not found: ${req.method}, ${req.uri.path}");
  res.close();
}

void printError(error) => print(error);

/**
 * Add Cross-site headers to enable accessing this server from pages
 * not served by this server
 *
 * See: http://www.html5rocks.com/en/tutorials/cors/
 * and http://enable-cors.org/server.html
 * and https://www.dartlang.org/articles/json-web-service/#a-note-on-cors-and-httprequest
 */
void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers",
      "Origin, X-Requested-With, Content-Type, Accept");
}
