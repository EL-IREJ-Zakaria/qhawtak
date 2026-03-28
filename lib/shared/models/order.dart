enum OrderStatus { pending, preparing, served, cancelled }

extension OrderStatusX on OrderStatus {
  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.served:
        return 'served';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  OrderStatus? get nextStatus {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.served;
      case OrderStatus.served:
      case OrderStatus.cancelled:
        return null;
    }
  }

  String? get nextActionLabel {
    switch (this) {
      case OrderStatus.pending:
        return 'Start Preparing';
      case OrderStatus.preparing:
        return 'Mark Served';
      case OrderStatus.served:
      case OrderStatus.cancelled:
        return null;
    }
  }

  bool get isActive => this == OrderStatus.pending || this == OrderStatus.preparing;

  static OrderStatus fromApi(String value) {
    switch (value.toLowerCase().trim()) {
      case 'pending':
        return OrderStatus.pending;
      case 'preparing':
        return OrderStatus.preparing;
      case 'served':
        return OrderStatus.served;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

class OrderLineItem {
  const OrderLineItem({
    required this.coffeeName,
    required this.quantity,
    required this.unitPrice,
  });

  final String coffeeName;
  final int quantity;
  final double unitPrice;

  double get lineTotal => quantity * unitPrice;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      coffeeName: (json['item_name'] ?? json['coffeeName'] ?? json['name'] ?? '').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CoffeeOrder {
  const CoffeeOrder({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  final String id;
  final int tableNumber;
  final List<OrderLineItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final String? notes;

  double get total => items.fold(0, (sum, item) => sum + item.lineTotal);

  int get quantity => items.fold(0, (sum, item) => sum + item.quantity);

  String get itemSummary => items.map((OrderLineItem item) => item.coffeeName).join(', ');

  bool get isActive => status.isActive;

  factory CoffeeOrder.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[]);
    return CoffeeOrder(
      id: (json['id'] ?? '').toString(),
      tableNumber: (json['table_number'] as num?)?.toInt() ?? 0,
      items: rawItems
          .whereType<Map>()
          .map((Map item) => OrderLineItem.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      status: OrderStatusX.fromApi((json['status'] ?? '').toString()),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ?? DateTime.now(),
      notes: (json['notes'] as String?)?.trim().isEmpty ?? true ? null : json['notes'] as String?,
    );
  }

  CoffeeOrder copyWith({
    String? id,
    int? tableNumber,
    List<OrderLineItem>? items,
    OrderStatus? status,
    DateTime? createdAt,
    String? notes,
  }) {
    return CoffeeOrder(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      items: items ?? this.items,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
