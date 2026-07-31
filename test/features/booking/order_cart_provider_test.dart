import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/booking/presentation/providers/order_cart_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;
  late _TestAuthNotifier auth;
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    final setup = _createContainer(preferences);
    container = setup.container;
    auth = setup.auth;
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

  test('account switch resets synchronously and restores only the owner cart',
      () {
    auth.setUser(_accountA);
    final accountANotifier = container.read(orderCartProvider.notifier);
    expect(
      accountANotifier.addSelection(
        event: _event(const Ticket(id: 'a-ticket', name: 'A', price: 5.5)),
        slotId: 'slot-1',
        selectedSlot: _slot(remaining: 10),
        ticketQuantities: const {'a-ticket': 1},
      ),
      isTrue,
    );
    expect(container.read(orderCartHoldProvider), isNotNull);

    auth.setUser(_accountB);

    expect(container.read(orderCartProvider), isEmpty);
    expect(container.read(orderCartHoldProvider), isNull);
    expect(
      accountANotifier.addSelection(
        event: _event(const Ticket(id: 'stale', name: 'Stale', price: 99)),
        slotId: 'slot-1',
        selectedSlot: _slot(remaining: 10),
        ticketQuantities: const {'stale': 1},
      ),
      isFalse,
    );
    expect(container.read(orderCartProvider), isEmpty);

    auth.setUser(_accountA);

    expect(container.read(orderCartProvider).single.ticket.id, 'a-ticket');
    expect(container.read(orderCartProvider).single.ticket.price, 5.5);
    expect(container.read(orderCartHoldProvider), isNotNull);
  });

  test('initial auth state cannot expose a persisted account cart or hold', () {
    auth.setUser(_accountA);
    container.read(orderCartProvider.notifier).addSelection(
      event: _event(
        const Ticket(id: 'private', name: 'Private', price: 12.75),
      ),
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticketQuantities: const {'private': 1},
    );

    auth.setInitial();

    expect(container.read(orderCartProvider), isEmpty);
    expect(container.read(orderCartHoldProvider), isNull);

    auth.setUser(_accountB);
    expect(container.read(orderCartProvider), isEmpty);
    expect(container.read(orderCartHoldProvider), isNull);
  });

  test('cold-start rehydration reads only the exact persisted owner', () async {
    auth.setUser(_accountA);
    container.read(orderCartProvider.notifier).addSelection(
      event: _event(
        const Ticket(id: 'persisted-a', name: 'Persisted A', price: 6.5),
      ),
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticketQuantities: const {'persisted-a': 1},
    );
    await _flushAsyncPersistence();
    container.dispose();

    var setup = _createContainer(preferences, initialUser: _accountB);
    container = setup.container;
    auth = setup.auth;
    expect(container.read(orderCartProvider), isEmpty);
    expect(container.read(orderCartHoldProvider), isNull);
    container.dispose();

    setup = _createContainer(preferences, initialUser: _accountA);
    container = setup.container;
    auth = setup.auth;
    expect(container.read(orderCartProvider).single.ticket.id, 'persisted-a');
    expect(container.read(orderCartProvider).single.ticket.price, 6.5);
    expect(container.read(orderCartHoldProvider), isNotNull);
  });

  test('a genuine guest cart is adopted once by the next account', () {
    final guestCart = container.read(orderCartProvider.notifier);
    guestCart.addSelection(
      event: _event(
        const Ticket(id: 'guest-ticket', name: 'Guest', price: 8.25),
      ),
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticketQuantities: const {'guest-ticket': 1},
    );

    auth.setUser(_accountA);

    expect(container.read(orderCartProvider).single.ticket.id, 'guest-ticket');
    expect(container.read(orderCartHoldProvider), isNotNull);

    auth.setGuest();
    expect(container.read(orderCartProvider), isEmpty);
    expect(container.read(orderCartHoldProvider), isNull);

    auth.setUser(_accountB);
    expect(container.read(orderCartProvider), isEmpty);
  });

  test('legacy unowned persistence fails closed', () async {
    final legacyItem = OrderCartItem(
      event: _event(const Ticket(id: 'legacy', name: 'Legacy', price: 5)),
      slotId: 'slot-1',
      selectedSlot: _slot(remaining: 10),
      ticket: const Ticket(id: 'legacy', name: 'Legacy', price: 5),
      quantity: 1,
    );
    await preferences.setString(
      'order_cart_items_v1',
      OrderCartItem.encodeList([legacyItem]),
    );
    await preferences.setString(
      'order_cart_hold_expires_at_v1',
      DateTime.now().add(const Duration(minutes: 10)).toIso8601String(),
    );

    auth.setUser(_accountA);

    expect(container.read(orderCartProvider), isEmpty);
    expect(container.read(orderCartHoldProvider), isNull);
    await Future<void>.delayed(Duration.zero);
    expect(preferences.containsKey('order_cart_items_v1'), isFalse);
    expect(preferences.containsKey('order_cart_hold_expires_at_v1'), isFalse);
  });
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser? initialUser)
      : super(_NeverCompletingAuthRepository(), ref) {
    if (initialUser == null) {
      setGuest();
    } else {
      setUser(initialUser);
    }
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  void setGuest() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setInitial() {
    state = const AuthState();
  }
}

({ProviderContainer container, _TestAuthNotifier auth}) _createContainer(
  SharedPreferences preferences, {
  HbUser? initialUser,
}) {
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, initialUser);
        return auth;
      }),
    ],
  );
  container.read(authProvider);
  return (container: container, auth: auth);
}

Future<void> _flushAsyncPersistence() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

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
