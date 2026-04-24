// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageSenderDtoImpl _$$MessageSenderDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageSenderDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$MessageSenderDtoImplToJson(
        _$MessageSenderDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
    };

_$MessageDtoImpl _$$MessageDtoImplFromJson(Map<String, dynamic> json) =>
    _$MessageDtoImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      uuid: json['uuid'] as String?,
      conversationId: (json['conversation_id'] as num?)?.toInt() ?? 0,
      senderType: json['sender_type'] as String,
      senderTypeLabel: json['sender_type_label'] as String?,
      isSystem: json['is_system'] as bool? ?? false,
      sender: json['sender'] == null
          ? null
          : MessageSenderDto.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isEdited: json['is_edited'] as bool? ?? false,
      isRead: json['is_read'] as bool? ?? false,
      isDelivered: json['is_delivered'] as bool? ?? false,
      isMine: json['is_mine'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String,
      editedAt: json['edited_at'] as String?,
      readAt: json['read_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
    );

Map<String, dynamic> _$$MessageDtoImplToJson(_$MessageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'conversation_id': instance.conversationId,
      'sender_type': instance.senderType,
      'sender_type_label': instance.senderTypeLabel,
      'is_system': instance.isSystem,
      'sender': instance.sender,
      'content': instance.content,
      'is_deleted': instance.isDeleted,
      'is_edited': instance.isEdited,
      'is_read': instance.isRead,
      'is_delivered': instance.isDelivered,
      'is_mine': instance.isMine,
      'attachments': instance.attachments,
      'created_at': instance.createdAt,
      'edited_at': instance.editedAt,
      'read_at': instance.readAt,
      'delivered_at': instance.deliveredAt,
    };
