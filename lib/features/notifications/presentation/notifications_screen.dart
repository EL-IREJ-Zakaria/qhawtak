import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/models/admin_notification.dart';
import 'package:qhawtak/shared/widgets/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, required this.notifications});

  final List<AdminNotification> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const EmptyState(
        title: 'No notifications',
        message: 'You are all caught up.',
        icon: Icons.notifications_none,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index) {
        final AdminNotification notification = notifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: Icon(
              notification.isUnread ? Icons.notifications_active : Icons.notifications_none,
              color: notification.isUnread ? AppColors.accent : AppColors.textSecondary,
            ),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isUnread ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            subtitle: Text(notification.message),
            trailing: Text(
              _timeAgo(notification.createdAt),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  String _timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
