import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../domain/models/order_cart_item.dart';
import '../controllers/booking_list_controller.dart';
import '../../../events/domain/entities/event_submodels.dart';

extension BookingL10n on BuildContext {
  String bookingFilterLabel(BookingFilterType filter) {
    final l10n = this.l10n;
    return switch (filter) {
      BookingFilterType.all => l10n.bookingFilterAll,
      BookingFilterType.upcoming => l10n.bookingFilterUpcoming,
      BookingFilterType.past => l10n.bookingFilterPast,
      BookingFilterType.cancelled => l10n.bookingFilterCancelled,
    };
  }

  String bookingSortLabel(BookingSortOption option) {
    final l10n = this.l10n;
    return switch (option) {
      BookingSortOption.dateAsc => l10n.bookingSortDateAsc,
      BookingSortOption.dateDesc => l10n.bookingSortDateDesc,
      BookingSortOption.statusAsc => l10n.bookingSortStatusAsc,
    };
  }

  String bookingRelationshipLabel(String relationship) {
    final l10n = this.l10n;
    return switch (relationship) {
      'self' => l10n.bookingRelationshipSelf,
      'child' => l10n.bookingRelationshipChild,
      'spouse' => l10n.bookingRelationshipSpouse,
      'family' => l10n.bookingRelationshipFamily,
      'friend' => l10n.bookingRelationshipFriend,
      'other' => l10n.bookingRelationshipOther,
      _ => relationship,
    };
  }

  String bookingStatusLabel(String? status) {
    final l10n = this.l10n;
    return switch (status?.toLowerCase()) {
      'pending' => l10n.bookingStatusPending,
      'confirmed' => l10n.bookingStatusConfirmed,
      'cancelled' => l10n.bookingStatusCancelled,
      'completed' => l10n.bookingStatusCompleted,
      'refunded' => l10n.bookingStatusRefunded,
      _ => l10n.bookingStatusPending,
    };
  }

  String bookingTicketStatusLabel(String? status) {
    final l10n = this.l10n;
    return switch (status?.toLowerCase()) {
      'active' => l10n.bookingTicketStatusActive,
      'used' => l10n.bookingTicketStatusUsed,
      'cancelled' => l10n.bookingTicketStatusCancelled,
      'expired' => l10n.bookingTicketStatusExpired,
      _ => l10n.bookingTicketStatusActive,
    };
  }

  String bookingSlotLabel(CalendarDateSlot? slot) {
    if (slot == null) return '';

    final date = appDateFormat(
      'dd/MM/yyyy',
      enPattern: 'MM/dd/yyyy',
    ).format(slot.date);
    final start = _formatTime(slot.startTime);
    return start.isEmpty ? date : '$date · $start';
  }

  String bookingCartItemSlotLabel(OrderCartItem item) {
    return bookingSlotLabel(item.selectedSlot);
  }
}

AppLocalizations bookingCachedL10n() {
  return lookupAppLocalizations(Locale(AppLocaleCache.languageCode));
}

String formatBookingTime(String? raw) => _formatTime(raw);

String _formatTime(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return '';

  final match =
      RegExp(r'(\d{1,2}):(\d{2})(?::\d{2}(?:\.\d+)?)?').firstMatch(value);
  if (match == null) return value;

  final hour = match.group(1)!.padLeft(2, '0');
  final minute = match.group(2)!;
  return '$hour:$minute';
}
