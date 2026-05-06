import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void addSelection({
    required Event event,
    required String slotId,
    required CalendarDateSlot? selectedSlot,
    required Map<String, int> ticketQuantities,
  }) {
    final holdExpiresAt = _ref.read(orderCartHoldProvider);
    final holdExpired =
        holdExpiresAt != null && !holdExpiresAt.isAfter(DateTime.now());
    final next = holdExpired ? <OrderCartItem>[] : [...state];

    for (final entry in ticketQuantities.entries) {
      if (entry.value <= 0) continue;

      final ticket = event.tickets.firstWhere(
        (candidate) => candidate.id == entry.key,
        orElse: () => const Ticket(id: '', name: 'Billet', price: 0),
      );
      if (ticket.id.isEmpty) continue;

      final item = OrderCartItem(
        event: event,
        slotId: slotId,
        selectedSlot: selectedSlot,
        ticket: ticket,
        quantity: entry.value,
      );
      final index = next.indexWhere((candidate) => candidate.id == item.id);

      if (index >= 0) {
        next[index] = next[index].copyWith(
          quantity: next[index].quantity + item.quantity,
        );
      } else {
        next.add(item);
      }
    }

    _save(next);
    if (next.isNotEmpty) {
      _ref.read(orderCartHoldProvider.notifier).ensureActive();
    }
  }

  void updateQuantity(String itemId, int quantity) {
    final holdExpiresAt = _ref.read(orderCartHoldProvider);
    if (holdExpiresAt != null && !holdExpiresAt.isAfter(DateTime.now())) {
      clear();
      return;
    }

    final normalized = quantity < 0 ? 0 : quantity;
    final next = state
        .map((item) =>
            item.id == itemId ? item.copyWith(quantity: normalized) : item)
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
