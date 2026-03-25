class AdminNotification {
  const AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isUnread = true,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isUnread;
}
