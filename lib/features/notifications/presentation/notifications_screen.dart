import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/models/admin_notification.dart';
import 'package:qhawtak/shared/widgets/coffee_hero_banner.dart';
import 'package:qhawtak/shared/widgets/empty_state.dart';
import 'package:qhawtak/shared/widgets/staggered_fade_slide.dart';

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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const CoffeeHeroBanner(
          imageUrl:
              'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=1200&q=80',
          title: 'Order Alerts',
          subtitle: 'Stay updated with every table in the cafe',
          height: 126,
        ),
        const SizedBox(height: 12),
        ...notifications.asMap().entries.map((entry) {
          final int index = entry.key;
          final AdminNotification notification = entry.value;
          return StaggeredFadeSlide(
            index: index,
            child: Card(
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
            ),
          );
        }),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
