import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_read.freezed.dart';
part 'conversation_read.g.dart';

/// Payload of the `conversation.read` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §7
@Freezed(toJson: false)
class ConversationReadData with _$ConversationReadData {
  const factory ConversationReadData({
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'reader_id') required int readerId,
    @JsonKey(name: 'reader_name') String? readerName,
    @JsonKey(name: 'messages_read_count') @Default(0) int messagesReadCount,
    @JsonKey(name: 'read_at') DateTime? readAt,
  }) = _ConversationReadData;

  factory ConversationReadData.fromJson(Map<String, dynamic> json) =>
      _$ConversationReadDataFromJson(json);
}

@Freezed(toJson: false)
class ConversationReadNotification with _$ConversationReadNotification {
  const factory ConversationReadNotification({
    required String event,
    String? channel,
    required ConversationReadData data,
    DateTime? receivedAt,
  }) = _ConversationReadNotification;
}
