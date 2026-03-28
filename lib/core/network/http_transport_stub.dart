import 'http_transport.dart';
import 'network_response.dart';

HttpTransport createPlatformHttpTransport() => _UnsupportedHttpTransport();

class _UnsupportedHttpTransport implements HttpTransport {
  @override
  Future<NetworkResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) {
    throw UnsupportedError('No HTTP transport available for this platform.');
  }

  @override
  void close() {}
}
