import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_checked_in.freezed.dart';
part 'ticket_checked_in.g.dart';

/// Payload of the `ticket.checked_in` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §5
@Freezed(toJson: false)
class TicketCheckedInData with _$TicketCheckedInData {
  const factory TicketCheckedInData({
    @JsonKey(name: 'ticket_id') required int ticketId,
    @JsonKey(name: 'ticket_uuid') required String ticketUuid,
    @JsonKey(name: 'qr_code') required String qrCode,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'checked_in_at') DateTime? checkedInAt,
    @JsonKey(name: 'scan_location') String? scanLocation,
    @JsonKey(name: 'attendee_name') String? attendeeName,
  }) = _TicketCheckedInData;

  factory TicketCheckedInData.fromJson(Map<String, dynamic> json) =>
      _$TicketCheckedInDataFromJson(json);
}

@Freezed(toJson: false)
class TicketCheckedInNotification with _$TicketCheckedInNotification {
  const factory TicketCheckedInNotification({
    required String event,
    String? channel,
    required TicketCheckedInData data,
    DateTime? receivedAt,
  }) = _TicketCheckedInNotification;
}
