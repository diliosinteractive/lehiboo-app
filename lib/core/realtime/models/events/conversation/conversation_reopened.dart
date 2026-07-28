import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_reopened.freezed.dart';
part 'conversation_reopened.g.dart';

/// Payload of the `conversation.reopened` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §7
@Freezed(toJson: false)
class ConversationReopenedData with _$ConversationReopenedData {
  const factory ConversationReopenedData({
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'reopened_at') DateTime? reopenedAt,
  }) = _ConversationReopenedData;

  factory ConversationReopenedData.fromJson(Map<String, dynamic> json) =>
      _$ConversationReopenedDataFromJson(json);
}

@Freezed(toJson: false)
class ConversationReopenedNotification with _$ConversationReopenedNotification {
  const factory ConversationReopenedNotification({
    required String event,
    String? channel,
    required ConversationReopenedData data,
    DateTime? receivedAt,
  }) = _ConversationReopenedNotification;
}
