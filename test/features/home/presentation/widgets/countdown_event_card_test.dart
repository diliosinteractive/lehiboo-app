import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/widgets/countdown_event_card.dart';

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
            favoritesRepositoryImplProvider.overrideWithValue(
              _FakeFavoritesRepository(),
            ),
            homeTodayActivitiesProvider.overrideWith(
              () => _FakeHomeTodayActivitiesNotifier(activities),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: UrgencySection()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Gratuit'), findsOneWidget);

      // Unmount the cards so their periodic countdown timers are disposed.
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
