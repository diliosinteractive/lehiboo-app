import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import '../../domain/entities/reminder.dart';
import '../../data/repositories/reminders_repository_impl.dart';
import '../../domain/repositories/reminders_repository.dart';

// ---------------------------------------------------------------------------
// Event-level provider: which slots does the user have reminders for?
// ---------------------------------------------------------------------------

/// Returns the set of slot UUIDs the user has reminders for on [eventUuid].
/// Used by the event detail screen to show toggle states.
typedef EventRemindersQuery = ({
  AuthSessionKey ownerSession,
  String eventUuid,
});

final eventRemindersProvider =
    AutoDisposeFutureProviderFamily<Set<String>, EventRemindersQuery>(
        (ref, query) async {
  final currentSession = ref.watch(authSessionKeyProvider);
  if (query.ownerSession.accountId == null ||
      !identical(currentSession, query.ownerSession)) {
    return const <String>{};
  }
  final repo = ref.watch(remindersRepositoryProvider);
  final slotIds = await repo.getEventReminders(query.eventUuid);
  if (!identical(ref.read(authSessionKeyProvider), query.ownerSession)) {
    return const <String>{};
  }
  return slotIds.toSet();
});

// ---------------------------------------------------------------------------
// List provider: "Mes Rappels" screen
// ---------------------------------------------------------------------------

final remindersListProvider =
    StateNotifierProvider<RemindersListNotifier, AsyncValue<List<Reminder>>>(
        (ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repo = ref.watch(remindersRepositoryProvider);
  return RemindersListNotifier(
    repo,
    ref,
    ownerSession: ownerSession,
  );
});

class RemindersListNotifier extends StateNotifier<AsyncValue<List<Reminder>>> {
  final RemindersRepository _repository;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  int _loadGeneration = 0;
  int _stateRevision = 0;

  RemindersListNotifier(
    this._repository,
    this._ref, {
    required AuthSessionKey ownerSession,
  })  : _ownerSession = ownerSession,
        super(
          ownerSession.accountId != null
              ? const AsyncValue.loading()
              : const AsyncValue.data([]),
        ) {
    if (ownerSession.accountId != null) loadReminders();
  }

  bool get _ownsSession =>
      mounted &&
      _ownerSession.accountId != null &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession);

  void _publish(AsyncValue<List<Reminder>> next) {
    if (!_ownsSession) return;
    state = next;
    _stateRevision++;
  }

  Future<void> loadReminders() async {
    if (!_ownsSession) return;
    final requestGeneration = ++_loadGeneration;

    try {
      _publish(const AsyncValue.loading());
      final reminders = await _repository.getMyReminders();
      if (!_ownsSession || requestGeneration != _loadGeneration) return;
      _publish(AsyncValue.data(reminders));
    } catch (e, st) {
      if (!_ownsSession || requestGeneration != _loadGeneration) return;
      _publish(AsyncValue.error(e, st));
    }
  }

  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    if (!_ownsSession) return;
    _loadGeneration++;
    // Optimistic removal
    final previous = state.valueOrNull ?? [];
    _publish(AsyncValue.data(
      previous
          .where((r) => !(r.eventUuid == eventUuid && r.id == slotUuid))
          .toList(),
    ));
    final optimisticRevision = _stateRevision;

    try {
      await _repository.deleteReminder(
        eventUuid: eventUuid,
        slotUuid: slotUuid,
      );
      // Reminder signal changed — drop the personalized feed (spec §7).
      if (_ownsSession) _ref.invalidate(personalizedFeedProvider);
    } catch (_) {
      if (!_ownsSession) return;
      // Roll back only if no newer state/account has replaced this snapshot.
      if (_stateRevision == optimisticRevision) {
        _publish(AsyncValue.data(previous));
      }
      rethrow;
    }
  }

  Future<void> deleteAllForEvent(String eventUuid) async {
    if (!_ownsSession) return;
    _loadGeneration++;
    final previous = state.valueOrNull ?? [];
    _publish(AsyncValue.data(
      previous.where((r) => r.eventUuid != eventUuid).toList(),
    ));
    final optimisticRevision = _stateRevision;

    try {
      await _repository.deleteAllReminders(eventUuid);
      // Reminder signal changed — drop the personalized feed (spec §7).
      if (_ownsSession) _ref.invalidate(personalizedFeedProvider);
    } catch (_) {
      if (!_ownsSession) return;
      if (_stateRevision == optimisticRevision) {
        _publish(AsyncValue.data(previous));
      }
      rethrow;
    }
  }
}
