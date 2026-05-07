import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import '../../domain/entities/reminder.dart';
import '../../data/repositories/reminders_repository_impl.dart';
import '../../domain/repositories/reminders_repository.dart';

// ---------------------------------------------------------------------------
// Event-level provider: which slots does the user have reminders for?
// ---------------------------------------------------------------------------

/// Returns the set of slot UUIDs the user has reminders for on [eventUuid].
/// Used by the event detail screen to show toggle states.
final eventRemindersProvider =
    AutoDisposeFutureProviderFamily<Set<String>, String>(
        (ref, eventUuid) async {
  final repo = ref.watch(remindersRepositoryProvider);
  final slotIds = await repo.getEventReminders(eventUuid);
  return slotIds.toSet();
});

// ---------------------------------------------------------------------------
// List provider: "Mes Rappels" screen
// ---------------------------------------------------------------------------

final remindersListProvider =
    StateNotifierProvider<RemindersListNotifier, AsyncValue<List<Reminder>>>(
        (ref) {
  final repo = ref.watch(remindersRepositoryProvider);
  return RemindersListNotifier(repo, ref);
});

class RemindersListNotifier extends StateNotifier<AsyncValue<List<Reminder>>> {
  final RemindersRepository _repository;
  final Ref _ref;

  RemindersListNotifier(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    loadReminders();
  }

  Future<void> loadReminders() async {
    try {
      state = const AsyncValue.loading();
      final reminders = await _repository.getMyReminders();
      state = AsyncValue.data(reminders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    // Optimistic removal
    final previous = state.valueOrNull ?? [];
    state = AsyncValue.data(
      previous.where((r) => !(r.eventUuid == eventUuid && r.id == slotUuid)).toList(),
    );

    try {
      await _repository.deleteReminder(
        eventUuid: eventUuid,
        slotUuid: slotUuid,
      );
      // Reminder signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
    } catch (e, st) {
      // Rollback
      state = AsyncValue.data(previous);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAllForEvent(String eventUuid) async {
    final previous = state.valueOrNull ?? [];
    state = AsyncValue.data(
      previous.where((r) => r.eventUuid != eventUuid).toList(),
    );

    try {
      await _repository.deleteAllReminders(eventUuid);
      // Reminder signal changed — drop the personalized feed (spec §7).
      _ref.invalidate(personalizedFeedProvider);
    } catch (e, st) {
      state = AsyncValue.data(previous);
      state = AsyncValue.error(e, st);
    }
  }
}
