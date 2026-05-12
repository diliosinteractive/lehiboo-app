import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/in_app_notification_dto.dart';

final inAppNotificationsApiDataSourceProvider =
    Provider<InAppNotificationsApiDataSource>((ref) {
  return InAppNotificationsApiDataSource(ref.watch(dioProvider));
});

class InAppNotificationsApiDataSource {
  final Dio _dio;

  const InAppNotificationsApiDataSource(this._dio);

  Future<InAppNotificationsPageDto> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
    String? type,
    required String context,
    String? organizationId,
    String? search,
  }) async {
    final response = await _dio.get(
      '/notifications',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'context': context,
        if (unreadOnly) 'unread_only': 'true',
        if (type != null && type.isNotEmpty) 'type': type,
        if (organizationId != null && organizationId.isNotEmpty)
          'organization_id': organizationId,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );

    final items = ApiResponseHandler.extractList(response.data)
        .whereType<Map>()
        .map((item) => InAppNotificationDto.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ))
        .toList();
    final meta = ApiResponseHandler.extractMeta(response.data);

    return InAppNotificationsPageDto(
      notifications: items,
      currentPage: meta?.currentPage ?? page,
      lastPage: meta?.lastPage ?? page,
      perPage: meta?.perPage ?? perPage,
      total: meta?.total ?? items.length,
    );
  }

  Future<int> getUnreadCount({
    required String context,
    String? organizationId,
  }) async {
    final response = await _dio.get(
      '/notifications/unread-count',
      queryParameters: {
        'context': context,
        if (organizationId != null && organizationId.isNotEmpty)
          'organization_id': organizationId,
      },
    );
    final data = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );
    return _int(data['count']) ?? _int(data['unread']) ?? 0;
  }

  Future<InAppNotificationDto> getNotification(String id) async {
    final response = await _dio.get('/notifications/$id');
    final root = response.data;
    final data = root is Map<String, dynamic> && root['id'] != null
        ? root
        : ApiResponseHandler.extractObject(
            root,
            unwrapRoot: true,
          );
    return InAppNotificationDto.fromJson(data);
  }

  Future<void> markAsRead(String id) async {
    await _dio.post('/notifications/$id/read');
  }

  Future<int> markAllAsRead({
    required String context,
    String? organizationId,
  }) async {
    final response = await _dio.post(
      '/notifications/read-all',
      queryParameters: {
        'context': context,
        if (organizationId != null && organizationId.isNotEmpty)
          'organization_id': organizationId,
      },
    );
    final data = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );
    return _int(data['count']) ?? 0;
  }

  Future<void> deleteNotification(String id) async {
    await _dio.delete('/notifications/$id');
  }

  Future<int> deleteReadNotifications({
    required String context,
    String? organizationId,
  }) async {
    final response = await _dio.delete(
      '/notifications/read',
      queryParameters: {
        'context': context,
        if (organizationId != null && organizationId.isNotEmpty)
          'organization_id': organizationId,
      },
    );
    final data = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );
    return _int(data['count']) ?? 0;
  }

  static int? _int(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class InAppNotificationsPageDto {
  final List<InAppNotificationDto> notifications;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const InAppNotificationsPageDto({
    required this.notifications,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}
