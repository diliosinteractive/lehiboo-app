import 'ticket_summary_dto.dart';

/// Body returned by `POST /vendor/tickets/{uuid}/check-in` (200 OK).
///
/// `action` is the canonical signal — branch on it, not on the message
/// text. Spec: docs/MOBILE_CHECKIN_SPEC.md §4.2 / §4.3.
class CheckinResponseDto {
  final TicketSummaryDto ticket;

  /// `check_in` for the first entry, `re_entry` for subsequent scans.
  final String action;

  final int checkInCount;
  final String? message;

  const CheckinResponseDto({
    required this.ticket,
    required this.action,
    required this.checkInCount,
    this.message,
  });

  bool get isReEntry => action == 're_entry';

  factory CheckinResponseDto.fromEnvelope(Map<String, dynamic> envelope) {
    final data = envelope['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('check-in: missing "data" object');
    }
    final ticket = data['ticket'];
    if (ticket is! Map<String, dynamic>) {
      throw const FormatException('check-in: missing "ticket" object');
    }
    int parseCount(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return CheckinResponseDto(
      ticket: TicketSummaryDto.fromJson(ticket),
      action: data['action']?.toString() ?? 'check_in',
      checkInCount: parseCount(data['check_in_count']),
      message: envelope['message']?.toString(),
    );
  }
}
