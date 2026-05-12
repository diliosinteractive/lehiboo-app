import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/in_app_notification.dart';
import '../../domain/repositories/in_app_notifications_repository.dart';
import '../datasources/in_app_notifications_api_datasource.dart';

final inAppNotificationsRepositoryImplProvider =
    Provider<InAppNotificationsRepository>((ref) {
  return InAppNotificationsRepositoryImpl(
    ref.watch(inAppNotificationsApiDataSourceProvider),
  );
});

class InAppNotificationsRepositoryImpl implements InAppNotificationsRepository {
  final InAppNotificationsApiDataSource _dataSource;

  const InAppNotificationsRepositoryImpl(this._dataSource);

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
    final result = await _dataSource.getNotifications(
      page: page,
      perPage: perPage,
      unreadOnly: unreadOnly,
      type: type,
      context: context,
      organizationId: organizationId,
      search: search,
    );
    return InAppNotificationsPage(
      notifications: result.notifications
          .map((notification) => notification.toDomain())
          .toList(),
      currentPage: result.currentPage,
      lastPage: result.lastPage,
      perPage: result.perPage,
      total: result.total,
    );
  }

  @override
  Future<int> getUnreadCount({
    required String context,
    String? organizationId,
  }) {
    return _dataSource.getUnreadCount(
      context: context,
      organizationId: organizationId,
    );
  }

  @override
  Future<InAppNotification> getNotification(String id) async {
    return (await _dataSource.getNotification(id)).toDomain();
  }

  @override
  Future<void> markAsRead(String id) => _dataSource.markAsRead(id);

  @override
  Future<int> markAllAsRead({
    required String context,
    String? organizationId,
  }) {
    return _dataSource.markAllAsRead(
      context: context,
      organizationId: organizationId,
    );
  }

  @override
  Future<void> deleteNotification(String id) {
    return _dataSource.deleteNotification(id);
  }

  @override
  Future<int> deleteReadNotifications({
    required String context,
    String? organizationId,
  }) {
    return _dataSource.deleteReadNotifications(
      context: context,
      organizationId: organizationId,
    );
  }
}
