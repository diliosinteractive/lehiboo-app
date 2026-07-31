import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/trip_plans/domain/entities/trip_plan.dart';
import 'package:lehiboo/features/trip_plans/domain/repositories/trip_plans_repository.dart';
import 'package:lehiboo/features/trip_plans/presentation/screens/trip_plan_edit_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets(
      'account switch closes discard dialog, clears draft, and stays invalid',
      (tester) async {
    final repository = _TripPlansRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_activeAccountProvider),
        ),
        tripPlansRepositoryProvider.overrideWithValue(repository),
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
          home: TripPlanEditScreen(planUuid: 'plan-a'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Account A private plan'), findsOneWidget);
    expect(find.text('Account A private stop'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'Account A unsaved private draft',
    );
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(
      find.byKey(const Key('trip-plan-edit-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('Account A private plan'), findsNothing);
    expect(find.text('Account A private stop'), findsNothing);
    expect(find.text('Account A unsaved private draft'), findsNothing);
    expect(repository.updates, isEmpty);

    container.read(_activeAccountProvider.notifier).state = 'account-a';
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('trip-plan-edit-session-invalid')),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNothing);
    expect(repository.updates, isEmpty);
  });
}

class _TripPlansRepository implements TripPlansRepository {
  final List<
      ({
        String uuid,
        String? title,
        DateTime? plannedDate,
        List<String>? stopsOrder,
      })> updates = [];

  @override
  Future<List<TripPlan>> getTripPlans() async => [_plan];

  @override
  Future<TripPlan> updateTripPlan({
    required String uuid,
    String? title,
    DateTime? plannedDate,
    List<String>? stopsOrder,
  }) async {
    updates.add((
      uuid: uuid,
      title: title,
      plannedDate: plannedDate,
      stopsOrder: stopsOrder,
    ));
    return _plan;
  }

  @override
  Future<void> deleteTripPlan(String uuid) async {}
}

final _plan = TripPlan(
  uuid: 'plan-a',
  title: 'Account A private plan',
  plannedDate: null,
  stopsCount: 1,
  stops: const [
    TripStop(
      order: 1,
      eventUuid: 'event-a',
      eventTitle: 'Account A private stop',
      venueName: 'Account A private venue',
    ),
  ],
  createdAt: DateTime(2026),
);
