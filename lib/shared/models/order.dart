enum OrderStatus { newOrder, accepted, preparing, ready, completed, cancelled }

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
