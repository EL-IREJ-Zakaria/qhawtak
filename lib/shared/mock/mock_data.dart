import 'package:qhawtak/shared/models/admin_notification.dart';
import 'package:qhawtak/shared/models/coffee.dart';
import 'package:qhawtak/shared/models/order.dart';

class MockData {
  static List<CoffeeOrder> orders() {
    final DateTime now = DateTime.now();
    return <CoffeeOrder>[
      CoffeeOrder(
        id: 'QH-1001',
        tableNumber: 7,
        items: const [OrderLineItem(coffeeName: 'Cappuccino', quantity: 2, unitPrice: 3.5)],
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      CoffeeOrder(
        id: 'QH-1002',
        tableNumber: 3,
        items: const [OrderLineItem(coffeeName: 'Espresso', quantity: 1, unitPrice: 2.2)],
        status: OrderStatus.preparing,
        createdAt: now.subtract(const Duration(minutes: 7)),
        notes: 'No sugar',
      ),
      CoffeeOrder(
        id: 'QH-1003',
        tableNumber: 11,
        items: const [OrderLineItem(coffeeName: 'Latte', quantity: 2, unitPrice: 3.8)],
        status: OrderStatus.preparing,
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      CoffeeOrder(
        id: 'QH-1004',
        tableNumber: 1,
        items: const [OrderLineItem(coffeeName: 'Cold Coffee', quantity: 1, unitPrice: 4.0)],
        status: OrderStatus.served,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      CoffeeOrder(
        id: 'QH-1005',
        tableNumber: 9,
        items: const [OrderLineItem(coffeeName: 'Espresso', quantity: 3, unitPrice: 2.2)],
        status: OrderStatus.served,
        createdAt: now.subtract(const Duration(minutes: 24)),
      ),
    ];
  }

  static List<CoffeeItem> coffees() {
    return const <CoffeeItem>[
      CoffeeItem(
        id: 'c1',
        name: 'Espresso',
        description: 'Bold and rich single shot.',
        price: 2.20,
        category: 'Coffee',
        imageUrl: 'https://images.unsplash.com/photo-1510707577719-ae7c14805e8c',
      ),
      CoffeeItem(
        id: 'c2',
        name: 'Latte',
        description: 'Silky steamed milk and espresso.',
        price: 3.80,
        category: 'Coffee',
        imageUrl: 'https://images.unsplash.com/photo-1494314671902-399b18174975',
      ),
      CoffeeItem(
        id: 'c3',
        name: 'Cappuccino',
        description: 'Espresso with milk foam balance.',
        price: 3.50,
        category: 'Coffee',
        imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d',
      ),
      CoffeeItem(
        id: 'c4',
        name: 'Cold Coffee',
        description: 'Chilled coffee with smooth sweetness.',
        price: 4.00,
        category: 'Cold Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735',
      ),
    ];
  }

  static List<AdminNotification> notifications() {
    final DateTime now = DateTime.now();
    return <AdminNotification>[
      AdminNotification(
        id: 'n1',
        title: 'New Order',
        message: 'Table 7 ordered 2 Cappuccino.',
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      AdminNotification(
        id: 'n2',
        title: 'Order Cancelled',
        message: 'Table 4 cancelled an Espresso order.',
        createdAt: now.subtract(const Duration(minutes: 19)),
      ),
      AdminNotification(
        id: 'n3',
        title: 'Connectivity',
        message: 'Realtime sync recovered successfully.',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 12)),
        isUnread: false,
      ),
    ];
  }
}
