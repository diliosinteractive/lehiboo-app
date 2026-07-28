// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_published.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventPublishedDataImpl _$$EventPublishedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$EventPublishedDataImpl(
      eventId: (json['event_id'] as num).toInt(),
      eventUuid: json['event_uuid'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      organizationId: (json['organization_id'] as num).toInt(),
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
    );
