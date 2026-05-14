import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/models/order_cart_item.dart';
import '../../../events/domain/entities/event_submodels.dart';

extension BookingL10n on BuildContext {
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
