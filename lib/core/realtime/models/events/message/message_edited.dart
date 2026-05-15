import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_edited.freezed.dart';
part 'message_edited.g.dart';

/// Payload of the `message.edited` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §8
@Freezed(toJson: false)
class MessageEditedData with _$MessageEditedData {
  const factory MessageEditedData({
    @JsonKey(name: 'message_uuid') required String messageUuid,
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    String? content,
    @JsonKey(name: 'edited_at') DateTime? editedAt,
  }) = _MessageEditedData;

  factory MessageEditedData.fromJson(Map<String, dynamic> json) =>
      _$MessageEditedDataFromJson(json);
}

@Freezed(toJson: false)
class MessageEditedNotification with _$MessageEditedNotification {
  const factory MessageEditedNotification({
    required String event,
    String? channel,
    required MessageEditedData data,
    DateTime? receivedAt,
  }) = _MessageEditedNotification;
}
