// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CityImpl _$$CityImplFromJson(Map<String, dynamic> json) => _$CityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      region: json['region'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      eventCount: (json['eventCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CityImplToJson(_$CityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'lat': instance.lat,
      'lng': instance.lng,
      'region': instance.region,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'eventCount': instance.eventCount,
    };
