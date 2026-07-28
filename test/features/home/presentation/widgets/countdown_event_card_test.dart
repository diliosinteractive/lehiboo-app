import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/widgets/countdown_event_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHomeTodayActivitiesNotifier extends HomeTodayActivitiesNotifier {
  _FakeHomeTodayActivitiesNotifier(this.activities);

  final List<Activity> activities;

  @override
  Future<List<Activity>> build() async => activities;
}

Activity _urgentDiscoveryActivity({
  required String id,
  required DiscoveryPricingType pricingType,
  bool? isFree,
  double? priceMin,
  double? priceMax,
}) {
  final start = DateTime.now().add(const Duration(hours: 2));
  return Activity(
    id: id,
    title: id,
    slug: id,
    description: '',
    discoveryPricingType: pricingType,
    isFree: isFree,
    priceMin: priceMin,
    priceMax: priceMax,
    nextSlot: Slot(
      id: '$id-slot',
      activityId: id,
      startDateTime: start,
      endDateTime: start.add(const Duration(hours: 1)),
    ),
  );
}

void main() {
  testWidgets(
    'urgency cards use discovery pricing type instead of zero prices',
    (tester) async {
      final activities = [
        _urgentDiscoveryActivity(
          id: 'authoritatively-free',
          pricingType: DiscoveryPricingType.free,
        ),
        _urgentDiscoveryActivity(
          id: 'authoritatively-paid',
          pricingType: DiscoveryPricingType.paid,
          isFree: true,
          priceMin: 0,
          priceMax: 0,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isAuthenticatedProvider.overrideWithValue(false),
            favoritesRepositoryProvider.overrideWithValue(
              _FakeFavoritesRepository(),
            ),
            homeTodayActivitiesProvider.overrideWith(
              () => _FakeHomeTodayActivitiesNotifier(activities),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('fr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: UrgencySection()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Gratuit'), findsOneWidget);

      // Unmount the cards so their periodic countdown timers are disposed.
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('urgency membership updates as the 12-hour window moves', (
    tester,
  ) async {
    var now = DateTime.now();
    final start = now.add(const Duration(hours: 12, minutes: 30));
    final activity = Activity(
      id: 'moving-window-event',
      title: 'Moving window event',
      slug: 'moving-window-event',
      description: '',
      discoveryPricingType: DiscoveryPricingType.paid,
      nextSlot: Slot(
        id: 'moving-window-slot',
        activityId: 'moving-window-event',
        startDateTime: start,
        endDateTime: start.add(const Duration(hours: 1)),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAuthenticatedProvider.overrideWithValue(false),
          favoritesRepositoryProvider.overrideWithValue(
            _FakeFavoritesRepository(),
          ),
          homeNowProvider.overrideWithValue(() => now),
          homeTodayActivitiesProvider.overrideWith(
            () => _FakeHomeTodayActivitiesNotifier([activity]),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: UrgencySection()),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Moving window event'), findsNothing);

    now = now.add(const Duration(minutes: 31));
    await tester.pump(const Duration(minutes: 1));
    expect(find.text('Moving window event'), findsOneWidget);

    now = start.add(const Duration(minutes: 1));
    await tester.pump(const Duration(minutes: 1));
    expect(find.text('Moving window event'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
