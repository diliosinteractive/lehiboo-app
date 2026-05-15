import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_deleted.freezed.dart';
part 'message_deleted.g.dart';

/// Payload of the `message.deleted` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §8
@Freezed(toJson: false)
class MessageDeletedData with _$MessageDeletedData {
  const factory MessageDeletedData({
    @JsonKey(name: 'message_uuid') required String messageUuid,
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _MessageDeletedData;

  factory MessageDeletedData.fromJson(Map<String, dynamic> json) =>
      _$MessageDeletedDataFromJson(json);
}

@Freezed(toJson: false)
class MessageDeletedNotification with _$MessageDeletedNotification {
  const factory MessageDeletedNotification({
    required String event,
    String? channel,
    required MessageDeletedData data,
    DateTime? receivedAt,
  }) = _MessageDeletedNotification;
}
