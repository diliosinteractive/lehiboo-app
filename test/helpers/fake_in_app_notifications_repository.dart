import 'package:lehiboo/features/notifications/domain/entities/in_app_notification.dart';
import 'package:lehiboo/features/notifications/domain/repositories/in_app_notifications_repository.dart';

class FakeInAppNotificationsRepository implements InAppNotificationsRepository {
  int loadCount = 0;
  int unreadCountCalls = 0;

  @override
  Future<InAppNotificationsPage> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
    String? type,
    required String context,
    String? organizationId,
    String? search,
  }) async {
    loadCount++;
    return InAppNotificationsPage(
      notifications: const [],
      currentPage: page,
      lastPage: page,
      perPage: perPage,
      total: 0,
    );
  }

  @override
  Future<int> getUnreadCount({
    required String context,
    String? organizationId,
  }) async {
    unreadCountCalls++;
    return 0;
  }

  @override
  Future<void> deleteNotification(String id) async {}

  @override
  Future<int> deleteReadNotifications({
    required String context,
    String? organizationId,
  }) async =>
      0;

  @override
  Future<InAppNotification> getNotification(String id) {
    return Future<InAppNotification>.error(UnimplementedError());
  }

  @override
  Future<int> markAllAsRead({
    required String context,
    String? organizationId,
  }) async =>
      0;

  @override
  Future<void> markAsRead(String id) async {}
}
