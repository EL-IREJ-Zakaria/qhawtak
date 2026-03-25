import 'package:flutter/material.dart';
import 'package:qhawtak/features/menu/presentation/menu_management_screen.dart';
import 'package:qhawtak/features/notifications/presentation/notifications_screen.dart';
import 'package:qhawtak/features/orders/presentation/orders_dashboard_screen.dart';
import 'package:qhawtak/features/stats/presentation/sales_stats_screen.dart';
import 'package:qhawtak/shared/mock/mock_data.dart';
import 'package:qhawtak/shared/models/admin_notification.dart';
import 'package:qhawtak/shared/models/coffee.dart';
import 'package:qhawtak/shared/models/order.dart';

class AdminHomeShell extends StatefulWidget {
  const AdminHomeShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<AdminHomeShell> createState() => _AdminHomeShellState();
}

class _AdminHomeShellState extends State<AdminHomeShell> {
  int _index = 0;
  late List<CoffeeOrder> _orders;
  late List<CoffeeItem> _coffees;
  late List<AdminNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _orders = MockData.orders();
    _coffees = MockData.coffees();
    _notifications = MockData.notifications();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      OrdersDashboardScreen(
        orders: _orders,
        onAdvanceStatus: _advanceOrderStatus,
      ),
      MenuManagementScreen(
        coffees: _coffees,
        onSaveCoffee: _saveCoffee,
        onDeleteCoffee: _deleteCoffee,
        onToggleAvailability: _toggleCoffeeAvailability,
      ),
      SalesStatsScreen(orders: _orders),
      NotificationsScreen(notifications: _notifications),
    ];

    final List<String> titles = <String>[
      'Live Orders',
      'Coffee Menu',
      'Sales Statistics',
      'Notifications',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: <Widget>[
          if (_index == 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  'Active: ${_orders.where((o) => o.status != OrderStatus.completed).length}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Logout',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final Animation<Offset> offset = Tween<Offset>(
            begin: const Offset(0.02, 0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_index),
          child: pages[_index],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int value) => setState(() => _index = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.local_cafe), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'Alerts'),
        ],
      ),
    );
  }

  void _advanceOrderStatus(CoffeeOrder order) {
    final OrderStatus? next = switch (order.status) {
      OrderStatus.newOrder => OrderStatus.accepted,
      OrderStatus.accepted => OrderStatus.preparing,
      OrderStatus.preparing => OrderStatus.ready,
      OrderStatus.ready => OrderStatus.completed,
      OrderStatus.completed || OrderStatus.cancelled => null,
    };
    if (next == null) return;

    setState(() {
      _orders = _orders
          .map((CoffeeOrder o) => o.id == order.id ? o.copyWith(status: next) : o)
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} moved to ${_statusLabel(next)}')),
    );
  }

  void _saveCoffee(CoffeeItem item) {
    final int existing = _coffees.indexWhere((CoffeeItem c) => c.id == item.id);
    setState(() {
      if (existing >= 0) {
        _coffees[existing] = item;
      } else {
        _coffees = <CoffeeItem>[item, ..._coffees];
      }
    });
  }

  void _deleteCoffee(String id) {
    setState(() {
      _coffees = _coffees.where((CoffeeItem c) => c.id != id).toList();
    });
  }

  void _toggleCoffeeAvailability(String id) {
    setState(() {
      _coffees = _coffees
          .map((CoffeeItem c) => c.id == id ? c.copyWith(isAvailable: !c.isAvailable) : c)
          .toList();
    });
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return 'New';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
