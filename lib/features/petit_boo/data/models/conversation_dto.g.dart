// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationDtoImpl _$$ConversationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationDtoImpl(
      uuid: json['uuid'] as String,
      title: json['title'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
      lastMessage: json['last_message'] as String?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConversationDtoImplToJson(
        _$ConversationDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'message_count': instance.messageCount,
      'last_message': instance.lastMessage,
      'messages': instance.messages,
    };

_$ConversationsResponseDtoImpl _$$ConversationsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationsResponseDtoImpl(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : ConversationMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConversationsResponseDtoImplToJson(
        _$ConversationsResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'meta': instance.meta,
    };

_$ConversationMetaDtoImpl _$$ConversationMetaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationMetaDtoImpl(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
    );

Map<String, dynamic> _$$ConversationMetaDtoImplToJson(
        _$ConversationMetaDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'per_page': instance.perPage,
      'last_page': instance.lastPage,
    };
