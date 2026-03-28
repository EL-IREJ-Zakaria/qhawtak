import 'network_response.dart';
import 'http_transport_stub.dart'
    if (dart.library.io) 'http_transport_io.dart'
    if (dart.library.html) 'http_transport_web.dart';

abstract class HttpTransport {
  Future<NetworkResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers,
    String? body,
  });

  void close();
}

HttpTransport createHttpTransport() => createPlatformHttpTransport();
