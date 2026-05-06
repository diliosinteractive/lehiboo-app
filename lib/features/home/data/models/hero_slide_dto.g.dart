// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_slide_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HeroSlideDtoImpl _$$HeroSlideDtoImplFromJson(Map<String, dynamic> json) =>
    _$HeroSlideDtoImpl(
      uuid: json['uuid'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      altText: json['alt_text'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HeroSlideDtoImplToJson(_$HeroSlideDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'image_url': instance.imageUrl,
      'alt_text': instance.altText,
      'sort_order': instance.sortOrder,
    };
