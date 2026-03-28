import 'package:flutter/foundation.dart';

abstract final class ApiConfig {
  static const String _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _sanitize(_apiBaseUrlOverride);
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://127.0.0.1:8000/api';
      case TargetPlatform.fuchsia:
        return 'http://127.0.0.1:8000/api';
    }
  }

  static String get rootUrl => Uri.parse(apiBaseUrl).resolve('/').toString();

  static String _sanitize(String value) => value.replaceFirst(RegExp(r'/$'), '');
}
