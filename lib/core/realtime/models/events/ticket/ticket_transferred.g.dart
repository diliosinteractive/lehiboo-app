// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_transferred.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketTransferredDataImpl _$$TicketTransferredDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketTransferredDataImpl(
      ticketId: (json['ticket_id'] as num).toInt(),
      eventId: (json['event_id'] as num).toInt(),
      fromUserId: (json['from_user_id'] as num).toInt(),
      toEmail: json['to_email'] as String,
      transferredAt: json['transferred_at'] == null
          ? null
          : DateTime.parse(json['transferred_at'] as String),
    );
