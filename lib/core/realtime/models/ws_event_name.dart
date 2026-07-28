/// Exhaustive enum of all real-time event names broadcast by the Laravel API
/// via Pusher.
///
/// Source of truth: `docs/PUSHER_EVENTS_CATALOG.md`.
///
/// Each value carries the wire-format name (snake_case, dot-separated) as emitted
/// by the backend `broadcastAs()` method.
enum WSEventName {
  // §3 — Notifications in-app (générique)
  notificationCreated('notification.created'),

  // §4 — Bookings
  bookingCreated('booking.created'),
  bookingConfirmed('booking.confirmed'),
  bookingCancelled('booking.cancelled'),
  bookingRefunded('booking.refunded'),

  // §5 — Tickets / Check-ins
  ticketCheckedIn('ticket.checked_in'),
  ticketReEntered('ticket.re_entered'),
  ticketTransferred('ticket.transferred'),

  // §6 — Events (publication / annulation)
  eventPublished('event.published'),
  eventUnpublished('event.unpublished'),
  eventCancelled('event.cancelled'),

  // §7 — Conversations
  conversationCreated('conversation.created'),
  conversationClosed('conversation.closed'),
  conversationRead('conversation.read'),
  conversationReopened('conversation.reopened'),
  conversationReported('conversation.reported'),

  // §8 — Messages
  messageReceived('message.received'),
  messageEdited('message.edited'),
  messageDeleted('message.deleted'),
  messageDelivered('message.delivered'),

  // §9 — Collaborations (event collaborators)
  collaborationInvited('collaboration.invited'),
  collaborationAccepted('collaboration.accepted'),
  collaborationRejected('collaboration.rejected'),
  collaborationRemoved('collaboration.removed'),
  collaboratorInvitationDeclined('collaborator.invitation.declined'),

  // §10 — Partnerships (org ↔ org)
  partnershipInvited('partnership.invited'),
  partnershipAccepted('partnership.accepted'),

  // §11 — Organizations (admin lifecycle)
  organizationRegistered('organization.registered'),
  organizationApproved('organization.approved'),
  organizationRejected('organization.rejected'),
  organizationVerified('organization.verified'),
  organizationSuspended('organization.suspended'),
  organizationReactivated('organization.reactivated'),

  // §12 — Payouts (définis, pas encore émis)
  payoutRequested('payout.requested'),
  payoutCompleted('payout.completed'),
  payoutCancelled('payout.cancelled');

  final String wireName;
  const WSEventName(this.wireName);

  static WSEventName? tryFromWire(String wire) {
    for (final e in values) {
      if (e.wireName == wire) return e;
    }
    return null;
  }
}
