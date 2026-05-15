// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_delivered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageDeliveredDataImpl _$$MessageDeliveredDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageDeliveredDataImpl(
      messageUuid: json['message_uuid'] as String,
      conversationUuid: json['conversation_uuid'] as String,
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
    );
