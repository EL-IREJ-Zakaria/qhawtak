import 'dart:convert';
import 'dart:io';

import 'http_transport.dart';
import 'network_response.dart';

HttpTransport createPlatformHttpTransport() => _IoHttpTransport();

class _IoHttpTransport implements HttpTransport {
  final HttpClient _client = HttpClient();

  @override
  Future<NetworkResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final HttpClientRequest request = await _client.openUrl(method, uri);
    headers.forEach(request.headers.set);

    if (body != null) {
      request.write(body);
    }

    final HttpClientResponse response = await request.close();
    final String responseBody = await response.transform(utf8.decoder).join();

    return NetworkResponse(
      statusCode: response.statusCode,
      body: responseBody,
    );
  }

  @override
  void close() {
    _client.close(force: false);
  }
}
