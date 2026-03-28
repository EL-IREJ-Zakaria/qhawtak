// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'http_transport.dart';
import 'network_response.dart';

HttpTransport createPlatformHttpTransport() => _WebHttpTransport();

class _WebHttpTransport implements HttpTransport {
  @override
  Future<NetworkResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final html.HttpRequest response = await html.HttpRequest.request(
      uri.toString(),
      method: method,
      requestHeaders: headers,
      sendData: body,
    );

    return NetworkResponse(
      statusCode: response.status ?? 0,
      body: response.responseText ?? '',
    );
  }

  @override
  void close() {}
}
