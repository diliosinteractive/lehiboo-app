// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_checked_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketCheckedInDataImpl _$$TicketCheckedInDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketCheckedInDataImpl(
      ticketId: (json['ticket_id'] as num).toInt(),
      ticketUuid: json['ticket_uuid'] as String,
      qrCode: json['qr_code'] as String,
      eventId: (json['event_id'] as num).toInt(),
      checkedInAt: json['checked_in_at'] == null
          ? null
          : DateTime.parse(json['checked_in_at'] as String),
      scanLocation: json['scan_location'] as String?,
      attendeeName: json['attendee_name'] as String?,
    );
