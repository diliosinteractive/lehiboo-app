// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_reopened.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationReopenedDataImpl _$$ConversationReopenedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationReopenedDataImpl(
      conversationUuid: json['conversation_uuid'] as String,
      reopenedAt: json['reopened_at'] == null
          ? null
          : DateTime.parse(json['reopened_at'] as String),
    );
