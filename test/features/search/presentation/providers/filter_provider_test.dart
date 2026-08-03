import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingEventRepository implements EventRepository {
  bool? requestedFreeOnly;

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
  }) async {
    requestedFreeOnly = freeOnly;
    return EventsResult(
      events: const [],
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      hasNext: false,
      hasPrev: false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('paginated results retain and clear a load-more error', () {
    final failure = Exception('page failed');
    final failed = const PaginatedActivities(
      activities: [],
      hasMore: true,
    ).copyWith(loadMoreError: failure);

    expect(failed.loadMoreError, same(failure));
    expect(failed.copyWith().loadMoreError, same(failure));
    expect(failed.copyWith(loadMoreError: null).loadMoreError, isNull);
  });

  test('passes the free-only filter to event search', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = _RecordingEventRepository();
    final container = ProviderContainer(
      overrides: [
        eventRepositoryProvider.overrideWithValue(repository),
        authProvider.overrideWith(
          (ref) => _TestAuthNotifier(ref, _accountA),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(eventFilterProvider.notifier).setOnlyFree(true);
    await container.read(filteredEventsProvider.notifier).waitForCurrentLoad();

    expect(repository.requestedFreeOnly, isTrue);
  });

  test('an exact account switch discards the ephemeral search draft', () {
    SharedPreferences.setMockInitialValues({});
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(eventFilterProvider.notifier);
    notifier.setSearchQuery('Account A private query');
    notifier.setCustomDateRange(
      DateTime(2026, 8, 1),
      DateTime(2026, 8, 2),
    );
    notifier.setLocation(4.05, 9.70, 20);
    notifier.setBoundingBox(4.1, 9.8, 4.0, 9.6);
    notifier.setOrganizer('private-organizer', 'Account A organizer');
    notifier.selectSearchEvent(
      const SelectedSearchEvent(
        id: 'event-a',
        slug: 'event-a',
        title: 'Account A event',
      ),
    );

    auth.setUser(_accountB);

    final filter = container.read(eventFilterProvider);
    expect(filter.searchQuery, isEmpty);
    expect(filter.dateFilterType, isNull);
    expect(filter.startDate, isNull);
    expect(filter.endDate, isNull);
    expect(filter.latitude, isNull);
    expect(filter.longitude, isNull);
    expect(filter.northEastLat, isNull);
    expect(filter.southWestLat, isNull);
    expect(filter.organizerSlug, isNull);
    expect(container.read(selectedSearchEventProvider), isNull);
  });

  test('A to B to A rotates the draft owner and cannot resurrect old state',
      () {
    SharedPreferences.setMockInitialValues({});
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    final accountANotifier = container.read(eventFilterProvider.notifier);
    accountANotifier.setSearchQuery('First A private query');
    accountANotifier.selectSearchEvent(
      const SelectedSearchEvent(
        id: 'event-a',
        slug: 'event-a',
        title: 'First A private event',
      ),
    );

    auth.setUser(_accountB);
    auth.setUser(_accountA);

    final replacementNotifier = container.read(eventFilterProvider.notifier);
    expect(replacementNotifier, isNot(same(accountANotifier)));
    expect(container.read(eventFilterProvider).searchQuery, isEmpty);
    expect(container.read(selectedSearchEventProvider), isNull);
  });

  group('pagination reset on filter change', () {
    late ProviderContainer container;
    late EventFilterNotifier notifier;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = _authenticatedContainer();
      addTearDown(container.dispose);
      notifier = container.read(eventFilterProvider.notifier);
      notifier.setPage(3);
    });

    // filteredEventsProvider appends results when page > 1, so a stale page
    // would keep the previous location's events at the top of the list.
    test('setCity resets the page', () {
      notifier.setCity('lille', 'Lille');

      expect(container.read(eventFilterProvider).page, 1);
    });

    test('setLocation resets the page', () {
      notifier.setLocation(50.62, 3.05, 20);

      expect(container.read(eventFilterProvider).page, 1);
    });

    test('clearCity and clearLocation reset the page', () {
      notifier.clearCity();
      expect(container.read(eventFilterProvider).page, 1);

      notifier.setPage(2);
      notifier.clearLocation();
      expect(container.read(eventFilterProvider).page, 1);
    });

    test('category and date changes reset the page', () {
      notifier.addCategory('concerts');
      expect(container.read(eventFilterProvider).page, 1);

      notifier.setPage(2);
      notifier.setDateFilter(DateFilterType.today);
      expect(container.read(eventFilterProvider).page, 1);
    });

    test('nextPage still advances the cursor', () {
      notifier.resetPagination();
      notifier.nextPage();

      expect(container.read(eventFilterProvider).page, 2);
    });
  });

  group('location intents are mutually exclusive', () {
    late ProviderContainer container;
    late EventFilterNotifier notifier;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = _authenticatedContainer();
      addTearDown(container.dispose);
      notifier = container.read(eventFilterProvider.notifier);
      notifier.setBoundingBox(50.7, 3.2, 50.5, 3.0);
    });

    test('setCity clears the map bounding box and the GPS point', () {
      notifier.setLocation(50.62, 3.05, 20);
      notifier.setBoundingBox(50.7, 3.2, 50.5, 3.0);

      notifier.setCity('valenciennes', 'Valenciennes', radiusKm: 20);

      final filter = container.read(eventFilterProvider);
      expect(filter.citySlug, 'valenciennes');
      expect(filter.latitude, isNull);
      expect(filter.longitude, isNull);
      expect(filter.northEastLat, isNull);
      expect(filter.northEastLng, isNull);
      expect(filter.southWestLat, isNull);
      expect(filter.southWestLng, isNull);
    });

    test('setLocation clears the map bounding box and the city', () {
      notifier.setCity('lille', 'Lille');
      notifier.setBoundingBox(50.7, 3.2, 50.5, 3.0);

      notifier.setLocation(50.35, 3.52, 20);

      final filter = container.read(eventFilterProvider);
      expect(filter.latitude, 50.35);
      expect(filter.longitude, 3.52);
      expect(filter.citySlug, isNull);
      expect(filter.cityName, isNull);
      expect(filter.northEastLat, isNull);
      expect(filter.southWestLng, isNull);
    });
  });
}

/// `eventFilterProvider` est recréé à chaque transition de compte : il lit donc
/// `authProvider`, qu'il faut stubber pour ne pas monter la vraie pile auth.
ProviderContainer _authenticatedContainer() {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) => _TestAuthNotifier(ref, _accountA)),
    ],
  );
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
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
