import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lehiboo/features/notifications/data/models/in_app_notification_dto.dart';

part 'notification_created.freezed.dart';
part 'notification_created.g.dart';

/// Payload of the `notification.created` event.
///
/// Wraps a Laravel `DatabaseNotification` (the in-app notification stored
/// in the `notifications` table). The nested `notification` field is parsed
/// via the existing [InAppNotificationDto] to avoid duplicating its manual
/// `fromJson` parser.
///
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §3
@Freezed(toJson: false)
class NotificationCreatedData with _$NotificationCreatedData {
  const factory NotificationCreatedData({
    @JsonKey(fromJson: _notificationFromJson)
    required InAppNotificationDto notification,
    @JsonKey(name: 'unread_count') int? unreadCount,
    @JsonKey(name: 'occurred_at') DateTime? occurredAt,
  }) = _NotificationCreatedData;

  factory NotificationCreatedData.fromJson(Map<String, dynamic> json) =>
      _$NotificationCreatedDataFromJson(json);
}

InAppNotificationDto _notificationFromJson(Map<String, dynamic> json) =>
    InAppNotificationDto.fromJson(json);

@Freezed(toJson: false)
class NotificationCreatedNotification with _$NotificationCreatedNotification {
  const factory NotificationCreatedNotification({
    required String event,
    String? channel,
    required NotificationCreatedData data,
    DateTime? receivedAt,
  }) = _NotificationCreatedNotification;
}
