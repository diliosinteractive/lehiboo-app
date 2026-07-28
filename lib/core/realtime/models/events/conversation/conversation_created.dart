import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_created.freezed.dart';
part 'conversation_created.g.dart';

/// Payload of the `conversation.created` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §7
@Freezed(toJson: false)
class ConversationCreatedData with _$ConversationCreatedData {
  const factory ConversationCreatedData({
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'conversation_type') required String conversationType,
    String? subject,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ConversationCreatedData;

  factory ConversationCreatedData.fromJson(Map<String, dynamic> json) =>
      _$ConversationCreatedDataFromJson(json);
}

@Freezed(toJson: false)
class ConversationCreatedNotification with _$ConversationCreatedNotification {
  const factory ConversationCreatedNotification({
    required String event,
    String? channel,
    required ConversationCreatedData data,
    DateTime? receivedAt,
  }) = _ConversationCreatedNotification;
}
