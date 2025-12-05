// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editorial_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EditorialPostDtoImpl _$$EditorialPostDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EditorialPostDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
    );

Map<String, dynamic> _$$EditorialPostDtoImplToJson(
        _$EditorialPostDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'image_url': instance.imageUrl,
      'published_at': instance.publishedAt?.toIso8601String(),
    };
