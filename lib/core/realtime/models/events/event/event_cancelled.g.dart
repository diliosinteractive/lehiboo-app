// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_cancelled.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventCancelledDataImpl _$$EventCancelledDataImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCancelledDataImpl(
      eventId: (json['event_id'] as num).toInt(),
      eventUuid: json['event_uuid'] as String,
      title: json['title'] as String,
      reason: json['reason'] as String?,
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
    );
