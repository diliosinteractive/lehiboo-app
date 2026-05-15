// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationCreatedDataImpl _$$ConversationCreatedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationCreatedDataImpl(
      conversationUuid: json['conversation_uuid'] as String,
      conversationType: json['conversation_type'] as String,
      subject: json['subject'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
