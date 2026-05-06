import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:shared_preferences/shared_preferences.dart';

final orderCartProvider =
    StateNotifierProvider<OrderCartNotifier, List<OrderCartItem>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OrderCartNotifier(prefs);
});

class OrderCartNotifier extends StateNotifier<List<OrderCartItem>> {
  static const _storageKey = 'order_cart_items_v1';

  final SharedPreferences _prefs;

  OrderCartNotifier(this._prefs)
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
    final next = [...state];

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
  }

  void updateQuantity(String itemId, int quantity) {
    final normalized = quantity < 0 ? 0 : quantity;
    final next = state
        .map((item) =>
            item.id == itemId ? item.copyWith(quantity: normalized) : item)
        .where((item) => item.quantity > 0)
        .toList();

    _save(next);
  }

  void remove(String itemId) {
    _save(state.where((item) => item.id != itemId).toList());
  }

  void clear() {
    _save(const []);
  }

  void _save(List<OrderCartItem> items) {
    state = items;
    _prefs.setString(_storageKey, OrderCartItem.encodeList(items));
  }
}
