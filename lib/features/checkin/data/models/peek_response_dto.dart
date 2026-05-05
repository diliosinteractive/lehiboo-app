import 'ticket_summary_dto.dart';

/// Body returned by `POST /vendor/tickets/scan/peek` (200 OK).
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md §3.2.
class PeekResponseDto {
  final TicketSummaryDto ticket;
  final bool canCheckIn;
  final bool wouldBeReEntry;

  /// Null when the ticket can be checked in. Otherwise one of:
  /// `ticket_cancelled` / `ticket_refunded` / `ticket_transferred` /
  /// `slot_not_started`.
  final String? blockingReason;

  final SlotCheckDto slotCheck;

  const PeekResponseDto({
    required this.ticket,
    required this.canCheckIn,
    required this.wouldBeReEntry,
    required this.blockingReason,
    required this.slotCheck,
  });

  factory PeekResponseDto.fromEnvelope(Map<String, dynamic> envelope) {
    final data = envelope['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('peek: missing "data" object');
    }
    final ticket = data['ticket'];
    if (ticket is! Map<String, dynamic>) {
      throw const FormatException('peek: missing "ticket" object');
    }
    final slotCheck = data['slot_check'];
    return PeekResponseDto(
      ticket: TicketSummaryDto.fromJson(ticket),
      canCheckIn: data['can_check_in'] == true,
      wouldBeReEntry: data['would_be_re_entry'] == true,
      blockingReason: data['blocking_reason']?.toString(),
      slotCheck:
          SlotCheckDto.fromJson(slotCheck is Map<String, dynamic> ? slotCheck : null),
    );
  }
}
