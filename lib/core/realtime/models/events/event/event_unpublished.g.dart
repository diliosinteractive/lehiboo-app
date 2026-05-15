// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_unpublished.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventUnpublishedDataImpl _$$EventUnpublishedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$EventUnpublishedDataImpl(
      eventId: (json['event_id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      vendorId: (json['vendor_id'] as num).toInt(),
      unpublishedAt: json['unpublished_at'] == null
          ? null
          : DateTime.parse(json['unpublished_at'] as String),
    );
