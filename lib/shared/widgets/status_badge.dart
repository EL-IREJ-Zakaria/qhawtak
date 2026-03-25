import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/models/order.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final ColorPair colors = _pair(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  String _label(OrderStatus s) {
    switch (s) {
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

  ColorPair _pair(OrderStatus s) {
    switch (s) {
      case OrderStatus.newOrder:
        return const ColorPair(Color(0xFFE8F1FB), AppColors.info);
      case OrderStatus.accepted:
        return const ColorPair(Color(0xFFF0E4DB), AppColors.secondary);
      case OrderStatus.preparing:
        return const ColorPair(Color(0xFFFFE7D0), AppColors.warning);
      case OrderStatus.ready:
        return const ColorPair(Color(0xFFE4F3E5), AppColors.success);
      case OrderStatus.completed:
        return const ColorPair(Color(0xFFEFE9E7), AppColors.textSecondary);
      case OrderStatus.cancelled:
        return const ColorPair(Color(0xFFFADDDD), AppColors.error);
    }
  }
}

class ColorPair {
  const ColorPair(this.background, this.foreground);
  final Color background;
  final Color foreground;
}
