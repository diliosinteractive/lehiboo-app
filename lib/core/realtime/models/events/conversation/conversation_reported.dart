import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_reported.freezed.dart';
part 'conversation_reported.g.dart';

/// Payload of the `conversation.reported` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §7
@Freezed(toJson: false)
class ConversationReportedData with _$ConversationReportedData {
  const factory ConversationReportedData({
    @JsonKey(name: 'report_uuid') required String reportUuid,
    @JsonKey(name: 'conversation_uuid') required String conversationUuid,
    String? reason,
  }) = _ConversationReportedData;

  factory ConversationReportedData.fromJson(Map<String, dynamic> json) =>
      _$ConversationReportedDataFromJson(json);
}

@Freezed(toJson: false)
class ConversationReportedNotification with _$ConversationReportedNotification {
  const factory ConversationReportedNotification({
    required String event,
    String? channel,
    required ConversationReportedData data,
    DateTime? receivedAt,
  }) = _ConversationReportedNotification;
}
