import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_transferred.freezed.dart';
part 'ticket_transferred.g.dart';

/// Payload of the `ticket.transferred` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §5
@Freezed(toJson: false)
class TicketTransferredData with _$TicketTransferredData {
  const factory TicketTransferredData({
    @JsonKey(name: 'ticket_id') required int ticketId,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'from_user_id') required int fromUserId,
    @JsonKey(name: 'to_email') required String toEmail,
    @JsonKey(name: 'transferred_at') DateTime? transferredAt,
  }) = _TicketTransferredData;

  factory TicketTransferredData.fromJson(Map<String, dynamic> json) =>
      _$TicketTransferredDataFromJson(json);
}

@Freezed(toJson: false)
class TicketTransferredNotification with _$TicketTransferredNotification {
  const factory TicketTransferredNotification({
    required String event,
    String? channel,
    required TicketTransferredData data,
    DateTime? receivedAt,
  }) = _TicketTransferredNotification;
}
