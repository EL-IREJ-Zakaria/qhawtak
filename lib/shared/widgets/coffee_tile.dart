import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/models/coffee.dart';

class CoffeeTile extends StatelessWidget {
  const CoffeeTile({
    super.key,
    required this.coffee,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  final CoffeeItem coffee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          coffee.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${coffee.category} • \$${coffee.price.toStringAsFixed(2)}\n${coffee.description}',
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
            if (value == 'toggle') onToggleAvailability();
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            PopupMenuItem<String>(
              value: 'toggle',
              child: Text(coffee.isAvailable ? 'Mark Out of Stock' : 'Mark In Stock'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: coffee.isAvailable ? AppColors.accent : AppColors.border,
          child: Icon(
            coffee.isAvailable ? Icons.local_cafe : Icons.block,
            color: coffee.isAvailable ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
