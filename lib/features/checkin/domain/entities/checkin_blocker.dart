/// Reasons a ticket can't be checked in. Maps from the spec's `error` /
/// `blocking_reason` codes plus the transport-level errors that need a
/// user-facing decision in the check-in UI.
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md §3.2 (peek) and §4.4 (commit).
enum CheckinBlocker {
  ticketCancelled,
  ticketRefunded,
  ticketTransferred,
  slotNotStarted,
  wrongEvent,
  unauthorized,
  ticketNotFound,

  /// Used for unexpected backend-side errors and client format errors,
  /// shown with a localized generic retry message.
  unknown,
}

/// Map a backend error code (`error` field on the JSON envelope OR
/// `blocking_reason` on a 200 peek) into the local enum.
CheckinBlocker checkinBlockerFromCode(String? code) {
  switch (code) {
    case 'ticket_cancelled':
      return CheckinBlocker.ticketCancelled;
    case 'ticket_refunded':
      return CheckinBlocker.ticketRefunded;
    case 'ticket_transferred':
      return CheckinBlocker.ticketTransferred;
    case 'slot_not_started':
      return CheckinBlocker.slotNotStarted;
    case 'wrong_event':
      return CheckinBlocker.wrongEvent;
    case 'unauthorized':
      return CheckinBlocker.unauthorized;
    case 'ticket_not_found':
      return CheckinBlocker.ticketNotFound;
    default:
      return CheckinBlocker.unknown;
  }
}
