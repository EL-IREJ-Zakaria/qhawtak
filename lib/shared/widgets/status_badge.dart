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
    return s.label;
  }

  ColorPair _pair(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return const ColorPair(Color(0xFFE8F1FB), AppColors.info);
      case OrderStatus.preparing:
        return const ColorPair(Color(0xFFFFE7D0), AppColors.warning);
      case OrderStatus.served:
        return const ColorPair(Color(0xFFE4F3E5), AppColors.success);
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
