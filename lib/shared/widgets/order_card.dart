import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/models/order.dart';
import 'package:qhawtak/shared/widgets/animated_network_image.dart';
import 'package:qhawtak/shared/widgets/qhawtak_button.dart';
import 'package:qhawtak/shared/widgets/status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onAdvanceStatus,
  });

  final CoffeeOrder order;
  final VoidCallback onAdvanceStatus;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int minutes = now.difference(order.createdAt).inMinutes;
    final String itemNames = order.items.map((i) => i.coffeeName).join(', ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedNetworkImage(
              imageUrl: _coffeeImage(itemNames),
              height: 120,
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Text(
                  'Table ${order.tableNumber}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: order.status),
                const Spacer(),
                Text(
                  '+$minutes min',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(itemNames, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              'Qty: ${order.quantity} | Unit: ${order.items.first.unitPrice.toStringAsFixed(2)} MAD',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: ${order.total.toStringAsFixed(2)} MAD',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Order: ${order.id} | Time: ${_formatClock(order.createdAt)}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            if (order.notes != null && order.notes!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                'Note: ${order.notes}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 12),
            if (_nextLabel(order.status) != null)
              QhawtakButton(
                label: _nextLabel(order.status)!,
                icon: Icons.local_cafe_outlined,
                onPressed: onAdvanceStatus,
              ),
          ],
        ),
      ),
    );
  }

  String? _nextLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return 'Accept Order';
      case OrderStatus.accepted:
        return 'Mark Preparing';
      case OrderStatus.preparing:
        return 'Mark Ready';
      case OrderStatus.ready:
        return 'Complete Order';
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return null;
    }
  }

  String _formatClock(DateTime date) {
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _coffeeImage(String names) {
    final String value = names.toLowerCase();
    if (value.contains('espresso')) {
      return 'https://images.unsplash.com/photo-1510707577719-ae7c14805e8c?auto=format&fit=crop&w=1200&q=80';
    }
    if (value.contains('latte')) {
      return 'https://images.unsplash.com/photo-1494314671902-399b18174975?auto=format&fit=crop&w=1200&q=80';
    }
    if (value.contains('cappuccino')) {
      return 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=1200&q=80';
    }
    return 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=1200&q=80';
  }
}
