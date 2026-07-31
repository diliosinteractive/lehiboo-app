import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/data/models/search_suggestions_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('filtered results reject A to B to A late responses', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingSearchRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    final subscription = container.listen(
      filteredEventsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final firstANotifier = container.read(filteredEventsProvider.notifier);
    final firstAFuture = firstANotifier.waitForCurrentLoad();
    expect(repository.eventRequests, hasLength(1));
    auth.setUser(_accountB);
    final accountBNotifier = container.read(filteredEventsProvider.notifier);
    final accountBFuture = accountBNotifier.waitForCurrentLoad();
    expect(repository.eventRequests, hasLength(2));
    auth.setUser(_accountA);
    final secondANotifier = container.read(filteredEventsProvider.notifier);
    final secondAFuture = secondANotifier.waitForCurrentLoad();
    expect(repository.eventRequests, hasLength(3));

    repository.eventRequests[2].complete(
      _eventsResult('second-account-a', totalItems: 1),
    );
    await secondAFuture;
    expect(
      container.read(filteredEventsProvider).requireValue.activities.single.id,
      'second-account-a',
    );

    repository.eventRequests[1].complete(
      _eventsResult('stale-account-b', totalItems: 1),
    );
    repository.eventRequests[0].complete(
      _eventsResult('stale-first-account-a', totalItems: 1),
    );
    await Future.wait([firstAFuture, accountBFuture]);
    await pumpEventQueue();

    expect(
      container.read(filteredEventsProvider).requireValue.activities.single.id,
      'second-account-a',
    );
  });

  test('stale selected-event failure cannot start its fallback search',
      () async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingSearchRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    container.read(eventFilterProvider.notifier).selectSearchEvent(
          const SelectedSearchEvent(
            id: 'private-event-a',
            slug: 'private-event-a',
            title: 'Private event A',
          ),
        );
    final subscription = container.listen(
      filteredEventsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final accountANotifier = container.read(filteredEventsProvider.notifier);
    final accountAFuture = accountANotifier.waitForCurrentLoad();
    expect(repository.detailRequests, hasLength(1));

    auth.setUser(_accountB);
    final accountBNotifier = container.read(filteredEventsProvider.notifier);
    final accountBFuture = accountBNotifier.waitForCurrentLoad();
    expect(repository.eventRequests, hasLength(1));

    repository.detailRequests.single.completeError(
      StateError('account A detail failed'),
      StackTrace.current,
    );
    await accountAFuture;
    await pumpEventQueue();
    expect(
      repository.eventRequests,
      hasLength(1),
      reason: 'the stale account-A getEvent must not launch a fallback search',
    );

    repository.eventRequests.single.complete(
      _eventsResult('account-b-result', totalItems: 1),
    );
    await accountBFuture;
    expect(
      container.read(filteredEventsProvider).requireValue.activities.single.id,
      'account-b-result',
    );
  });

  testWidgets('autocomplete rejects a previous account response',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingSearchRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    const request = SearchSuggestionsRequest(
      query: 'concert',
      types: 'event',
    );
    final provider = searchSuggestionsProvider(request);
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(container.read(provider), isA<AsyncLoading<SearchSuggestionsDto>>());
    await tester.pump(const Duration(milliseconds: 251));
    expect(repository.suggestionRequests, hasLength(1));

    auth.setUser(_accountB);
    final accountBLoading = container.read(provider);
    expect(accountBLoading, isA<AsyncLoading<SearchSuggestionsDto>>());
    expect(accountBLoading.hasValue, isFalse);
    await tester.pump(const Duration(milliseconds: 251));
    expect(repository.suggestionRequests, hasLength(2));

    repository.suggestionRequests[1].complete(_suggestions('Account B'));
    repository.suggestionRequests[0].complete(_suggestions('Account A'));
    await tester.pumpAndSettle();

    expect(
        container.read(provider).requireValue.events.single.label, 'Account B');
  });

  testWidgets('autocomplete clears completed data across no-yield A to B to A',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingSearchRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    const request = SearchSuggestionsRequest(
      query: 'concert',
      types: 'event',
    );
    final provider = searchSuggestionsProvider(request);
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await tester.pump(const Duration(milliseconds: 251));
    repository.suggestionRequests.single.complete(_suggestions('First A'));
    await tester.pumpAndSettle();
    expect(
      container.read(provider).requireValue.events.single.label,
      'First A',
    );

    auth.setUser(_accountB);
    auth.setUser(_accountA);

    final secondAccountALoading = container.read(provider);
    expect(secondAccountALoading, isA<AsyncLoading<SearchSuggestionsDto>>());
    expect(
      secondAccountALoading.hasValue,
      isFalse,
      reason: 'the first account-A value belongs to a retired session',
    );

    await tester.pump(const Duration(milliseconds: 251));
    expect(repository.suggestionRequests, hasLength(2));
    repository.suggestionRequests[1].complete(_suggestions('Second A'));
    await tester.pumpAndSettle();

    expect(
      container.read(provider).requireValue.events.single.label,
      'Second A',
    );
  });

  testWidgets('preview count rejects a previous account response',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingSearchRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    const filter = EventFilter(searchQuery: 'concert');
    final provider = filterPreviewCountProvider(filter);
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(container.read(provider), isA<AsyncLoading<int>>());
    await tester.pump(const Duration(milliseconds: 351));
    expect(repository.eventRequests, hasLength(1));

    auth.setUser(_accountB);
    final accountBLoading = container.read(provider);
    expect(accountBLoading, isA<AsyncLoading<int>>());
    expect(accountBLoading.hasValue, isFalse);
    await tester.pump(const Duration(milliseconds: 351));
    expect(repository.eventRequests, hasLength(2));

    repository.eventRequests[1].complete(
      _eventsResult('account-b', totalItems: 22),
    );
    await tester.pumpAndSettle();
    expect(container.read(provider).requireValue, 22);
    repository.eventRequests[0].complete(
      _eventsResult('account-a', totalItems: 11),
    );
    await tester.pumpAndSettle();

    expect(container.read(provider).requireValue, 22);
  });

  testWidgets('preview count clears completed data across no-yield A to B to A',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = _PendingSearchRepository();
    late _TestAuthNotifier auth;
    final container = _container(repository, (notifier) => auth = notifier);
    addTearDown(container.dispose);
    const filter = EventFilter(searchQuery: 'concert');
    final provider = filterPreviewCountProvider(filter);
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await tester.pump(const Duration(milliseconds: 351));
    repository.eventRequests.single.complete(
      _eventsResult('first-account-a', totalItems: 11),
    );
    await tester.pumpAndSettle();
    expect(container.read(provider).requireValue, 11);

    auth.setUser(_accountB);
    auth.setUser(_accountA);

    final secondAccountALoading = container.read(provider);
    expect(secondAccountALoading, isA<AsyncLoading<int>>());
    expect(
      secondAccountALoading.hasValue,
      isFalse,
      reason: 'the first account-A count belongs to a retired session',
    );

    await tester.pump(const Duration(milliseconds: 351));
    expect(repository.eventRequests, hasLength(2));
    repository.eventRequests[1].complete(
      _eventsResult('second-account-a', totalItems: 33),
    );
    await tester.pumpAndSettle();

    expect(container.read(provider).requireValue, 33);
  });
}

ProviderContainer _container(
  EventRepository repository,
  void Function(_TestAuthNotifier notifier) captureAuth,
) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _TestAuthNotifier(ref, _accountA);
        captureAuth(notifier);
        return notifier;
      }),
      eventRepositoryProvider.overrideWithValue(repository),
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

class _PendingSearchRepository implements EventRepository {
  final eventRequests = <Completer<EventsResult>>[];
  final detailRequests = <Completer<Event>>[];
  final suggestionRequests = <Completer<SearchSuggestionsDto>>[];

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
    eventRequests.add(request);
    return request.future;
  }

  @override
  Future<Event> getEvent(String identifier) {
    final request = Completer<Event>();
    detailRequests.add(request);
    return request.future;
  }

  @override
  Future<SearchSuggestionsDto> getSearchSuggestions({
    required String query,
    required List<String> types,
    int limit = 5,
  }) {
    final request = Completer<SearchSuggestionsDto>();
    suggestionRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

EventsResult _eventsResult(String id, {required int totalItems}) {
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
    totalItems: totalItems,
    hasNext: false,
    hasPrev: false,
  );
}

SearchSuggestionsDto _suggestions(String label) {
  return SearchSuggestionsDto(
    events: [
      SearchSuggestionItemDto(
        type: 'event',
        id: label,
        slug: label,
        label: label,
      ),
    ],
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
