import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_closed.freezed.dart';
part 'conversation_closed.g.dart';

/// Payload of the `conversation.closed` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §7
@Freezed(toJson: false)
class ConversationClosedData with _$ConversationClosedData {
  const factory ConversationClosedData({
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'closed_at') DateTime? closedAt,
  }) = _ConversationClosedData;

  factory ConversationClosedData.fromJson(Map<String, dynamic> json) =>
      _$ConversationClosedDataFromJson(json);
}

@Freezed(toJson: false)
class ConversationClosedNotification with _$ConversationClosedNotification {
  const factory ConversationClosedNotification({
    required String event,
    String? channel,
    required ConversationClosedData data,
    DateTime? receivedAt,
  }) = _ConversationClosedNotification;
}
