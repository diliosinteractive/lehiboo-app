import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_received.freezed.dart';
part 'message_received.g.dart';

/// Payload of the `message.received` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §8
@Freezed(toJson: false)
class MessageReceivedData with _$MessageReceivedData {
  const factory MessageReceivedData({
    @JsonKey(name: 'message_uuid') required String messageUuid,
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'sender_type') String? senderType,
    @JsonKey(name: 'sender_name') String? senderName,
    @JsonKey(name: 'content_preview') String? contentPreview,
    @JsonKey(name: 'conversation_subject') String? conversationSubject,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MessageReceivedData;

  factory MessageReceivedData.fromJson(Map<String, dynamic> json) =>
      _$MessageReceivedDataFromJson(json);
}

@Freezed(toJson: false)
class MessageReceivedNotification with _$MessageReceivedNotification {
  const factory MessageReceivedNotification({
    required String event,
    String? channel,
    required MessageReceivedData data,
    DateTime? receivedAt,
  }) = _MessageReceivedNotification;
}
