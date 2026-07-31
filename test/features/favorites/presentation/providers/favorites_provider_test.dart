import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/data/models/toggle_favorite_result.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';

void main() {
  late Event event;
  late _FavoritesRepository repository;
  late ProviderContainer container;
  late FavoritesNotifier notifier;

  setUp(() async {
    event = Event.minimal(
      id: 'event-123',
      slug: 'event-123',
      title: 'Test event',
    );
    repository = _FavoritesRepository(event);
    container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
        authRepositoryProvider.overrideWithValue(
          _PendingAuthRepository(),
        ),
        isAuthenticatedProvider.overrideWithValue(true),
        favoritesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      favoritesProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    notifier = container.read(favoritesProvider.notifier);
    await notifier.loadFavorites();
  });

  test('toggle failure rolls back optimistic state and propagates error',
      () async {
    final failure = Exception('Favorite service unavailable.');
    final pendingToggle = Completer<ToggleFavoriteResult>();
    repository.pendingToggle = pendingToggle;

    final toggle = notifier.toggleFavorite(event);
    final failureExpectation = expectLater(toggle, throwsA(same(failure)));

    expect(notifier.isFavorite(event.id), isTrue);
    expect(
      container.read(favoritesProvider).valueOrNull?.map((item) => item.id),
      contains(event.id),
    );

    pendingToggle.completeError(failure, StackTrace.current);
    await failureExpectation;

    expect(notifier.isFavorite(event.id), isFalse);
    expect(container.read(favoritesProvider).valueOrNull, isEmpty);
  });

  test('successful toggle returns backend result and keeps server state',
      () async {
    const result = ToggleFavoriteResult(
      isFavorite: true,
      hibonsAwarded: 5,
      newHibonsBalance: 25,
    );
    repository.nextToggleResult = result;

    final actual = await notifier.toggleFavorite(event);

    expect(actual, same(result));
    expect(repository.toggleCalls, 1);
    expect(notifier.isFavorite(event.id), isTrue);
    expect(
      container.read(favoritesProvider).valueOrNull?.single.id,
      event.id,
    );
  });
}

class _PendingAuthRepository implements AuthRepository {
  final Completer<bool> _authentication = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authentication.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FavoritesRepository implements FavoritesRepository {
  _FavoritesRepository(this.event);

  final Event event;
  List<Event> favorites = [];
  Completer<ToggleFavoriteResult>? pendingToggle;
  ToggleFavoriteResult nextToggleResult =
      const ToggleFavoriteResult(isFavorite: true);
  int toggleCalls = 0;

  @override
  Future<List<Event>> getFavorites({String? listId}) async =>
      List<Event>.unmodifiable(favorites);

  @override
  Future<ToggleFavoriteResult> toggleFavorite(
    String eventUuid, {
    String? listId,
  }) async {
    toggleCalls++;
    final pending = pendingToggle;
    final result = pending == null ? nextToggleResult : await pending.future;
    favorites = result.isFavorite
        ? <Event>[event.copyWith(isFavorite: true)]
        : <Event>[];
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
