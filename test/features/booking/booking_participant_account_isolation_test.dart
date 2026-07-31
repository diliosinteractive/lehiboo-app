import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/screens/booking_payment_screen.dart';
import 'package:lehiboo/features/booking/presentation/screens/booking_participant_screen.dart';
import 'package:lehiboo/features/booking/presentation/screens/booking_slot_selection_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets('buyer PII is cleared and hidden after an account switch',
      (tester) async {
    final container = _container();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: const BookingParticipantScreen(activity: _activity),
        ),
      ),
    );

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(6));
    await tester.enterText(fields.at(0), 'Account A surname');
    await tester.enterText(fields.at(1), 'Account A first name');
    await tester.enterText(fields.at(2), 'account-a-private@example.test');

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pump();

    expect(
      find.byKey(const Key('booking-participant-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('Account A surname'), findsNothing);
    expect(find.text('Account A first name'), findsNothing);
    expect(find.text('account-a-private@example.test'), findsNothing);
  });

  for (final scenario in <({String label, Widget screen, Key invalidKey})>[
    (
      label: 'slot selection',
      screen: const BookingSlotSelectionScreen(activity: _activity),
      invalidKey: const Key('booking-slot-selection-session-invalid'),
    ),
    (
      label: 'payment',
      screen: const BookingPaymentScreen(activity: _activity),
      invalidKey: const Key('booking-payment-session-invalid'),
    ),
  ]) {
    testWidgets('${scenario.label} is invalidated for a replacement account',
        (tester) async {
      final container = _container();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: scenario.screen,
          ),
        ),
      );

      container.read(_activeAccountProvider.notifier).state = 'account-b';
      await tester.pump();

      expect(find.byKey(scenario.invalidKey), findsOneWidget);
    });
  }
}

ProviderContainer _container() => ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_activeAccountProvider),
        ),
        currentUserProvider.overrideWithValue(null),
        bookingRepositoryProvider.overrideWithValue(_BookingRepository()),
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
      ],
    );

const _activity = Activity(
  id: 'event-a',
  slug: 'event-a',
  title: 'Private booking event',
  description: '',
  priceMin: 10,
);

class _BookingRepository implements BookingRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
