import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qhawtak/core/network/api_exception.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/features/menu/presentation/menu_management_screen.dart';
import 'package:qhawtak/features/notifications/presentation/notifications_screen.dart';
import 'package:qhawtak/features/orders/presentation/orders_dashboard_screen.dart';
import 'package:qhawtak/features/stats/presentation/sales_stats_screen.dart';
import 'package:qhawtak/shared/models/admin_notification.dart';
import 'package:qhawtak/shared/models/coffee.dart';
import 'package:qhawtak/shared/models/order.dart';
import 'package:qhawtak/shared/services/cafe_api_service.dart';
import 'package:qhawtak/shared/widgets/empty_state.dart';

class AdminHomeShell extends StatefulWidget {
  const AdminHomeShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<AdminHomeShell> createState() => _AdminHomeShellState();
}

class _AdminHomeShellState extends State<AdminHomeShell> {
  static const Duration _refreshInterval = Duration(seconds: 15);

  final CafeApiService _apiService = CafeApiService();

  int _index = 0;
  List<CoffeeOrder> _orders = <CoffeeOrder>[];
  List<CoffeeItem> _coffees = <CoffeeItem>[];
  List<AdminNotification> _notifications = <AdminNotification>[];
  bool _isInitialLoading = true;
  bool _isSyncing = false;
  String? _errorMessage;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDashboard());
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      unawaited(_loadDashboard(silent: true));
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _apiService.dispose();
    super.dispose();
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
      'Menu Management',
      'Sales Statistics',
      'Live Alerts',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: <Widget>[
          if (_index == 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Active ${_orders.where((CoffeeOrder order) => order.isActive).length}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _isSyncing ? null : () => unawaited(_loadDashboard()),
            icon: _isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (int value) => setState(() => _index = value),
              destinations: const <NavigationDestination>[
                NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Orders'),
                NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
                NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
                NavigationDestination(icon: Icon(Icons.notifications), label: 'Alerts'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Widget> pages) {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _orders.isEmpty && _coffees.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EmptyState(
                title: 'Connection issue',
                message: _errorMessage!,
                icon: Icons.wifi_off_rounded,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => unawaited(_loadDashboard()),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned(
          top: -80,
          right: -60,
          child: _blurBlob(
            size: 220,
            color: AppColors.accent.withValues(alpha: 0.2),
          ),
        ),
        Positioned(
          left: -70,
          bottom: -90,
          child: _blurBlob(
            size: 260,
            color: AppColors.secondary.withValues(alpha: 0.14),
          ),
        ),
        AnimatedSwitcher(
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
      ],
    );
  }

  Future<void> _loadDashboard({bool silent = false}) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isSyncing = true;
      if (!silent) {
        _isInitialLoading = _orders.isEmpty && _coffees.isEmpty;
        _errorMessage = null;
      }
    });

    try {
      final List<Object> result = await Future.wait<Object>(<Future<Object>>[
        _apiService.fetchOrders(),
        _apiService.fetchMenu(includeUnavailable: true),
      ]);

      if (!mounted) {
        return;
      }

      final List<CoffeeOrder> orders = result[0] as List<CoffeeOrder>;
      final List<CoffeeItem> coffees = result[1] as List<CoffeeItem>;

      setState(() {
        _orders = orders;
        _coffees = coffees;
        _notifications = _buildNotifications(orders);
        _isInitialLoading = false;
        _isSyncing = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      final String message = _friendlyError(error);
      setState(() {
        _isInitialLoading = false;
        _isSyncing = false;
        _errorMessage = message;
      });

      if (!silent) {
        _showSnackBar(message);
      }
    }
  }

  Future<void> _advanceOrderStatus(CoffeeOrder order) async {
    final OrderStatus? next = order.status.nextStatus;
    if (next == null) {
      return;
    }

    await _performMutation(
      action: () => _apiService.updateOrderStatus(orderId: order.id, status: next),
      successMessage: 'Order ${order.id} moved to ${next.label}.',
    );
  }

  void _saveCoffee(CoffeeItem item) {
    unawaited(_saveCoffeeAsync(item));
  }

  Future<void> _saveCoffeeAsync(CoffeeItem item) async {
    final bool exists = _coffees.any((CoffeeItem coffee) => coffee.id == item.id);
    await _performMutation(
      action: () => exists ? _apiService.updateMenuItem(item) : _apiService.createMenuItem(item),
      successMessage: exists ? 'Menu item updated.' : 'Menu item added.',
    );
  }

  void _deleteCoffee(String id) {
    unawaited(
      _performMutation(
        action: () => _apiService.deleteMenuItem(id),
        successMessage: 'Menu item deleted.',
      ),
    );
  }

  void _toggleCoffeeAvailability(String id) {
    final CoffeeItem? item = _coffees.cast<CoffeeItem?>().firstWhere(
          (CoffeeItem? coffee) => coffee?.id == id,
          orElse: () => null,
        );
    if (item == null) {
      return;
    }

    unawaited(
      _performMutation(
        action: () => _apiService.updateMenuItem(
          item.copyWith(isAvailable: !item.isAvailable),
        ),
        successMessage: item.isAvailable ? 'Item marked out of stock.' : 'Item marked available.',
      ),
    );
  }

  Future<void> _performMutation({
    required Future<dynamic> Function() action,
    required String successMessage,
  }) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      await action();
      await _loadDashboard(silent: true);
      if (mounted) {
        _showSnackBar(successMessage);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSyncing = false;
      });
      _showSnackBar(_friendlyError(error));
    }
  }

  List<AdminNotification> _buildNotifications(List<CoffeeOrder> orders) {
    final List<CoffeeOrder> sorted = List<CoffeeOrder>.from(orders)
      ..sort((CoffeeOrder a, CoffeeOrder b) => b.createdAt.compareTo(a.createdAt));

    return sorted.take(10).map((CoffeeOrder order) {
      final String title = switch (order.status) {
        OrderStatus.pending => 'New Order',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.served => 'Served',
        OrderStatus.cancelled => 'Cancelled',
      };

      return AdminNotification(
        id: '${order.id}-${order.status.apiValue}',
        title: title,
        message: 'Table ${order.tableNumber}: ${order.itemSummary}',
        createdAt: order.createdAt,
        isUnread: order.status == OrderStatus.pending,
      );
    }).toList();
  }

  String _friendlyError(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Unable to sync with the cafe backend right now.';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _blurBlob({required double size, required Color color}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
