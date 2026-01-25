// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'petit_boo_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetitBooEventDtoImpl _$$PetitBooEventDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PetitBooEventDtoImpl(
      type: json['type'] as String,
      content: json['content'] as String?,
      sessionUuid: json['session_uuid'] as String?,
      tool: json['tool'] as String?,
      arguments: json['arguments'] as Map<String, dynamic>?,
      result: json['result'] as Map<String, dynamic>?,
      error: json['error'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$$PetitBooEventDtoImplToJson(
        _$PetitBooEventDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'session_uuid': instance.sessionUuid,
      'tool': instance.tool,
      'arguments': instance.arguments,
      'result': instance.result,
      'error': instance.error,
      'code': instance.code,
    };
