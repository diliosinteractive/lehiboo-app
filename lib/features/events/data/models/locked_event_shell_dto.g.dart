// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locked_event_shell_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LockedEventShellDtoImpl _$$LockedEventShellDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LockedEventShellDtoImpl(
      uuid: json['uuid'] == null ? '' : _string(json['uuid']),
      slug: _stringOrNull(json['slug']),
      title: json['title'] == null ? '' : _string(json['title']),
      excerpt: _stringOrNull(json['excerpt']),
      shortDescription: _stringOrNull(json['short_description']),
      coverImage: _stringOrNull(json['cover_image']),
      featuredImage: _stringOrNull(json['featured_image']),
      visibility: _stringOrNull(json['visibility']),
      isPasswordProtected: json['is_password_protected'] == null
          ? true
          : _bool(json['is_password_protected']),
    );

Map<String, dynamic> _$$LockedEventShellDtoImplToJson(
        _$LockedEventShellDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'slug': instance.slug,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'short_description': instance.shortDescription,
      'cover_image': instance.coverImage,
      'featured_image': instance.featuredImage,
      'visibility': instance.visibility,
      'is_password_protected': instance.isPasswordProtected,
    };
