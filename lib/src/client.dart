import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth/oauth.dart' as oauth;

/// A http Client extends [oauth.client]
class Client extends oauth.Client {
  /// Constructs a new Client with [oauth.Tokens]
  Client(oauth.Tokens tokens) : super(tokens);

  /// Send an HTTP request and Return [http.Response] with the given headers and body to the given
  /// URL, which can be a [Uri] or a [String] and [method].
  Future<http.Response> request(String method, url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    if (url is String) url = Uri.parse(url);

    print('Twitter Url: ${url.toString()}');
    var request = new http.Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body;
      } else if (body is Map) {
        request.bodyFields = body;
      } else {
        throw new ArgumentError('Invalid request body "$body".');
      }
    }

    var response = await super.send(request);
    return http.Response.fromStream(response);
  }

  /// Close Internal Client
  @override
  void close() {
    client.close();
  }
}
