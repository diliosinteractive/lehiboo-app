import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_delivered.freezed.dart';
part 'message_delivered.g.dart';

/// Payload of the `message.delivered` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §8
@Freezed(toJson: false)
class MessageDeliveredData with _$MessageDeliveredData {
  const factory MessageDeliveredData({
    @JsonKey(name: 'message_uuid') required String messageUuid,
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
  }) = _MessageDeliveredData;

  factory MessageDeliveredData.fromJson(Map<String, dynamic> json) =>
      _$MessageDeliveredDataFromJson(json);
}

@Freezed(toJson: false)
class MessageDeliveredNotification with _$MessageDeliveredNotification {
  const factory MessageDeliveredNotification({
    required String event,
    String? channel,
    required MessageDeliveredData data,
    DateTime? receivedAt,
  }) = _MessageDeliveredNotification;
}
