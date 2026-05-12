import '../entities/in_app_notification.dart';

abstract class InAppNotificationsRepository {
  Future<InAppNotificationsPage> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
    String? type,
    required String context,
    String? organizationId,
    String? search,
  });

  Future<int> getUnreadCount({
    required String context,
    String? organizationId,
  });

  Future<InAppNotification> getNotification(String id);

  Future<void> markAsRead(String id);

  Future<int> markAllAsRead({
    required String context,
    String? organizationId,
  });

  Future<void> deleteNotification(String id);

  Future<int> deleteReadNotifications({
    required String context,
    String? organizationId,
  });
}
