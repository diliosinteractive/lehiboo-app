// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_read.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationReadDataImpl _$$ConversationReadDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationReadDataImpl(
      conversationUuid: json['conversation_uuid'] as String,
      readerId: (json['reader_id'] as num).toInt(),
      readerName: json['reader_name'] as String?,
      messagesReadCount: (json['messages_read_count'] as num?)?.toInt() ?? 0,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
    );
