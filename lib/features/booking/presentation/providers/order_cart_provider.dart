import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _OrderCartScopeKind { unknown, guest, account }

class _OrderCartScope {
  const _OrderCartScope._(this.kind, this.accountId);

  const _OrderCartScope.unknown() : this._(_OrderCartScopeKind.unknown, null);

  const _OrderCartScope.guest() : this._(_OrderCartScopeKind.guest, null);

  const _OrderCartScope.account(String accountId)
      : this._(_OrderCartScopeKind.account, accountId);

  final _OrderCartScopeKind kind;
  final String? accountId;

  bool get canReadAndWrite => kind != _OrderCartScopeKind.unknown;

  String get ownerTag => switch (kind) {
        _OrderCartScopeKind.guest => 'guest',
        _OrderCartScopeKind.account => 'account:$accountId',
        _OrderCartScopeKind.unknown => 'unknown',
      };

  String get storageSuffix => switch (kind) {
        _OrderCartScopeKind.guest => 'guest',
        _OrderCartScopeKind.account =>
          'account_${base64Url.encode(utf8.encode(accountId!)).replaceAll('=', '')}',
        _OrderCartScopeKind.unknown => 'unknown',
      };

  @override
  bool operator ==(Object other) =>
      other is _OrderCartScope &&
      other.kind == kind &&
      other.accountId == accountId;

  @override
  int get hashCode => Object.hash(kind, accountId);
}

final _orderCartScopeProvider = Provider<_OrderCartScope>((ref) {
  final auth = ref.watch(authProvider);
  if (auth.status == AuthStatus.authenticated) {
    final accountId = auth.user?.id.trim();
    if (accountId != null && accountId.isNotEmpty) {
      return _OrderCartScope.account(accountId);
    }
    return const _OrderCartScope.unknown();
  }
  if (auth.status == AuthStatus.unauthenticated) {
    return const _OrderCartScope.guest();
  }
  return const _OrderCartScope.unknown();
});

/// Keeps SharedPreferences writes ordered per owner and coalesces stale writes.
///
/// Account and guest data also use different keys. A write already queued by a
/// disposed account-A notifier therefore cannot overwrite account B's cart.
class _OrderCartPersistence {
  _OrderCartPersistence(this._prefs) {
    // v1 values had no owner metadata. Reading them could expose the previous
    // account after an upgrade, so deliberately fail closed and remove them.
    remove(_legacyItemsKey);
    remove(_legacyHoldKey);
  }

  static const _legacyItemsKey = 'order_cart_items_v1';
  static const _legacyHoldKey = 'order_cart_hold_expires_at_v1';

  final SharedPreferences _prefs;
  final Map<String, String?> _desiredValues = {};
  final Map<String, int> _revisions = {};
  final Map<String, Future<void>> _writeTails = {};

  String? read(String key) {
    if (_desiredValues.containsKey(key)) return _desiredValues[key];
    return _prefs.getString(key);
  }

  void write(String key, String value) {
    _desiredValues[key] = value;
    _enqueue(key);
  }

  void remove(String key) {
    _desiredValues[key] = null;
    _enqueue(key);
  }

  void _enqueue(String key) {
    final revision = (_revisions[key] ?? 0) + 1;
    _revisions[key] = revision;
    final previous = _writeTails[key] ?? Future<void>.value();

    Future<void> persistLatest() async {
      if (_revisions[key] != revision) return;
      final value = _desiredValues[key];
      if (value == null) {
        await _prefs.remove(key);
      } else {
        await _prefs.setString(key, value);
      }
    }

    final next = previous.then<void>(
      (_) => persistLatest(),
      onError: (_) => persistLatest(),
    );
    _writeTails[key] = next;
    unawaited(next);
  }
}

final _orderCartPersistenceProvider = Provider<_OrderCartPersistence>((ref) {
  return _OrderCartPersistence(ref.watch(sharedPreferencesProvider));
});

enum _GuestAdoptionPart { cart, hold }

/// Guest data is transferable only after an observed guest -> account
/// transition in this process. A cold start directly into an authenticated
/// account never adopts an unowned/guest value left by an earlier session.
class _GuestCartAdoptionCoordinator {
  _OrderCartScope? _lastStableScope;
  String? _adoptionTarget;
  final Set<_GuestAdoptionPart> _consumed = {};

  bool enterAndConsume(
    _OrderCartScope scope,
    _GuestAdoptionPart part,
  ) {
    if (!scope.canReadAndWrite) return false;

    if (_lastStableScope != scope) {
      final shouldAdopt = _lastStableScope?.kind == _OrderCartScopeKind.guest &&
          scope.kind == _OrderCartScopeKind.account;
      _adoptionTarget = shouldAdopt ? scope.accountId : null;
      _consumed.clear();
      _lastStableScope = scope;
    }

    if (_adoptionTarget != scope.accountId ||
        scope.kind != _OrderCartScopeKind.account ||
        _consumed.contains(part)) {
      return false;
    }
    _consumed.add(part);
    return true;
  }
}

final _guestCartAdoptionCoordinatorProvider =
    Provider<_GuestCartAdoptionCoordinator>((ref) {
  return _GuestCartAdoptionCoordinator();
});

const _cartStoragePrefix = 'order_cart_items_v2_';
const _holdStoragePrefix = 'order_cart_hold_expires_at_v2_';

String _cartStorageKey(_OrderCartScope scope) =>
    '$_cartStoragePrefix${scope.storageSuffix}';

String _holdStorageKey(_OrderCartScope scope) =>
    '$_holdStoragePrefix${scope.storageSuffix}';

String _encodeEnvelope(_OrderCartScope scope, Object? value) => jsonEncode({
      'version': 2,
      'owner': scope.ownerTag,
      'value': value,
    });

Object? _decodeEnvelope(String? raw, _OrderCartScope scope) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic> ||
        decoded['version'] != 2 ||
        decoded['owner'] != scope.ownerTag) {
      return null;
    }
    return decoded['value'];
  } catch (_) {
    return null;
  }
}

final orderCartHoldProvider =
    StateNotifierProvider<OrderCartHoldNotifier, DateTime?>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final scope = ref.watch(_orderCartScopeProvider);
  return OrderCartHoldNotifier._(
    ref,
    ref.watch(_orderCartPersistenceProvider),
    ref.read(_guestCartAdoptionCoordinatorProvider),
    scope,
    ownerSession,
  );
});

final orderCartProvider =
    StateNotifierProvider<OrderCartNotifier, List<OrderCartItem>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final scope = ref.watch(_orderCartScopeProvider);
  return OrderCartNotifier._(
    ref.watch(_orderCartPersistenceProvider),
    ref.read(_guestCartAdoptionCoordinatorProvider),
    scope,
    ref,
    ownerSession,
  );
});

class OrderCartHoldNotifier extends StateNotifier<DateTime?> {
  static const holdDuration = Duration(minutes: 15);

  OrderCartHoldNotifier._(
    this._ref,
    this._persistence,
    _GuestCartAdoptionCoordinator adoptionCoordinator,
    this._scope,
    this._ownerSession,
  ) : super(null) {
    _active = true;
    _ref.onDispose(() => _active = false);
    if (!_scope.canReadAndWrite) return;

    final adoptGuest = adoptionCoordinator.enterAndConsume(
      _scope,
      _GuestAdoptionPart.hold,
    );
    state = _read(_scope);
    if (adoptGuest) {
      const guestScope = _OrderCartScope.guest();
      final guestHold = _read(guestScope);
      _persistence.remove(_holdStorageKey(guestScope));
      if (state == null &&
          guestHold != null &&
          guestHold.isAfter(DateTime.now())) {
        state = guestHold;
        _persist(guestHold);
      }
    }
  }

  final Ref _ref;
  final _OrderCartPersistence _persistence;
  final _OrderCartScope _scope;
  final AuthSessionKey _ownerSession;
  late bool _active;

  bool get _ownsCurrentScope =>
      _active &&
      _scope.canReadAndWrite &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession) &&
      _ref.read(_orderCartScopeProvider) == _scope;

  DateTime? _read(_OrderCartScope scope) {
    final value = _decodeEnvelope(
      _persistence.read(_holdStorageKey(scope)),
      scope,
    );
    if (value is! String) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  void _persist(DateTime expiresAt) {
    _persistence.write(
      _holdStorageKey(_scope),
      _encodeEnvelope(_scope, expiresAt.toUtc().toIso8601String()),
    );
  }

  void restart() {
    if (!_ownsCurrentScope) return;
    final expiresAt = DateTime.now().add(holdDuration);
    state = expiresAt;
    _persist(expiresAt);
  }

  void ensureActive() {
    if (!_ownsCurrentScope) return;
    final current = state;
    if (current != null && current.isAfter(DateTime.now())) return;
    restart();
  }

  void syncServerExpiration(String? expiresAt) {
    if (!_ownsCurrentScope) return;
    final parsed =
        expiresAt == null ? null : DateTime.tryParse(expiresAt)?.toLocal();
    if (parsed == null) {
      clear();
      return;
    }

    state = parsed;
    _persist(parsed);
  }

  void clear() {
    if (!_active) return;
    state = null;
    if (!_ownsCurrentScope) return;
    _persistence.remove(_holdStorageKey(_scope));
  }
}

class OrderCartNotifier extends StateNotifier<List<OrderCartItem>> {
  OrderCartNotifier._(
    this._persistence,
    _GuestCartAdoptionCoordinator adoptionCoordinator,
    this._scope,
    this._ref,
    this._ownerSession,
  ) : super(const []) {
    _active = true;
    _ref.onDispose(() => _active = false);
    if (!_scope.canReadAndWrite) return;

    final adoptGuest = adoptionCoordinator.enterAndConsume(
      _scope,
      _GuestAdoptionPart.cart,
    );
    state = _read(_scope) ?? const [];
    if (adoptGuest) {
      const guestScope = _OrderCartScope.guest();
      final guestItems = _read(guestScope);
      _persistence.remove(_cartStorageKey(guestScope));
      if (state.isEmpty && guestItems != null && guestItems.isNotEmpty) {
        state = guestItems;
        _persist(guestItems);
      }
    }
  }

  final _OrderCartPersistence _persistence;
  final _OrderCartScope _scope;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  late bool _active;

  bool get _ownsCurrentScope =>
      _active &&
      _scope.canReadAndWrite &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession) &&
      _ref.read(_orderCartScopeProvider) == _scope;

  List<OrderCartItem>? _read(_OrderCartScope scope) {
    final value = _decodeEnvelope(
      _persistence.read(_cartStorageKey(scope)),
      scope,
    );
    if (value is! List) return null;
    try {
      return OrderCartItem.decodeList(jsonEncode(value));
    } catch (_) {
      return null;
    }
  }

  void _persist(List<OrderCartItem> items) {
    final encodedItems = jsonDecode(OrderCartItem.encodeList(items));
    _persistence.write(
      _cartStorageKey(_scope),
      _encodeEnvelope(_scope, encodedItems),
    );
  }

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
    if (!_ownsCurrentScope) return false;
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
    if (!_ownsCurrentScope) return;
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
    if (!_ownsCurrentScope) return;
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
    if (!_active) return;
    state = const [];
    if (!_ownsCurrentScope) return;
    _persistence.remove(_cartStorageKey(_scope));
    _ref.read(orderCartHoldProvider.notifier).clear();
  }

  void _save(List<OrderCartItem> items) {
    if (!_ownsCurrentScope) return;
    state = items;
    _persist(items);
  }
}
