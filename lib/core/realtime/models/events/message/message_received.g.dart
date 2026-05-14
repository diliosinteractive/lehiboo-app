// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_received.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageReceivedDataImpl _$$MessageReceivedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageReceivedDataImpl(
      messageUuid: json['message_uuid'] as String,
      conversationUuid: json['conversation_uuid'] as String,
      senderType: json['sender_type'] as String?,
      senderName: json['sender_name'] as String?,
      contentPreview: json['content_preview'] as String?,
      conversationSubject: json['conversation_subject'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
