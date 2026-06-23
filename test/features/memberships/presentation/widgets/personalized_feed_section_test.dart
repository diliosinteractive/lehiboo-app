import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/data/models/toggle_favorite_result.dart';
import 'package:lehiboo/features/favorites/domain/entities/favorite_list.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/memberships/data/models/personalized_feed_dto.dart';
import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';
import 'package:lehiboo/features/memberships/presentation/widgets/personalized_feed_section.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

import '../../../../helpers/fake_auth_repository.dart';

void main() {
  testWidgets('hides personalized feed events whose slots are all past',
      (tester) async {
    final now = DateTime.now();
    final view = PersonalizedFeedView(
      raw: PersonalizedFeedDto(
        booked: [
          _event(
            id: 1,
            uuid: 'past-event',
            title: 'Past booking',
            slotDate: now.subtract(const Duration(days: 2)),
          ),
          _event(
            id: 2,
            uuid: 'future-event',
            title: 'Future booking',
            slotDate: now.add(const Duration(days: 2)),
          ),
        ],
      ),
      ordered: buildOrdered(
        PersonalizedFeedDto(
          booked: [
            _event(
              id: 1,
              uuid: 'past-event',
              title: 'Past booking',
              slotDate: now.subtract(const Duration(days: 2)),
            ),
            _event(
              id: 2,
              uuid: 'future-event',
              title: 'Future booking',
              slotDate: now.add(const Duration(days: 2)),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          favoritesRepositoryProvider.overrideWithValue(_FakeFavoritesRepo()),
          personalizedFeedProvider.overrideWith((ref) async => view),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PersonalizedFeedSection(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Past booking'), findsNothing);
    expect(find.text('Future booking'), findsOneWidget);
  });
}

EventDto _event({
  required int id,
  required String uuid,
  required String title,
  required DateTime slotDate,
}) {
  final date = _dateOnly(slotDate);
  return EventDto(
    id: id,
    uuid: uuid,
    title: title,
    slug: uuid,
    slots: [
      {
        'uuid': '$uuid-slot',
        'date': date,
        'start_time': '10:00:00',
        'end_time': '12:00:00',
        'capacity': 10,
        'available_capacity': 10,
      },
    ],
  );
}

String _dateOnly(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

class _FakeFavoritesRepo implements FavoritesRepository {
  @override
  Future<List<Event>> getFavorites({String? listId}) async => const [];

  @override
  Future<ToggleFavoriteResult> addToFavorites(
    String eventUuid, {
    String? listId,
  }) async =>
      const ToggleFavoriteResult(isFavorite: true);

  @override
  Future<void> removeFromFavorites(String eventUuid) async {}

  @override
  Future<bool> isFavorite(String eventUuid) async => false;

  @override
  Future<ToggleFavoriteResult> toggleFavorite(
    String eventUuid, {
    String? listId,
  }) async =>
      const ToggleFavoriteResult(isFavorite: true);

  @override
  Future<void> moveFavoriteToList(String eventUuid, String? listId) async {}

  @override
  Future<List<FavoriteList>> getLists() async => const [];

  @override
  Future<FavoriteList> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) =>
      throw UnimplementedError();

  @override
  Future<FavoriteList> getListDetails(String listId) =>
      throw UnimplementedError();

  @override
  Future<FavoriteList> updateList(
    String listId, {
    String? name,
    String? description,
    String? color,
    String? icon,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteList(String listId) async {}

  @override
  Future<void> reorderLists(List<String> orderedIds) async {}
}
