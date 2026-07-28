import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_re_entered.freezed.dart';
part 'ticket_re_entered.g.dart';

/// Payload of the `ticket.re_entered` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §5
@Freezed(toJson: false)
class TicketReEnteredData with _$TicketReEnteredData {
  const factory TicketReEnteredData({
    @JsonKey(name: 'ticket_id') required int ticketId,
    @JsonKey(name: 'ticket_uuid') required String ticketUuid,
    @JsonKey(name: 'qr_code') required String qrCode,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'scanned_at') DateTime? scannedAt,
    @JsonKey(name: 'scan_location') String? scanLocation,
    @JsonKey(name: 'check_in_count') int? checkInCount,
    @JsonKey(name: 'attendee_name') String? attendeeName,
  }) = _TicketReEnteredData;

  factory TicketReEnteredData.fromJson(Map<String, dynamic> json) =>
      _$TicketReEnteredDataFromJson(json);
}

@Freezed(toJson: false)
class TicketReEnteredNotification with _$TicketReEnteredNotification {
  const factory TicketReEnteredNotification({
    required String event,
    String? channel,
    required TicketReEnteredData data,
    DateTime? receivedAt,
  }) = _TicketReEnteredNotification;
}
