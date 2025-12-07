// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thematique_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThematiqueDtoImpl _$$ThematiqueDtoImplFromJson(Map<String, dynamic> json) =>
    _$ThematiqueDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      image: json['image'] == null
          ? null
          : ThematiqueImageDto.fromJson(json['image'] as Map<String, dynamic>),
      eventCount: (json['event_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ThematiqueDtoImplToJson(_$ThematiqueDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'icon': instance.icon,
      'image': instance.image,
      'event_count': instance.eventCount,
    };

_$ThematiqueImageDtoImpl _$$ThematiqueImageDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ThematiqueImageDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      thumbnail: json['thumbnail'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
      full: json['full'] as String?,
    );

Map<String, dynamic> _$$ThematiqueImageDtoImplToJson(
        _$ThematiqueImageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'large': instance.large,
      'full': instance.full,
    };

_$ThematiquesResponseDtoImpl _$$ThematiquesResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ThematiquesResponseDtoImpl(
      thematiques: (json['thematiques'] as List<dynamic>)
          .map((e) => ThematiqueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$ThematiquesResponseDtoImplToJson(
        _$ThematiquesResponseDtoImpl instance) =>
    <String, dynamic>{
      'thematiques': instance.thematiques,
      'count': instance.count,
    };
