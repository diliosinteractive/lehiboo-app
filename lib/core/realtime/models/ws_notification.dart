import 'package:freezed_annotation/freezed_annotation.dart';

import 'ws_event_name.dart';

import 'events/notification/notification_created.dart';

import 'events/booking/booking_created.dart';
import 'events/booking/booking_confirmed.dart';
import 'events/booking/booking_cancelled.dart';
import 'events/booking/booking_refunded.dart';

import 'events/ticket/ticket_checked_in.dart';
import 'events/ticket/ticket_re_entered.dart';
import 'events/ticket/ticket_transferred.dart';

import 'events/event/event_published.dart';
import 'events/event/event_unpublished.dart';
import 'events/event/event_cancelled.dart';

import 'events/conversation/conversation_created.dart';
import 'events/conversation/conversation_closed.dart';
import 'events/conversation/conversation_read.dart';
import 'events/conversation/conversation_reopened.dart';
import 'events/conversation/conversation_reported.dart';

import 'events/message/message_received.dart';
import 'events/message/message_edited.dart';
import 'events/message/message_deleted.dart';
import 'events/message/message_delivered.dart';

import 'events/collaboration/collaboration_invited.dart';
import 'events/collaboration/collaboration_accepted.dart';
import 'events/collaboration/collaboration_rejected.dart';
import 'events/collaboration/collaboration_removed.dart';
import 'events/collaboration/collaborator_invitation_declined.dart';

import 'events/partnership/partnership_invited.dart';
import 'events/partnership/partnership_accepted.dart';

import 'events/organization/organization_registered.dart';
import 'events/organization/organization_approved.dart';
import 'events/organization/organization_rejected.dart';
import 'events/organization/organization_verified.dart';
import 'events/organization/organization_suspended.dart';
import 'events/organization/organization_reactivated.dart';

import 'events/payout/payout_requested.dart';
import 'events/payout/payout_completed.dart';
import 'events/payout/payout_cancelled.dart';

part 'ws_notification.freezed.dart';

/// Untyped wrapper for any real-time event delivered via Pusher.
///
/// Carries the raw event name (e.g. `booking.confirmed`), the originating
/// channel (e.g. `private-user.42`) and the raw payload as a
/// `Map<String, dynamic>`.
///
/// Use [eventName] to identify the event, then call the matching
/// `toXxxNotification()` method to obtain a strongly-typed notification
/// whose `data` field is a typed DTO matching the catalogue documented in
/// `docs/PUSHER_EVENTS_CATALOG.md`.
///
/// Each `toXxx()` method throws a [StateError] if the [event] string does
/// not match the expected wire name — the caller is responsible for
/// dispatching on [eventName] first (fail fast).
@Freezed(toJson: false)
class WSNotification with _$WSNotification {
  const WSNotification._();

  const factory WSNotification({
    required String event,
    String? channel,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    DateTime? receivedAt,
  }) = _WSNotification;

  /// Build from a raw Pusher frame.
  factory WSNotification.fromRaw({
    required String event,
    String? channel,
    Map<String, dynamic>? data,
  }) =>
      WSNotification(
        event: event,
        channel: channel,
        data: data ?? const {},
        receivedAt: DateTime.now(),
      );

  /// The typed enum representation of [event], or `null` if the wire name
  /// is not recognised (forward-compat with future events).
  WSEventName? get eventName => WSEventName.tryFromWire(event);

  // ── §3 — Notifications in-app ────────────────────────────────────────────

  NotificationCreatedNotification toNotificationCreatedNotification() {
    _expect(WSEventName.notificationCreated);
    return NotificationCreatedNotification(
      event: event,
      channel: channel,
      data: NotificationCreatedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §4 — Bookings ────────────────────────────────────────────────────────

  BookingCreatedNotification toBookingCreatedNotification() {
    _expect(WSEventName.bookingCreated);
    return BookingCreatedNotification(
      event: event,
      channel: channel,
      data: BookingCreatedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  BookingConfirmedNotification toBookingConfirmedNotification() {
    _expect(WSEventName.bookingConfirmed);
    return BookingConfirmedNotification(
      event: event,
      channel: channel,
      data: BookingConfirmedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  BookingCancelledNotification toBookingCancelledNotification() {
    _expect(WSEventName.bookingCancelled);
    return BookingCancelledNotification(
      event: event,
      channel: channel,
      data: BookingCancelledData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  BookingRefundedNotification toBookingRefundedNotification() {
    _expect(WSEventName.bookingRefunded);
    return BookingRefundedNotification(
      event: event,
      channel: channel,
      data: BookingRefundedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §5 — Tickets / Check-ins ─────────────────────────────────────────────

  TicketCheckedInNotification toTicketCheckedInNotification() {
    _expect(WSEventName.ticketCheckedIn);
    return TicketCheckedInNotification(
      event: event,
      channel: channel,
      data: TicketCheckedInData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  TicketReEnteredNotification toTicketReEnteredNotification() {
    _expect(WSEventName.ticketReEntered);
    return TicketReEnteredNotification(
      event: event,
      channel: channel,
      data: TicketReEnteredData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  TicketTransferredNotification toTicketTransferredNotification() {
    _expect(WSEventName.ticketTransferred);
    return TicketTransferredNotification(
      event: event,
      channel: channel,
      data: TicketTransferredData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §6 — Events ──────────────────────────────────────────────────────────

  EventPublishedNotification toEventPublishedNotification() {
    _expect(WSEventName.eventPublished);
    return EventPublishedNotification(
      event: event,
      channel: channel,
      data: EventPublishedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  EventUnpublishedNotification toEventUnpublishedNotification() {
    _expect(WSEventName.eventUnpublished);
    return EventUnpublishedNotification(
      event: event,
      channel: channel,
      data: EventUnpublishedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  EventCancelledNotification toEventCancelledNotification() {
    _expect(WSEventName.eventCancelled);
    return EventCancelledNotification(
      event: event,
      channel: channel,
      data: EventCancelledData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §7 — Conversations ───────────────────────────────────────────────────

  ConversationCreatedNotification toConversationCreatedNotification() {
    _expect(WSEventName.conversationCreated);
    return ConversationCreatedNotification(
      event: event,
      channel: channel,
      data: ConversationCreatedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  ConversationClosedNotification toConversationClosedNotification() {
    _expect(WSEventName.conversationClosed);
    return ConversationClosedNotification(
      event: event,
      channel: channel,
      data: ConversationClosedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  ConversationReadNotification toConversationReadNotification() {
    _expect(WSEventName.conversationRead);
    return ConversationReadNotification(
      event: event,
      channel: channel,
      data: ConversationReadData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  ConversationReopenedNotification toConversationReopenedNotification() {
    _expect(WSEventName.conversationReopened);
    return ConversationReopenedNotification(
      event: event,
      channel: channel,
      data: ConversationReopenedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  ConversationReportedNotification toConversationReportedNotification() {
    _expect(WSEventName.conversationReported);
    return ConversationReportedNotification(
      event: event,
      channel: channel,
      data: ConversationReportedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §8 — Messages ────────────────────────────────────────────────────────

  MessageReceivedNotification toMessageReceivedNotification() {
    _expect(WSEventName.messageReceived);
    return MessageReceivedNotification(
      event: event,
      channel: channel,
      data: MessageReceivedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  MessageEditedNotification toMessageEditedNotification() {
    _expect(WSEventName.messageEdited);
    return MessageEditedNotification(
      event: event,
      channel: channel,
      data: MessageEditedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  MessageDeletedNotification toMessageDeletedNotification() {
    _expect(WSEventName.messageDeleted);
    return MessageDeletedNotification(
      event: event,
      channel: channel,
      data: MessageDeletedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  MessageDeliveredNotification toMessageDeliveredNotification() {
    _expect(WSEventName.messageDelivered);
    return MessageDeliveredNotification(
      event: event,
      channel: channel,
      data: MessageDeliveredData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §9 — Collaborations ──────────────────────────────────────────────────

  CollaborationInvitedNotification toCollaborationInvitedNotification() {
    _expect(WSEventName.collaborationInvited);
    return CollaborationInvitedNotification(
      event: event,
      channel: channel,
      data: CollaborationInvitedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  CollaborationAcceptedNotification toCollaborationAcceptedNotification() {
    _expect(WSEventName.collaborationAccepted);
    return CollaborationAcceptedNotification(
      event: event,
      channel: channel,
      data: CollaborationAcceptedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  CollaborationRejectedNotification toCollaborationRejectedNotification() {
    _expect(WSEventName.collaborationRejected);
    return CollaborationRejectedNotification(
      event: event,
      channel: channel,
      data: CollaborationRejectedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  CollaborationRemovedNotification toCollaborationRemovedNotification() {
    _expect(WSEventName.collaborationRemoved);
    return CollaborationRemovedNotification(
      event: event,
      channel: channel,
      data: CollaborationRemovedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  CollaboratorInvitationDeclinedNotification
      toCollaboratorInvitationDeclinedNotification() {
    _expect(WSEventName.collaboratorInvitationDeclined);
    return CollaboratorInvitationDeclinedNotification(
      event: event,
      channel: channel,
      data: CollaboratorInvitationDeclinedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §10 — Partnerships ───────────────────────────────────────────────────

  PartnershipInvitedNotification toPartnershipInvitedNotification() {
    _expect(WSEventName.partnershipInvited);
    return PartnershipInvitedNotification(
      event: event,
      channel: channel,
      data: PartnershipInvitedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  PartnershipAcceptedNotification toPartnershipAcceptedNotification() {
    _expect(WSEventName.partnershipAccepted);
    return PartnershipAcceptedNotification(
      event: event,
      channel: channel,
      data: PartnershipAcceptedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §11 — Organizations ──────────────────────────────────────────────────

  OrganizationRegisteredNotification toOrganizationRegisteredNotification() {
    _expect(WSEventName.organizationRegistered);
    return OrganizationRegisteredNotification(
      event: event,
      channel: channel,
      data: OrganizationRegisteredData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  OrganizationApprovedNotification toOrganizationApprovedNotification() {
    _expect(WSEventName.organizationApproved);
    return OrganizationApprovedNotification(
      event: event,
      channel: channel,
      data: OrganizationApprovedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  OrganizationRejectedNotification toOrganizationRejectedNotification() {
    _expect(WSEventName.organizationRejected);
    return OrganizationRejectedNotification(
      event: event,
      channel: channel,
      data: OrganizationRejectedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  OrganizationVerifiedNotification toOrganizationVerifiedNotification() {
    _expect(WSEventName.organizationVerified);
    return OrganizationVerifiedNotification(
      event: event,
      channel: channel,
      data: OrganizationVerifiedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  OrganizationSuspendedNotification toOrganizationSuspendedNotification() {
    _expect(WSEventName.organizationSuspended);
    return OrganizationSuspendedNotification(
      event: event,
      channel: channel,
      data: OrganizationSuspendedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  OrganizationReactivatedNotification toOrganizationReactivatedNotification() {
    _expect(WSEventName.organizationReactivated);
    return OrganizationReactivatedNotification(
      event: event,
      channel: channel,
      data: OrganizationReactivatedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── §12 — Payouts ────────────────────────────────────────────────────────

  PayoutRequestedNotification toPayoutRequestedNotification() {
    _expect(WSEventName.payoutRequested);
    return PayoutRequestedNotification(
      event: event,
      channel: channel,
      data: PayoutRequestedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  PayoutCompletedNotification toPayoutCompletedNotification() {
    _expect(WSEventName.payoutCompleted);
    return PayoutCompletedNotification(
      event: event,
      channel: channel,
      data: PayoutCompletedData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  PayoutCancelledNotification toPayoutCancelledNotification() {
    _expect(WSEventName.payoutCancelled);
    return PayoutCancelledNotification(
      event: event,
      channel: channel,
      data: PayoutCancelledData.fromJson(data),
      receivedAt: receivedAt,
    );
  }

  // ── Internal ─────────────────────────────────────────────────────────────

  void _expect(WSEventName expected) {
    if (event != expected.wireName) {
      throw StateError(
        'WSNotification: cannot convert event "$event" '
        'to "${expected.wireName}" notification type',
      );
    }
  }
}
