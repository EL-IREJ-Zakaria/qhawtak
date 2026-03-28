import 'dart:convert';

import 'package:qhawtak/core/config/api_config.dart';
import 'package:qhawtak/core/network/api_exception.dart';
import 'package:qhawtak/core/network/http_transport.dart';
import 'package:qhawtak/core/network/network_response.dart';
import 'package:qhawtak/shared/models/coffee.dart';
import 'package:qhawtak/shared/models/order.dart';

class CafeApiService {
  CafeApiService({HttpTransport? transport})
      : _transport = transport ?? createHttpTransport();

  final HttpTransport _transport;

  Future<List<CoffeeOrder>> fetchOrders() async {
    final dynamic data = await _request(
      path: '/orders',
      method: 'GET',
    );

    if (data is! List) {
      throw const ApiException('Unexpected orders response.');
    }

    return data
        .whereType<Map>()
        .map((Map item) => CoffeeOrder.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<CoffeeItem>> fetchMenu({bool includeUnavailable = false}) async {
    final dynamic data = await _request(
      path: '/menu',
      method: 'GET',
      queryParameters: <String, String>{
        if (includeUnavailable) 'include_unavailable': 'true',
      },
    );

    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected menu response.');
    }

    final List<dynamic> rawItems = data['flat_items'] as List<dynamic>? ?? <dynamic>[];

    return rawItems
        .whereType<Map>()
        .map(
          (Map item) => CoffeeItem.fromJson(
            Map<String, dynamic>.from(item),
            apiRootUrl: ApiConfig.rootUrl,
          ),
        )
        .toList();
  }

  Future<CoffeeOrder> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final dynamic data = await _request(
      path: '/order/$orderId/status',
      method: 'PUT',
      body: <String, dynamic>{'status': status.apiValue},
    );

    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected order update response.');
    }

    return CoffeeOrder.fromJson(data);
  }

  Future<CoffeeItem> createMenuItem(CoffeeItem item) async {
    final dynamic data = await _request(
      path: '/menu',
      method: 'POST',
      body: item.toApiPayload(),
    );

    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected menu creation response.');
    }

    return CoffeeItem.fromJson(data, apiRootUrl: ApiConfig.rootUrl);
  }

  Future<CoffeeItem> updateMenuItem(CoffeeItem item) async {
    final dynamic data = await _request(
      path: '/menu/${item.id}',
      method: 'PUT',
      body: item.toApiPayload(),
    );

    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected menu update response.');
    }

    return CoffeeItem.fromJson(data, apiRootUrl: ApiConfig.rootUrl);
  }

  Future<void> deleteMenuItem(String id) async {
    await _request(
      path: '/menu/$id',
      method: 'DELETE',
    );
  }

  void dispose() {
    _transport.close();
  }

  Future<dynamic> _request({
    required String path,
    required String method,
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, dynamic>? body,
  }) async {
    final Uri uri = Uri.parse(ApiConfig.apiBaseUrl).replace(
      path: '${Uri.parse(ApiConfig.apiBaseUrl).path}$path',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final NetworkResponse response = await _transport.send(
      method: method,
      uri: uri,
      headers: const <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: body == null ? null : jsonEncode(body),
    );

    final dynamic decoded = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(
        'Invalid response from server.',
        statusCode: response.statusCode,
      );
    }

    final bool success = decoded['success'] == true;
    if (!success || response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        (decoded['message'] ?? 'Request failed.').toString(),
        statusCode: response.statusCode,
        errors: Map<String, dynamic>.from(decoded['errors'] as Map? ?? const <String, dynamic>{}),
      );
    }

    return decoded['data'];
  }
}
