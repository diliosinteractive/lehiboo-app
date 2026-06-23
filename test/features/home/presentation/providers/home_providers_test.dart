import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/data/models/event_reference_data_dto.dart';
import 'package:lehiboo/features/events/data/models/home_feed_response_dto.dart';
import 'package:lehiboo/features/events/data/models/search_suggestions_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/popular_city.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

void main() {
  group('homeTodayActivitiesProvider', () {
    test('orders feed events by same-day start time', () async {
      final feed = HomeFeedDataDto(
        today: [
          _feedEvent(
            id: 1,
            slug: 'bar-a-rire-comedy-club',
            title: 'Bar à rire Comedy Club',
            date: '2030-06-23',
            startTime: '20:00',
          ),
          _feedEvent(
            id: 2,
            slug: 'la-nuit-inoubliable',
            title: 'La nuit inoubliable',
            date: '2030-06-23',
            startTime: '10:00',
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          homeFeedProvider.overrideWith(() => _FakeHomeFeedNotifier(feed)),
        ],
      );
      addTearDown(container.dispose);

      final activities =
          await container.read(homeTodayActivitiesProvider.future);

      expect(activities.map((activity) => activity.slug), [
        'la-nuit-inoubliable',
        'bar-a-rire-comedy-club',
      ]);
      expect(
        activities.map((activity) => activity.nextSlot?.startDateTime.hour),
        [10, 20],
      );
    });
  });

  group('homeTomorrowActivitiesProvider', () {
    test('orders feed events by start time', () async {
      final feed = HomeFeedDataDto(
        tomorrow: [
          _feedEvent(
            id: 1,
            slug: 'tomorrow-late',
            title: 'Tomorrow late',
            date: '2030-06-24',
            startTime: '20:00',
          ),
          _feedEvent(
            id: 2,
            slug: 'tomorrow-early',
            title: 'Tomorrow early',
            date: '2030-06-24',
            startTime: '10:00',
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          homeFeedProvider.overrideWith(() => _FakeHomeFeedNotifier(feed)),
        ],
      );
      addTearDown(container.dispose);

      final activities =
          await container.read(homeTomorrowActivitiesProvider.future);

      expect(activities.map((activity) => activity.slug), [
        'tomorrow-early',
        'tomorrow-late',
      ]);
    });
  });

  group('homeNewActivitiesProvider', () {
    test('sorts all fetched candidates before limiting to ten cards', () async {
      final baseDate = DateTime.now().add(const Duration(days: 10));
      final repository = _FakeEventRepository([
        _event(
            id: 'excluded-late',
            startsAt: baseDate.add(const Duration(days: 30))),
        _event(id: 'day-10', startsAt: baseDate.add(const Duration(days: 10))),
        _event(id: 'day-11', startsAt: baseDate.add(const Duration(days: 11))),
        _event(id: 'day-12', startsAt: baseDate.add(const Duration(days: 12))),
        _event(id: 'day-13', startsAt: baseDate.add(const Duration(days: 13))),
        _event(id: 'day-14', startsAt: baseDate.add(const Duration(days: 14))),
        _event(id: 'day-15', startsAt: baseDate.add(const Duration(days: 15))),
        _event(id: 'day-16', startsAt: baseDate.add(const Duration(days: 16))),
        _event(id: 'day-17', startsAt: baseDate.add(const Duration(days: 17))),
        _event(id: 'day-18', startsAt: baseDate.add(const Duration(days: 18))),
        _event(id: 'day-05', startsAt: baseDate.add(const Duration(days: 5))),
      ]);
      final container = ProviderContainer(
        overrides: [
          eventRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final activities = await container.read(homeNewActivitiesProvider.future);

      expect(activities.map((activity) => activity.id), [
        'day-05',
        'day-10',
        'day-11',
        'day-12',
        'day-13',
        'day-14',
        'day-15',
        'day-16',
        'day-17',
        'day-18',
      ]);
      expect(repository.requestedSort, 'published_at');
      expect(repository.requestedOrder, 'desc');
    });
  });

  group('sortActivitiesChronologically', () {
    test('orders activities by next slot start date and keeps null dates last',
        () {
      final early = _activity(
        id: 'early',
        startsAt: DateTime(2026, 6, 7, 10),
      );
      final sameDateFirst = _activity(
        id: 'same-date-first',
        startsAt: DateTime(2026, 6, 8, 14),
      );
      final sameDateSecond = _activity(
        id: 'same-date-second',
        startsAt: DateTime(2026, 6, 8, 14),
      );
      final late = _activity(
        id: 'late',
        startsAt: DateTime(2026, 6, 10, 18),
      );
      final noSlot = _activity(id: 'no-slot');

      final sorted = sortActivitiesChronologically([
        late,
        sameDateFirst,
        noSlot,
        early,
        sameDateSecond,
      ]);

      expect(
        sorted.map((activity) => activity.id),
        [
          'early',
          'same-date-first',
          'same-date-second',
          'late',
          'no-slot',
        ],
      );
    });
  });
}

Activity _activity({
  required String id,
  DateTime? startsAt,
}) {
  return Activity(
    id: id,
    title: id,
    slug: id,
    description: '',
    nextSlot: startsAt == null
        ? null
        : Slot(
            id: '$id-slot',
            activityId: id,
            startDateTime: startsAt,
            endDateTime: startsAt.add(const Duration(hours: 2)),
          ),
  );
}

Event _event({
  required String id,
  required DateTime startsAt,
}) {
  return Event.minimal(
    id: id,
    slug: id,
    title: id,
    organizerId: 'organizer',
    organizerName: 'Organizer',
  ).copyWith(
    startDate: startsAt,
    endDate: startsAt.add(const Duration(hours: 2)),
  );
}

EventDto _feedEvent({
  required int id,
  required String slug,
  required String title,
  required String date,
  required String startTime,
}) {
  return EventDto(
    id: id,
    uuid: slug,
    title: title,
    slug: slug,
    dates: EventDatesDto(
      startDate: date,
      endDate: date,
      startTime: startTime,
      endTime: '23:00',
    ),
  );
}

class _FakeHomeFeedNotifier extends HomeFeedNotifier {
  _FakeHomeFeedNotifier(this.feed);

  final HomeFeedDataDto feed;

  @override
  Future<HomeFeedDataDto> build() async => feed;
}

class _FakeEventRepository implements EventRepository {
  _FakeEventRepository(this.events);

  final List<Event> events;
  String? requestedSort;
  String? requestedOrder;

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
    requestedSort = sort;
    requestedOrder = order;
    return EventsResult(
      events: events,
      currentPage: 1,
      totalPages: 1,
      totalItems: events.length,
      hasNext: false,
      hasPrev: false,
    );
  }

  @override
  Future<List<City>> getCities() => throw UnimplementedError();

  @override
  Future<List<PopularCity>> getFeaturedCities({bool fallback = false}) =>
      throw UnimplementedError();

  @override
  Future<Event> getEvent(String identifier) => throw UnimplementedError();

  @override
  Future<Event> verifyEventPassword(String identifier, String password) =>
      throw UnimplementedError();

  @override
  Future<List<EventCategoryDto>> getCategories() => throw UnimplementedError();

  @override
  Future<List<ThematiqueDto>> getThematiques() => throw UnimplementedError();

  @override
  Future<HomeFeedDataDto> getHomeFeed({
    double? lat,
    double? lng,
    int? radius,
    int? limit,
  }) async =>
      const HomeFeedDataDto();

  @override
  Future<FiltersResponseDto> getFilters() => throw UnimplementedError();

  @override
  Future<EventReferenceDataDto> getEventReferenceData({
    bool onlyOnline = true,
  }) =>
      throw UnimplementedError();

  @override
  Future<SearchSuggestionsDto> getSearchSuggestions({
    required String query,
    required List<String> types,
    int limit = 5,
  }) =>
      throw UnimplementedError();
}
