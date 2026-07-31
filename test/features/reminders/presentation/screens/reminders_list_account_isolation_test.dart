import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/reminders/data/repositories/reminders_repository_impl.dart';
import 'package:lehiboo/features/reminders/domain/entities/reminder.dart';
import 'package:lehiboo/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:lehiboo/features/reminders/presentation/providers/reminders_provider.dart';
import 'package:lehiboo/features/reminders/presentation/screens/reminders_list_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets(
      'account switch closes delete dialog and cannot delete the old reminder',
      (tester) async {
    final repository = _RemindersRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_activeAccountProvider),
        ),
        remindersRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RemindersListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Account A private reminder'), findsOneWidget);
    final accountANotifier = container.read(remindersListProvider.notifier);
    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(
      find.byKey(const Key('reminders-list-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('Account A private reminder'), findsNothing);
    expect(repository.deletes, isEmpty);

    container.read(_activeAccountProvider.notifier).state = 'account-a';
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('reminders-list-session-invalid')),
      findsOneWidget,
    );
    await accountANotifier.deleteReminder(
      eventUuid: 'event-a',
      slotUuid: 'slot-a',
    );
    await accountANotifier.deleteAllForEvent('event-a');
    expect(repository.deletes, isEmpty);
    expect(repository.deleteAllCalls, 0);
  });
}

class _RemindersRepository implements RemindersRepository {
  final List<({String eventUuid, String slotUuid})> deletes = [];
  int deleteAllCalls = 0;

  @override
  Future<List<Reminder>> getMyReminders(
      {int page = 1, int perPage = 50}) async {
    return [_reminder];
  }

  @override
  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    deletes.add((eventUuid: eventUuid, slotUuid: slotUuid));
  }

  @override
  Future<List<String>> getEventReminders(String eventUuid) async => [];

  @override
  Future<Reminder> createReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    return _reminder;
  }

  @override
  Future<int> deleteAllReminders(String eventUuid) async {
    deleteAllCalls++;
    return 0;
  }
}

final _reminder = Reminder(
  id: 'slot-a',
  createdAt: DateTime(2026),
  eventUuid: 'event-a',
  eventSlug: 'event-a',
  eventTitle: 'Account A private reminder',
  venueName: 'Account A private venue',
  city: 'Private city',
  slotDate: DateTime(2030, 8, 1),
  startTime: '10:00:00',
);
