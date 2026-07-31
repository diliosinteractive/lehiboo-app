import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/reminders/data/repositories/reminders_repository_impl.dart';
import 'package:lehiboo/features/reminders/domain/entities/reminder.dart';
import 'package:lehiboo/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:lehiboo/features/reminders/presentation/providers/reminders_provider.dart';
import 'package:lehiboo/features/trip_plans/domain/entities/trip_plan.dart';
import 'package:lehiboo/features/trip_plans/domain/repositories/trip_plans_repository.dart';
import 'package:lehiboo/features/trip_plans/presentation/providers/trip_plans_provider.dart';

void main() {
  test('failed trip plan actions propagate and preserve the loaded list',
      () async {
    final repository = _TripPlansRepository();
    final container = _container(
      tripPlansRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);

    final notifier = container.read(tripPlansProvider.notifier);
    await notifier.loadTripPlans();
    repository.failure = Exception('trip action failed');

    await expectLater(
      notifier.updateTripPlan(uuid: _tripPlan.uuid, title: 'Changed'),
      throwsA(same(repository.failure)),
    );
    expect(container.read(tripPlansProvider).valueOrNull, [_tripPlan]);
    expect(container.read(tripPlansProvider).hasError, isFalse);

    await expectLater(
      notifier.deleteTripPlan(_tripPlan.uuid),
      throwsA(same(repository.failure)),
    );
    expect(container.read(tripPlansProvider).valueOrNull, [_tripPlan]);
    expect(container.read(tripPlansProvider).hasError, isFalse);
  });

  test('failed reminder deletes propagate and roll back optimistic removal',
      () async {
    final repository = _RemindersRepository();
    final container = _container(
      remindersRepositoryProvider.overrideWithValue(repository),
    );
    addTearDown(container.dispose);

    final notifier = container.read(remindersListProvider.notifier);
    await notifier.loadReminders();
    repository.failure = Exception('reminder action failed');

    await expectLater(
      notifier.deleteReminder(
        eventUuid: _reminder.eventUuid,
        slotUuid: _reminder.id,
      ),
      throwsA(same(repository.failure)),
    );
    expect(container.read(remindersListProvider).valueOrNull, [_reminder]);
    expect(container.read(remindersListProvider).hasError, isFalse);

    await expectLater(
      notifier.deleteAllForEvent(_reminder.eventUuid),
      throwsA(same(repository.failure)),
    );
    expect(container.read(remindersListProvider).valueOrNull, [_reminder]);
    expect(container.read(remindersListProvider).hasError, isFalse);
  });
}

ProviderContainer _container(Override repositoryOverride) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(_LoggedOutAuthRepository()),
      repositoryOverride,
    ],
  );
}

final _tripPlan = TripPlan(
  uuid: 'trip-1',
  title: 'Saturday outing',
  stopsCount: 0,
  stops: [],
  createdAt: DateTime(2026),
);

final _reminder = Reminder(
  id: 'slot-1',
  createdAt: DateTime(2026),
  eventUuid: 'event-1',
  eventSlug: 'event',
  eventTitle: 'Event',
  slotDate: DateTime(2026, 8),
);

class _TripPlansRepository implements TripPlansRepository {
  Object? failure;

  @override
  Future<List<TripPlan>> getTripPlans() async => [_tripPlan];

  @override
  Future<TripPlan> updateTripPlan({
    required String uuid,
    String? title,
    DateTime? plannedDate,
    List<String>? stopsOrder,
  }) async {
    if (failure case final failure?) throw failure;
    return _tripPlan.copyWith(title: title);
  }

  @override
  Future<void> deleteTripPlan(String uuid) async {
    if (failure case final failure?) throw failure;
  }
}

class _RemindersRepository implements RemindersRepository {
  Object? failure;

  @override
  Future<List<Reminder>> getMyReminders({
    int page = 1,
    int perPage = 50,
  }) async =>
      [_reminder];

  @override
  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    if (failure case final failure?) throw failure;
  }

  @override
  Future<int> deleteAllReminders(String eventUuid) async {
    if (failure case final failure?) throw failure;
    return 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LoggedOutAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
