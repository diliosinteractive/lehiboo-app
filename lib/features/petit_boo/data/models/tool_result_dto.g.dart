// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolResultDtoImpl _$$ToolResultDtoImplFromJson(Map<String, dynamic> json) =>
    _$ToolResultDtoImpl(
      tool: json['tool'] as String,
      data: _readDataOrResult(json, 'data') as Map<String, dynamic>,
      executedAt: json['executed_at'] as String?,
    );

Map<String, dynamic> _$$ToolResultDtoImplToJson(_$ToolResultDtoImpl instance) =>
    <String, dynamic>{
      'tool': instance.tool,
      'data': instance.data,
      'executed_at': instance.executedAt,
    };
