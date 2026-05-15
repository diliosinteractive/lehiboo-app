// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_edited.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageEditedDataImpl _$$MessageEditedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageEditedDataImpl(
      messageUuid: json['message_uuid'] as String,
      conversationUuid: json['conversation_uuid'] as String,
      content: json['content'] as String?,
      editedAt: json['edited_at'] == null
          ? null
          : DateTime.parse(json['edited_at'] as String),
    );
