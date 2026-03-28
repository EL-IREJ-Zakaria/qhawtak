class NetworkResponse {
  const NetworkResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;
}
