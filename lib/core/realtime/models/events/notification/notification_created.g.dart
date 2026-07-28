// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationCreatedDataImpl _$$NotificationCreatedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationCreatedDataImpl(
      notification:
          _notificationFromJson(json['notification'] as Map<String, dynamic>),
      unreadCount: (json['unread_count'] as num?)?.toInt(),
      occurredAt: json['occurred_at'] == null
          ? null
          : DateTime.parse(json['occurred_at'] as String),
    );
