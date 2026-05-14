// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_closed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationClosedDataImpl _$$ConversationClosedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationClosedDataImpl(
      conversationUuid: json['conversation_uuid'] as String,
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
    );
