// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentDtoImpl _$$AttachmentDtoImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentDtoImpl(
      uuid: json['uuid'] as String,
      url: json['url'] as String,
      originalName: json['original_name'] as String,
      mimeType: json['mime_type'] as String,
      size: (json['size'] as num).toInt(),
      isImage: json['is_image'] as bool? ?? false,
      isPdf: json['is_pdf'] as bool? ?? false,
    );

Map<String, dynamic> _$$AttachmentDtoImplToJson(_$AttachmentDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'url': instance.url,
      'original_name': instance.originalName,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'is_image': instance.isImage,
      'is_pdf': instance.isPdf,
    };
