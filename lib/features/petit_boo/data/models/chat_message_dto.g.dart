// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageDtoImpl _$$ChatMessageDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageDtoImpl(
      id: json['id'] as String?,
      role: json['role'] as String,
      content: json['content'] as String,
      toolResults: (json['tool_results'] as List<dynamic>?)
          ?.map((e) => ToolResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      isStreaming: json['isStreaming'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageDtoImplToJson(
        _$ChatMessageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'tool_results': instance.toolResults,
      'created_at': instance.createdAt,
      'isStreaming': instance.isStreaming,
    };
