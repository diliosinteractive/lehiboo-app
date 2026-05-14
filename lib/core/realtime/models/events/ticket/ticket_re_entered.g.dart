// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_re_entered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketReEnteredDataImpl _$$TicketReEnteredDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketReEnteredDataImpl(
      ticketId: (json['ticket_id'] as num).toInt(),
      ticketUuid: json['ticket_uuid'] as String,
      qrCode: json['qr_code'] as String,
      eventId: (json['event_id'] as num).toInt(),
      scannedAt: json['scanned_at'] == null
          ? null
          : DateTime.parse(json['scanned_at'] as String),
      scanLocation: json['scan_location'] as String?,
      checkInCount: (json['check_in_count'] as num?)?.toInt(),
      attendeeName: json['attendee_name'] as String?,
    );
