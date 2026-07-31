import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
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
      ],
    );
    addTearDown(container.dispose);

    container.read(eventFilterProvider.notifier).setOnlyFree(true);
    await container.read(filteredEventsProvider.future);

    expect(repository.requestedFreeOnly, isTrue);
  });
}
