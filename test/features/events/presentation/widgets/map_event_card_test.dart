import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/presentation/widgets/map_event_card.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Activity _discoveryActivity({
  required DiscoveryPricingType? pricingType,
  bool? isFree,
  double? priceMin,
  double? priceMax,
}) {
  return Activity(
    id: 'map-discovery-event',
    title: 'Map discovery event',
    slug: 'map-discovery-event',
    description: '',
    discoveryPricingType: pricingType,
    isFree: isFree,
    priceMin: priceMin,
    priceMax: priceMax,
  );
}

Activity _bookingActivity(double price) {
  return Activity(
    id: 'map-booking-event',
    title: 'Map booking event',
    slug: 'map-booking-event',
    description: '',
    isFree: false,
    priceMin: price,
    reservationMode: ReservationMode.lehibooPaid,
  );
}

Future<void> _pumpCard(WidgetTester tester, Activity activity) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isAuthenticatedProvider.overrideWithValue(false),
        authSessionUserIdProvider.overrideWithValue(null),
        favoritesRepositoryProvider.overrideWithValue(
          _FakeFavoritesRepository(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) => Scaffold(
            body: SizedBox(
              width: 320,
              height: 220,
              child: MapEventCard(
                activity: activity,
                ownerSession: ref.watch(authSessionKeyProvider),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('MapEventCard booking pricing', () {
    testWidgets('preserves an API decimal price without rounding or padding', (
      tester,
    ) async {
      await _pumpCard(tester, _bookingActivity(5.5));

      expect(find.text('5,5€'), findsOneWidget);
      expect(find.text('5€'), findsNothing);
      expect(find.text('6€'), findsNothing);
      expect(find.text('5,50€'), findsNothing);
    });
  });

  group('MapEventCard discovery pricing', () {
    testWidgets(
      'shows Gratuit from the authoritative value without numeric prices',
      (tester) async {
        await _pumpCard(
          tester,
          _discoveryActivity(pricingType: DiscoveryPricingType.free),
        );

        expect(find.text('Gratuit'), findsOneWidget);
      },
    );

    testWidgets(
      'does not infer Gratuit from zero prices when classified as paid',
      (tester) async {
        await _pumpCard(
          tester,
          _discoveryActivity(
            pricingType: DiscoveryPricingType.paid,
            isFree: true,
            priceMin: 0,
            priceMax: 0,
          ),
        );

        expect(find.text('Gratuit'), findsNothing);
      },
    );

    testWidgets(
      'does not infer Gratuit when the authoritative value is missing',
      (tester) async {
        await _pumpCard(
          tester,
          _discoveryActivity(
            pricingType: null,
            priceMin: 0,
            priceMax: 0,
          ),
        );

        expect(find.text('Gratuit'), findsNothing);
      },
    );
  });
}
