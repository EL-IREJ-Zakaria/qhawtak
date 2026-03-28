class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.errors = const <String, dynamic>{}});

  final String message;
  final int? statusCode;
  final Map<String, dynamic> errors;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
