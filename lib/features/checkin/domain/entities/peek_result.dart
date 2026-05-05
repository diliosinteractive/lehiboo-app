import '../../data/models/peek_response_dto.dart';
import '../../data/models/ticket_summary_dto.dart';
import 'checkin_blocker.dart';

/// Outcome of a peek call as the UI cares about it. Mapped from the
/// `PeekResponseDto` (or an error envelope) by the repository — the UI
/// only ever switches on this sealed type.
sealed class PeekResult {
  const PeekResult();
}

/// Green state — ticket is valid and has never been checked in.
class CanCheckIn extends PeekResult {
  final TicketSummaryDto ticket;
  const CanCheckIn(this.ticket);
}

/// Amber state — ticket is valid but already has at least one entry.
/// `currentCount` is `ticket.checkInCount` at peek time; the vendor
/// decides whether to admit again.
class WouldBeReEntry extends PeekResult {
  final TicketSummaryDto ticket;
  final int currentCount;
  const WouldBeReEntry(this.ticket, this.currentCount);
}

/// Red state — ticket can't be checked in. `reason` drives the user copy
/// and whether the confirm CTA is suppressed.
class Blocked extends PeekResult {
  final TicketSummaryDto? ticket;
  final CheckinBlocker reason;
  const Blocked(this.reason, {this.ticket});
}

PeekResult mapPeekResponseToResult(PeekResponseDto dto) {
  if (!dto.canCheckIn) {
    return Blocked(
      checkinBlockerFromCode(dto.blockingReason),
      ticket: dto.ticket,
    );
  }
  if (dto.wouldBeReEntry) {
    return WouldBeReEntry(dto.ticket, dto.ticket.checkInCount);
  }
  return CanCheckIn(dto.ticket);
}
