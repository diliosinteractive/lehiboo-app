import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/features/booking/presentation/providers/order_cart_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('does not add an unavailable or sold-out ticket', () {
    final event = _event(
      const Ticket(
        id: 'sold-out',
        name: 'Standard',
        price: 10,
        isAvailable: false,
        isSoldOut: true,
      ),
    );

    final added = container.read(orderCartProvider.notifier).addSelection(
      event: event,
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticketQuantities: const {'sold-out': 1},
    );

    expect(added, isFalse);
    expect(container.read(orderCartProvider), isEmpty);
  });

  test('does not add a ticket with contradictory booking limits', () {
    final event = _event(
      const Ticket(
        id: 'group',
        name: 'Group (5+)',
        price: 5,
        minPerBooking: 5,
        maxPerBooking: 1,
      ),
    );

    final added = container.read(orderCartProvider.notifier).addSelection(
      event: event,
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticketQuantities: const {'group': 1},
    );

    expect(added, isFalse);
    expect(container.read(orderCartProvider), isEmpty);
  });

  test('does not let merged cart quantities exceed the ticket maximum', () {
    final event = _event(
      const Ticket(
        id: 'standard',
        name: 'Standard',
        price: 10,
        maxPerBooking: 2,
      ),
    );
    final notifier = container.read(orderCartProvider.notifier);

    expect(
      notifier.addSelection(
        event: event,
        slotId: 'slot-1',
        selectedSlot: _slot(remaining: 10),
        ticketQuantities: const {'standard': 2},
      ),
      isTrue,
    );
    expect(
      notifier.addSelection(
        event: event,
        slotId: 'slot-1',
        selectedSlot: _slot(remaining: 10),
        ticketQuantities: const {'standard': 1},
      ),
      isFalse,
    );

    expect(container.read(orderCartProvider).single.quantity, 2);
  });

  test('enforces aggregate capacity across ticket types for one slot', () {
    final event = Event.minimal(
      id: 'event-1',
      slug: 'event-1',
      title: 'Event',
    ).copyWith(
      tickets: const [
        Ticket(id: 'adult', name: 'Adult', price: 10),
        Ticket(id: 'child', name: 'Child', price: 5),
      ],
    );
    final notifier = container.read(orderCartProvider.notifier);

    final added = notifier.addSelection(
      event: event,
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 1),
      ticketQuantities: const {'adult': 1, 'child': 1},
    );

    expect(added, isTrue);
    expect(container.read(orderCartProvider), hasLength(1));
    expect(notifier.totalQuantity, 1);
  });

  test('decrementing below a ticket minimum removes the cart line', () {
    final event = _event(
      const Ticket(
        id: 'group',
        name: 'Group',
        price: 5,
        minPerBooking: 5,
        maxPerBooking: 10,
      ),
    );
    final notifier = container.read(orderCartProvider.notifier);
    notifier.addSelection(
      event: event,
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticketQuantities: const {'group': 5},
    );

    final id = container.read(orderCartProvider).single.id;
    notifier.updateQuantity(id, 4);

    expect(container.read(orderCartProvider), isEmpty);
  });
}

Event _event(Ticket ticket) {
  return Event.minimal(
    id: 'event-1',
    slug: 'event-1',
    title: 'Event',
  ).copyWith(tickets: [ticket]);
}

CalendarDateSlot _slot({required int remaining}) {
  return CalendarDateSlot(
    id: 'slot-1',
    date: DateTime(2026, 8, 1),
    spotsRemaining: remaining,
  );
}
