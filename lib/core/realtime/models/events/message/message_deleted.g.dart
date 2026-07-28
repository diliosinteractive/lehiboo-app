// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_deleted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageDeletedDataImpl _$$MessageDeletedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageDeletedDataImpl(
      messageUuid: json['message_uuid'] as String,
      conversationUuid: json['conversation_uuid'] as String,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );
