import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
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
    id: 'discovery-event',
    title: 'Discovery event',
    slug: 'discovery-event',
    description: '',
    discoveryPricingType: pricingType,
    isFree: isFree,
    priceMin: priceMin,
    priceMax: priceMax,
  );
}

Future<void> _pumpCard(WidgetTester tester, Activity activity) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isAuthenticatedProvider.overrideWithValue(false),
        favoritesRepositoryProvider.overrideWithValue(
          _FakeFavoritesRepository(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: EventCard(activity: activity),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('EventCard discovery pricing', () {
    testWidgets(
      'shows Gratuit from the authoritative free value without numeric prices',
      (tester) async {
        await _pumpCard(
          tester,
          _discoveryActivity(pricingType: DiscoveryPricingType.free),
        );

        expect(find.text('Gratuit'), findsOneWidget);
      },
    );

    testWidgets(
      'does not infer Gratuit from zero prices when the value is paid',
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
