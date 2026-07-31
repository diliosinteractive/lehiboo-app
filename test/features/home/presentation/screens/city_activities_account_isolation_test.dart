import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/home/presentation/screens/city_detail_screen.dart';

void main() {
  test('account switch clears city results and rejects a stale load-more',
      () async {
    final repository = _PendingCityRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final provider = cityActivitiesProvider('paris');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    repository.requests[0].completer.complete(
      _result('account-a-page-1', page: 1, totalPages: 2),
    );
    await pumpEventQueue();
    expect(
      container.read(provider).requireValue.activities.single.id,
      'account-a-page-1',
    );

    final oldController = container.read(provider.notifier);
    final staleLoadMore = oldController.loadMore();
    expect(repository.requests, hasLength(2));

    auth.setUser(_accountB);
    final switched = container.read(provider);
    expect(switched.isLoading, isTrue);
    expect(switched.valueOrNull, isNull);
    expect(repository.requests, hasLength(3));

    repository.requests[1].completer.complete(
      _result('stale-account-a-page-2', page: 2, totalPages: 2),
    );
    await staleLoadMore;
    await pumpEventQueue();
    expect(container.read(provider).valueOrNull, isNull);

    repository.requests[2].completer.complete(
      _result('account-b-page-1', page: 1, totalPages: 1),
    );
    await pumpEventQueue();
    expect(
      container.read(provider).requireValue.activities.single.id,
      'account-b-page-1',
    );
  });

  test('A to B to A rejects both earlier city responses', () async {
    final repository = _PendingCityRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final provider = cityActivitiesProvider('paris');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    auth.setUser(_accountB);
    expect(container.read(provider).isLoading, isTrue);
    expect(repository.requests, hasLength(2));
    auth.setUser(_accountA);
    final returned = container.read(provider);
    expect(returned.isLoading, isTrue);
    expect(returned.valueOrNull, isNull);
    expect(repository.requests, hasLength(3));

    repository.requests[2].completer.complete(
      _result('second-account-a', page: 1, totalPages: 1),
    );
    await pumpEventQueue();
    expect(
      container.read(provider).requireValue.activities.single.id,
      'second-account-a',
    );

    repository.requests[1].completer.complete(
      _result('stale-account-b', page: 1, totalPages: 1),
    );
    repository.requests[0].completer.complete(
      _result('stale-first-account-a', page: 1, totalPages: 1),
    );
    await pumpEventQueue();
    expect(
      container.read(provider).requireValue.activities.single.id,
      'second-account-a',
    );
  });
}

class _PendingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_PendingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _PendingCityRequest {
  const _PendingCityRequest(this.page, this.completer);

  final int page;
  final Completer<EventsResult> completer;
}

class _PendingCityRepository implements EventRepository {
  final requests = <_PendingCityRequest>[];

  @override
  Future<EventsResult> getEvents({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
    String? categorySlug,
    String? thematique,
    String? city,
    String? location,
    String? dateFrom,
    String? dateTo,
    double? priceMin,
    double? priceMax,
    bool? freeOnly,
    int? cityRadiusKm,
    bool? familyFriendly,
    bool? accessiblePmr,
    bool? onlineOnly,
    bool? inPersonOnly,
    String? publicFilters,
    String? targetAudiences,
    String? eventTag,
    String? specialEvents,
    String? emotions,
    bool? availableOnly,
    String? locationType,
    String? venueType,
    bool? indoor,
    bool? outdoor,
    int? ageMin,
    double? lat,
    double? lng,
    int? radius,
    double? northEastLat,
    double? northEastLng,
    double? southWestLat,
    double? southWestLng,
    bool? lightweight,
    String? sort,
    String? orderBy,
    String? order,
    bool includePast = true,
  }) {
    final completer = Completer<EventsResult>();
    requests.add(_PendingCityRequest(page, completer));
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

EventsResult _result(
  String id, {
  required int page,
  required int totalPages,
}) {
  final startsAt = DateTime(2030, 2, page, 10);
  final event = Event.minimal(
    id: id,
    slug: id,
    title: id,
    organizerId: 'organizer',
    organizerName: 'Organizer',
  ).copyWith(
    startDate: startsAt,
    endDate: startsAt.add(const Duration(hours: 2)),
  );
  return EventsResult(
    events: [event],
    currentPage: page,
    totalPages: totalPages,
    totalItems: totalPages,
    hasNext: page < totalPages,
    hasPrev: page > 1,
  );
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);
