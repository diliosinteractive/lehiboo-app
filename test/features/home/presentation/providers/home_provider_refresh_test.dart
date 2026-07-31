import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/data/models/home_feed_response_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';

class _CategoriesRepository implements EventRepository {
  List<EventCategoryDto> categories = const [
    EventCategoryDto(id: 1, name: 'Initial', slug: 'initial'),
  ];
  Object? error;
  int calls = 0;

  @override
  Future<List<EventCategoryDto>> getCategories({bool homeOnly = false}) async {
    calls++;
    final currentError = error;
    if (currentError != null) throw currentError;
    return categories;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingAuthRepository implements AuthRepository {
  final Completer<bool> _authentication = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authentication.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser? user)
      : super(_PendingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser? user) {
    state = AuthState(
      status:
          user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
      user: user,
    );
  }
}

class _StaticUserLocationNotifier extends UserLocationNotifier {
  @override
  Future<void> refresh() => Future.value();
}

class _HomeFeedRepository implements EventRepository {
  final requests = <Completer<HomeFeedDataDto>>[];

  @override
  Future<HomeFeedDataDto> getHomeFeed({
    double? lat,
    double? lng,
    int? radius,
    int? limit,
  }) {
    final request = Completer<HomeFeedDataDto>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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

const _accountA = HbUser(
  id: 'home-user-a',
  email: 'a@example.test',
  displayName: 'A',
);

const _accountB = HbUser(
  id: 'home-user-b',
  email: 'b@example.test',
  displayName: 'B',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('home feed cache and late responses are isolated by account', () async {
    const userA = HbUser(
      id: 'home-user-a',
      email: 'a@example.test',
      displayName: 'A',
    );
    const userB = HbUser(
      id: 'home-user-b',
      email: 'b@example.test',
      displayName: 'B',
    );
    final repository = _HomeFeedRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, userA);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
        userLocationProvider.overrideWith(
          (ref) => _StaticUserLocationNotifier(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      homeFeedProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final accountAFuture =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    expect(repository.requests, hasLength(1));

    auth.setUser(userB);
    container.read(homeFeedProvider);
    final accountBFuture =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    expect(repository.requests, hasLength(2));
    expect(container.read(homeFeedProvider).hasValue, isFalse);

    repository.requests.last.complete(
      const HomeFeedDataDto(locationProvided: true),
    );
    await accountBFuture;
    expect(
      container.read(homeFeedProvider).requireValue.locationProvided,
      isTrue,
    );

    repository.requests.first.complete(
      const HomeFeedDataDto(locationProvided: false),
    );
    await accountAFuture;
    await pumpEventQueue();

    expect(
        container.read(homeFeedProvider).requireValue.locationProvided, true);
  });

  test('home feed rejects A to B to A late responses', () async {
    final repository = _HomeFeedRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
        userLocationProvider.overrideWith(
          (ref) => _StaticUserLocationNotifier(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      homeFeedProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final firstAFuture =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    expect(repository.requests, hasLength(1));

    auth.setUser(_accountB);
    container.read(homeFeedProvider);
    final accountBFuture =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    expect(repository.requests, hasLength(2));

    auth.setUser(_accountA);
    container.read(homeFeedProvider);
    final secondAFuture =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    expect(repository.requests, hasLength(3));

    repository.requests[2].complete(
      const HomeFeedDataDto(locationProvided: true),
    );
    await secondAFuture;
    expect(
      container.read(homeFeedProvider).requireValue.locationProvided,
      isTrue,
    );

    repository.requests[1].complete(
      const HomeFeedDataDto(locationProvided: false),
    );
    repository.requests[0].complete(
      const HomeFeedDataDto(locationProvided: false),
    );
    await Future.wait([firstAFuture, accountBFuture]);
    await pumpEventQueue();

    expect(
      container.read(homeFeedProvider).requireValue.locationProvided,
      isTrue,
    );
  });

  test('account switch synchronously blanks feed and derived activities',
      () async {
    final repository = _HomeFeedRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
        userLocationProvider.overrideWith(
          (ref) => _StaticUserLocationNotifier(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscriptions = [
      container.listen(homeFeedProvider, (_, __) {}, fireImmediately: true),
      container.listen(
        homeTodayActivitiesProvider,
        (_, __) {},
        fireImmediately: true,
      ),
      container.listen(
        homeTomorrowActivitiesProvider,
        (_, __) {},
        fireImmediately: true,
      ),
      container.listen(
        homeActivitiesProvider,
        (_, __) {},
        fireImmediately: true,
      ),
    ];
    addTearDown(() {
      for (final subscription in subscriptions) {
        subscription.close();
      }
    });

    final accountALoad =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    final event = _homeFeedEvent('account-a-private-event');
    repository.requests.single.complete(
      HomeFeedDataDto(
        today: [event],
        tomorrow: [event],
        recommended: [event],
      ),
    );
    await accountALoad;
    expect(
        container.read(homeTodayActivitiesProvider).requireValue, isNotEmpty);
    expect(
      container.read(homeTomorrowActivitiesProvider).requireValue,
      isNotEmpty,
    );
    expect(container.read(homeActivitiesProvider).requireValue, isNotEmpty);

    auth.setUser(_accountB);
    container.read(homeFeedProvider);

    expect(container.read(homeFeedProvider).hasValue, isFalse);
    expect(container.read(homeTodayActivitiesProvider).hasValue, isFalse);
    expect(container.read(homeTomorrowActivitiesProvider).hasValue, isFalse);
    expect(container.read(homeActivitiesProvider).hasValue, isFalse);

    repository.requests.last.complete(const HomeFeedDataDto());
    await container.read(homeFeedProvider.notifier).waitForInitialLoad();
  });

  test('home feed refresh retains data and reports its API failure', () async {
    final repository = _HomeFeedRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWithValue(null),
        eventRepositoryProvider.overrideWithValue(repository),
        userLocationProvider.overrideWith(
          (ref) => _StaticUserLocationNotifier(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      homeFeedProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final initialLoad =
        container.read(homeFeedProvider.notifier).waitForInitialLoad();
    repository.requests.single.complete(
      const HomeFeedDataDto(locationProvided: true),
    );
    await initialLoad;

    final refresh = container.read(homeFeedProvider.notifier).refresh();
    repository.requests.last.completeError(StateError('refresh failed'));
    await expectLater(refresh, throwsA(isA<StateError>()));

    final state = container.read(homeFeedProvider);
    expect(state.hasError, isTrue);
    expect(state.hasValue, isTrue);
    expect(state.requireValue.locationProvided, isTrue);
  });

  test('nearby activities reject an A to B late response', () async {
    await _expectEventListingIsolation(
      provider: homeNearbyAvailableActivitiesProvider,
      waitForInitialLoad: (container) => container
          .read(homeNearbyAvailableActivitiesProvider.notifier)
          .waitForInitialLoad(),
    );
  });

  test('nearby activities reject A to B to A late responses', () async {
    await _expectEventListingIsolation(
      provider: homeNearbyAvailableActivitiesProvider,
      waitForInitialLoad: (container) => container
          .read(homeNearbyAvailableActivitiesProvider.notifier)
          .waitForInitialLoad(),
      returnToAccountA: true,
    );
  });

  test('new activities reject an A to B late response', () async {
    await _expectEventListingIsolation(
      provider: homeNewActivitiesProvider,
      waitForInitialLoad: (container) => container
          .read(homeNewActivitiesProvider.notifier)
          .waitForInitialLoad(),
    );
  });

  test('new activities reject A to B to A late responses', () async {
    await _expectEventListingIsolation(
      provider: homeNewActivitiesProvider,
      waitForInitialLoad: (container) => container
          .read(homeNewActivitiesProvider.notifier)
          .waitForInitialLoad(),
      returnToAccountA: true,
    );
  });

  test(
    'refresh reports failure while retaining the last successful value',
    () async {
      final repository = _CategoriesRepository();
      final container = ProviderContainer(
        overrides: [
          eventRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        categoriesProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final initial = await container.read(categoriesProvider.future);
      expect(initial.single.name, 'Initial');

      repository.error = StateError('temporary failure');
      await expectLater(
        container.read(categoriesProvider.notifier).refresh(),
        throwsA(isA<StateError>()),
      );

      final failedRefresh = container.read(categoriesProvider);
      expect(failedRefresh.hasError, isTrue);
      expect(failedRefresh.hasValue, isTrue);
      expect(failedRefresh.requireValue.single.name, 'Initial');

      repository
        ..error = null
        ..categories = const [
          EventCategoryDto(id: 2, name: 'Recovered', slug: 'recovered'),
        ];
      await container.read(categoriesProvider.notifier).refresh();

      final recovered = container.read(categoriesProvider);
      expect(recovered.hasError, isFalse);
      expect(recovered.requireValue.single.name, 'Recovered');
      expect(repository.calls, 3);
    },
  );

  testWidgets('manual refresh replaces the active 15-minute timer', (
    tester,
  ) async {
    final repository = _CategoriesRepository();
    late WidgetRef homeRef;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventRepositoryProvider.overrideWithValue(repository),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            homeRef = ref;
            final categories = ref.watch(categoriesProvider);
            return MaterialApp(
              home: Text('${categories.valueOrNull?.length ?? 0}'),
            );
          },
        ),
      ),
    );
    await tester.pump();
    expect(repository.calls, 1);

    await tester.pump(const Duration(minutes: 5));
    await homeRef.read(categoriesProvider.notifier).refresh();
    expect(repository.calls, 2);

    // The original timer would expire here if refresh had not cancelled it.
    await tester.pump(const Duration(minutes: 10));
    await tester.pump();
    expect(repository.calls, 2);

    await tester.pump(const Duration(minutes: 5));
    await tester.pump();
    expect(repository.calls, 3);
  });

  testWidgets('an unobserved cached provider expires without polling', (
    tester,
  ) async {
    final repository = _CategoriesRepository();
    final container = ProviderContainer(
      overrides: [
        eventRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    Widget scope(Widget child) {
      return UncontrolledProviderScope(
        container: container,
        child: child,
      );
    }

    await tester.pumpWidget(
      scope(
        Consumer(
          builder: (context, ref, _) {
            ref.watch(categoriesProvider);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await container.read(categoriesProvider.future);
    expect(repository.calls, 1);

    await tester.pumpWidget(scope(const SizedBox.shrink()));
    await tester.pump(homeDataFreshness);
    await tester.pump();

    expect(repository.calls, 1);
    expect(container.exists(categoriesProvider), isFalse);

    await tester.pump(homeDataFreshness);
    expect(repository.calls, 1);
  });
}

Future<void> _expectEventListingIsolation({
  required ProviderListenable<AsyncValue<List<Activity>>> provider,
  required Future<void> Function(ProviderContainer container)
      waitForInitialLoad,
  bool returnToAccountA = false,
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
      userLocationProvider.overrideWith(
        (ref) => _StaticUserLocationNotifier(),
      ),
      homeNowProvider.overrideWithValue(() => DateTime(2030)),
    ],
  );
  addTearDown(container.dispose);
  final subscription = container.listen(
    provider,
    (_, __) {},
    fireImmediately: true,
  );
  addTearDown(subscription.close);

  final staleFutures = <Future<void>>[
    waitForInitialLoad(container),
  ];
  expect(repository.requests, hasLength(1));

  auth.setUser(_accountB);
  container.read(provider);
  final accountBFuture = waitForInitialLoad(container);
  expect(repository.requests, hasLength(2));

  late final Future<void> activeFuture;
  if (returnToAccountA) {
    staleFutures.add(accountBFuture);
    auth.setUser(_accountA);
    container.read(provider);
    activeFuture = waitForInitialLoad(container);
    expect(repository.requests, hasLength(3));
  } else {
    activeFuture = accountBFuture;
  }

  repository.requests.last.complete(_eventsResult('active-session'));
  await activeFuture;
  expect(container.read(provider).requireValue.single.id, 'active-session');

  for (var index = 0; index < repository.requests.length - 1; index++) {
    repository.requests[index].complete(_eventsResult('stale-$index'));
  }
  await Future.wait(staleFutures);
  await pumpEventQueue();

  expect(
    container.read(provider).requireValue.map((activity) => activity.id),
    ['active-session'],
  );
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

EventDto _homeFeedEvent(String id) {
  return EventDto(
    id: 1,
    uuid: id,
    title: id,
    slug: id,
    dates: const EventDatesDto(
      startDate: '2030-02-01',
      endDate: '2030-02-01',
      startTime: '10:00',
      endTime: '12:00',
    ),
  );
}
