import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_providers.dart';
import 'package:lehiboo/features/events/presentation/screens/event_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('event list clears on A to B and rejects account A response', () async {
    await _expectEventsListIsolation(returnToAccountA: false);
  });

  test('event list rejects deferred A to B to A responses', () async {
    await _expectEventsListIsolation(returnToAccountA: true);
  });

  test('map event feed clears and rejects A to B to A responses', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingEventsRepository();
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
    final subscription = container.listen(
      eventsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    auth.setUser(_accountB);
    var switched = container.read(eventsProvider);
    expect(switched.isLoading, isTrue);
    expect(switched.valueOrNull, isNull);
    expect(repository.requests, hasLength(2));

    auth.setUser(_accountA);
    switched = container.read(eventsProvider);
    expect(switched.isLoading, isTrue);
    expect(switched.valueOrNull, isNull);
    expect(repository.requests, hasLength(3));

    repository.requests[2].complete(_eventsResult('active-map-a'));
    await pumpEventQueue();
    expect(
      container.read(eventsProvider).requireValue.events.single.id,
      'active-map-a',
    );

    repository.requests[1].complete(_eventsResult('stale-map-b'));
    repository.requests[0].complete(_eventsResult('stale-map-a'));
    await pumpEventQueue();
    expect(
      container.read(eventsProvider).requireValue.events.single.id,
      'active-map-a',
    );
  });
}

Future<void> _expectEventsListIsolation({
  required bool returnToAccountA,
}) async {
  final repository = _PendingEventsRepository();
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
  final provider = eventsListProvider(const EventsListParams());
  final subscription = container.listen(
    provider,
    (_, __) {},
    fireImmediately: true,
  );
  addTearDown(subscription.close);

  expect(repository.requests, hasLength(1));
  auth.setUser(_accountB);
  var switched = container.read(provider);
  expect(switched.isLoading, isTrue);
  expect(switched.valueOrNull, isNull);
  expect(repository.requests, hasLength(2));

  var activeRequestIndex = 1;
  if (returnToAccountA) {
    auth.setUser(_accountA);
    switched = container.read(provider);
    expect(switched.isLoading, isTrue);
    expect(switched.valueOrNull, isNull);
    expect(repository.requests, hasLength(3));
    activeRequestIndex = 2;
  }

  repository.requests[activeRequestIndex].complete(
    _eventsResult('active-session'),
  );
  await pumpEventQueue();
  expect(
    container.read(provider).requireValue.map((activity) => activity.id),
    ['active-session'],
  );

  for (var index = 0; index < activeRequestIndex; index++) {
    repository.requests[index].complete(_eventsResult('stale-$index'));
  }
  await pumpEventQueue();
  expect(
    container.read(provider).requireValue.map((activity) => activity.id),
    ['active-session'],
  );
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

class _PendingEventsRepository implements EventRepository {
  final requests = <Completer<EventsResult>>[];

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
    final request = Completer<EventsResult>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

EventsResult _eventsResult(String id) {
  final startsAt = DateTime(2030, 2, 1, 10);
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
    currentPage: 1,
    totalPages: 1,
    totalItems: 1,
    hasNext: false,
    hasPrev: false,
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
