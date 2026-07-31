import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:shared_preferences/shared_preferences.dart';

final orderCartHoldProvider =
    StateNotifierProvider<OrderCartHoldNotifier, DateTime?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OrderCartHoldNotifier(prefs);
});

final orderCartProvider =
    StateNotifierProvider<OrderCartNotifier, List<OrderCartItem>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OrderCartNotifier(prefs, ref);
});

class OrderCartHoldNotifier extends StateNotifier<DateTime?> {
  static const holdDuration = Duration(minutes: 15);
  static const _storageKey = 'order_cart_hold_expires_at_v1';

  final SharedPreferences _prefs;

  OrderCartHoldNotifier(this._prefs)
      : super(_decode(_prefs.getString(_storageKey)));

  static DateTime? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  void restart() {
    final expiresAt = DateTime.now().add(holdDuration);
    state = expiresAt;
    _prefs.setString(_storageKey, expiresAt.toUtc().toIso8601String());
  }

  void ensureActive() {
    final current = state;
    if (current != null && current.isAfter(DateTime.now())) {
      return;
    }

    restart();
  }

  void syncServerExpiration(String? expiresAt) {
    final parsed = _decode(expiresAt);
    if (parsed == null) {
      clear();
      return;
    }

    state = parsed;
    _prefs.setString(_storageKey, parsed.toUtc().toIso8601String());
  }

  void clear() {
    state = null;
    _prefs.remove(_storageKey);
  }
}

class OrderCartNotifier extends StateNotifier<List<OrderCartItem>> {
  static const _storageKey = 'order_cart_items_v1';

  final SharedPreferences _prefs;
  final Ref _ref;

  OrderCartNotifier(this._prefs, this._ref)
      : super(OrderCartItem.decodeList(_prefs.getString(_storageKey)));

  int get totalQuantity =>
      state.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      state.fold<double>(0, (sum, item) => sum + item.lineTotal);

  /// Adds only quantities that are valid for the current ticket constraints.
  ///
  /// Returns whether at least one cart line was added or increased. The event
  /// screen uses this to avoid confirming a selection that became unavailable
  /// between rendering and tapping the action.
  bool addSelection({
    required Event event,
    required String slotId,
    required CalendarDateSlot? selectedSlot,
    required Map<String, int> ticketQuantities,
  }) {
    final holdExpiresAt = _ref.read(orderCartHoldProvider);
    final holdExpired =
        holdExpiresAt != null && !holdExpiresAt.isAfter(DateTime.now());
    final next = holdExpired ? <OrderCartItem>[] : [...state];
    var changed = false;

    for (final entry in ticketQuantities.entries) {
      if (entry.value <= 0) continue;

      final ticket = event.tickets.firstWhere(
        (candidate) => candidate.id == entry.key,
        orElse: () => Ticket(
          id: '',
          name: cachedAppLocalizations().bookingTicketFallback,
          price: 0,
        ),
      );
      if (ticket.id.isEmpty || !ticket.isBookable) continue;

      final minimum = ticket.effectiveMinPerBooking;
      final maximum = ticket.effectiveMaxPerBooking;
      if (entry.value < minimum || entry.value > maximum) continue;

      final item = OrderCartItem(
        event: event,
        slotId: slotId,
        selectedSlot: selectedSlot,
        ticket: ticket,
        quantity: entry.value,
      );
      final index = next.indexWhere((candidate) => candidate.id == item.id);
      final selectedCapacity = selectedSlot?.spotsRemaining;
      final alreadySelectedForSlot = next
          .where(
            (candidate) =>
                candidate.event.id == event.id && candidate.slotId == slotId,
          )
          .fold<int>(0, (sum, candidate) => sum + candidate.quantity);
      final capacityLeft = selectedCapacity == null
          ? null
          : selectedCapacity - alreadySelectedForSlot;
      final allowedIncrement = capacityLeft == null
          ? entry.value
          : capacityLeft >= entry.value
              ? entry.value
              : 0;

      if (allowedIncrement <= 0) continue;

      if (index >= 0) {
        final current = next[index].quantity;
        final merged = (current + allowedIncrement).clamp(minimum, maximum);
        if (merged != current) {
          next[index] = next[index].copyWith(quantity: merged);
          changed = true;
        }
      } else {
        final quantity = allowedIncrement.clamp(0, maximum);
        if (quantity < minimum) continue;
        next.add(item.copyWith(quantity: quantity));
        changed = true;
      }
    }

    _save(next);
    if (next.isNotEmpty) {
      _ref.read(orderCartHoldProvider.notifier).ensureActive();
    }
    return changed;
  }

  void updateQuantity(String itemId, int quantity) {
    final holdExpiresAt = _ref.read(orderCartHoldProvider);
    if (holdExpiresAt != null && !holdExpiresAt.isAfter(DateTime.now())) {
      clear();
      return;
    }

    final next = state
        .map((item) {
          if (item.id != itemId) return item;
          if (quantity <= 0 || !item.ticket.isBookable) {
            return item.copyWith(quantity: 0);
          }

          final minimum = item.ticket.effectiveMinPerBooking;
          final ticketMaximum = item.ticket.effectiveMaxPerBooking;
          final otherSlotQuantity = state
              .where(
                (candidate) =>
                    candidate.id != item.id &&
                    candidate.event.id == item.event.id &&
                    candidate.slotId == item.slotId,
              )
              .fold<int>(0, (sum, candidate) => sum + candidate.quantity);
          final slotRemaining = item.selectedSlot?.spotsRemaining;
          final slotMaximum = slotRemaining == null
              ? ticketMaximum
              : (slotRemaining - otherSlotQuantity).clamp(0, ticketMaximum);
          final maximum =
              slotMaximum < ticketMaximum ? slotMaximum : ticketMaximum;

          if (maximum < minimum || quantity < minimum) {
            return item.copyWith(quantity: 0);
          }
          return item.copyWith(quantity: quantity.clamp(minimum, maximum));
        })
        .where((item) => item.quantity > 0)
        .toList();

    _save(next);
    if (next.isEmpty) {
      _ref.read(orderCartHoldProvider.notifier).clear();
    } else {
      _ref.read(orderCartHoldProvider.notifier).ensureActive();
    }
  }

  void remove(String itemId) {
    final holdExpiresAt = _ref.read(orderCartHoldProvider);
    if (holdExpiresAt != null && !holdExpiresAt.isAfter(DateTime.now())) {
      clear();
      return;
    }

    final next = state.where((item) => item.id != itemId).toList();
    _save(next);
    if (next.isEmpty) {
      _ref.read(orderCartHoldProvider.notifier).clear();
    }
  }

  void clear() {
    _save(const []);
    _ref.read(orderCartHoldProvider.notifier).clear();
  }

  void _save(List<OrderCartItem> items) {
    state = items;
    _prefs.setString(_storageKey, OrderCartItem.encodeList(items));
  }
}
