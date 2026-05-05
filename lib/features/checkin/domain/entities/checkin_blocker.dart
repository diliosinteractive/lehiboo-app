/// Reasons a ticket can't be checked in. Maps from the spec's `error` /
/// `blocking_reason` codes plus the transport-level errors that need
/// user-visible copy.
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
  /// Used for unexpected backend-side errors and client format errors —
  /// shown with a generic "Erreur — réessayer" copy.
  unknown,
}

extension CheckinBlockerX on CheckinBlocker {
  /// French copy ready for the red sheet primary line.
  String get title => switch (this) {
        CheckinBlocker.ticketCancelled => 'Billet annulé',
        CheckinBlocker.ticketRefunded => 'Billet remboursé',
        CheckinBlocker.ticketTransferred => 'Billet transféré',
        CheckinBlocker.slotNotStarted => 'Créneau non commencé',
        CheckinBlocker.wrongEvent => 'Mauvais événement',
        CheckinBlocker.unauthorized => 'Non autorisé',
        CheckinBlocker.ticketNotFound => 'Billet introuvable',
        CheckinBlocker.unknown => 'Erreur',
      };

  /// French copy for the red sheet body / vendor instruction.
  String get subtitle => switch (this) {
        CheckinBlocker.ticketCancelled => 'Ne pas laisser entrer.',
        CheckinBlocker.ticketRefunded => 'Ne pas laisser entrer.',
        CheckinBlocker.ticketTransferred =>
          'Le billet a été transféré à un autre porteur — re-scannez son QR.',
        CheckinBlocker.slotNotStarted =>
          "L'entrée n'est pas encore ouverte pour ce créneau.",
        CheckinBlocker.wrongEvent =>
          "Ce billet ne correspond pas à l'événement filtré.",
        CheckinBlocker.unauthorized =>
          "Vous n'êtes pas autorisé à scanner ce billet pour cette organisation.",
        CheckinBlocker.ticketNotFound =>
          'QR non reconnu — réessayez ou saisissez le code.',
        CheckinBlocker.unknown => 'Erreur inattendue, réessayez.',
      };
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
