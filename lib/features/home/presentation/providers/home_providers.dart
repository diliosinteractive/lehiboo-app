import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/city.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../events/domain/entities/popular_city.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/domain/entities/event_submodels.dart';
import '../../../events/domain/repositories/event_repository.dart';
import '../../../events/data/models/event_dto.dart';
import '../../../events/data/mappers/event_to_activity_mapper.dart';
import '../../data/models/mobile_app_config.dart';
import '../../data/datasources/mobile_config_datasource.dart';
import 'user_location_provider.dart';
import '../../../../features/events/data/models/home_feed_response_dto.dart'
    show HomeFeedDataDto;
import '../../../events/data/mappers/event_mapper.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';

/// Maximum age of Home data while the provider remains cached.
///
/// Date-sensitive feeds refresh sooner when the local day changes.
const homeDataFreshness = Duration(minutes: 15);

/// Injectable wall clock used by date-sensitive Home providers and widgets.
final homeNowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

mixin _RefreshableHomeProvider<T> on AutoDisposeAsyncNotifier<T> {
  Future<void>? _refreshInFlight;
  Timer? _freshnessTimer;
  KeepAliveLink? _cacheLink;

  void scheduleBoundedRefresh({
    required DateTime now,
    bool refreshAtMidnight = false,
  }) {
    var delay = homeDataFreshness;
    if (refreshAtMidnight) {
      final nextDay = DateTime(now.year, now.month, now.day + 1);
      final untilNextDay = nextDay.difference(now);
      if (untilNextDay < delay) {
        delay = untilNextDay;
      }
    }

    _cacheLink?.close();
    _cacheLink = ref.keepAlive();
    _freshnessTimer?.cancel();
    _freshnessTimer = Timer(delay, () {
      _cacheLink?.close();
      _cacheLink = null;
      ref.invalidateSelf();
    });
    ref.onDispose(() {
      _freshnessTimer?.cancel();
      _freshnessTimer = null;
      _cacheLink?.close();
      _cacheLink = null;
    });
  }

  Future<void> reload() {
    return _refreshInFlight ??= _reload().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<void> _reload() async {
    ref.invalidateSelf();
    await future;
  }
}

typedef _OwnedHomeLoader<T> = Future<T> Function(
  bool Function() ownsRequest,
);

/// A fresh controller is constructed synchronously at every opaque session
/// boundary. This gives auth-optional event lists a truly blank loading state
/// while the new account is fetched, rather than exposing AsyncNotifier's
/// previous value during dependency-driven recomputation.
abstract class HomeAsyncController<T> extends StateNotifier<AsyncValue<T>> {
  HomeAsyncController(super.state);

  Future<void> waitForInitialLoad();

  Future<void> refresh();
}

class _SessionBoundHomeController<T> extends HomeAsyncController<T> {
  _SessionBoundHomeController({
    required _OwnedHomeLoader<T> load,
    required DateTime Function() now,
    required KeepAliveLink cacheLink,
    required VoidCallback invalidate,
  })  : _loadActivities = load,
        _now = now,
        _cacheLink = cacheLink,
        _invalidate = invalidate,
        super(const AsyncLoading()) {
    _initialLoad = _load();
    unawaited(_initialLoad);
  }

  final _OwnedHomeLoader<T> _loadActivities;
  final DateTime Function() _now;
  final KeepAliveLink _cacheLink;
  final VoidCallback _invalidate;
  late final Future<void> _initialLoad;
  Future<void>? _refreshInFlight;
  Timer? _freshnessTimer;
  int _requestGeneration = 0;

  @override
  Future<void> waitForInitialLoad() => _initialLoad;

  bool _owns(int generation) => mounted && generation == _requestGeneration;

  void _scheduleFreshnessExpiry() {
    final now = _now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    final untilNextDay = nextDay.difference(now);
    final delay =
        untilNextDay < homeDataFreshness ? untilNextDay : homeDataFreshness;
    _freshnessTimer?.cancel();
    _freshnessTimer = Timer(delay, () {
      if (!mounted) return;
      _cacheLink.close();
      _invalidate();
    });
  }

  Future<void> _load({
    bool preservePrevious = false,
    bool rethrowFailure = false,
  }) async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    final previous = state;
    _scheduleFreshnessExpiry();
    state = preservePrevious
        ? AsyncLoading<T>().copyWithPrevious(previous)
        : AsyncLoading<T>();
    try {
      final activities = await _loadActivities(
        () => _owns(requestGeneration),
      );
      if (!_owns(requestGeneration)) return;
      state = AsyncData(activities);
    } catch (error, stackTrace) {
      if (!_owns(requestGeneration)) return;
      state = preservePrevious
          ? AsyncError<T>(
              error,
              stackTrace,
            ).copyWithPrevious(previous)
          : AsyncError<T>(error, stackTrace);
      if (rethrowFailure) {
        Error.throwWithStackTrace(error, stackTrace);
      }
    }
  }

  @override
  Future<void> refresh() {
    return _refreshInFlight ??= _load(
      preservePrevious: true,
      rethrowFailure: true,
    ).whenComplete(() {
      _refreshInFlight = null;
    });
  }

  @override
  void dispose() {
    _requestGeneration++;
    _freshnessTimer?.cancel();
    _cacheLink.close();
    super.dispose();
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Home Feed
// ──────────────────────────────────────────────────────────────────────────────

final homeFeedProvider = StateNotifierProvider.autoDispose<
    HomeAsyncController<HomeFeedDataDto>, AsyncValue<HomeFeedDataDto>>((ref) {
  // The endpoint is auth-optional and can include member-only activities.
  // Reconstructing this controller synchronously prevents account A's feed
  // from remaining visible while account B is loading.
  ref.watch(authSessionKeyProvider);
  final eventRepository = ref.watch(eventRepositoryProvider);
  final userLocation = ref.watch(userLocationProvider).valueOrNull;
  final now = ref.watch(homeNowProvider);
  return _SessionBoundHomeController<HomeFeedDataDto>(
    now: now,
    cacheLink: ref.keepAlive(),
    invalidate: ref.invalidateSelf,
    load: (ownsRequest) async {
      final feed = await eventRepository.getHomeFeed(
        lat: userLocation?.lat,
        lng: userLocation?.lng,
        radius: userLocation != null ? 30 : null,
        limit: 10,
      );
      return feed;
    },
  );
});

// ──────────────────────────────────────────────────────────────────────────────
// Today's Activities (derived from Feed)
// ──────────────────────────────────────────────────────────────────────────────

final homeTodayActivitiesProvider =
    Provider.autoDispose<AsyncValue<List<Activity>>>((ref) {
  return ref.watch(homeFeedProvider).whenData((feed) {
    if (feed.today.isEmpty) return const <Activity>[];
    final events = feed.today.map(EventMapper.toEvent).toList();
    return sortActivitiesChronologically(
      EventToActivityMapper.toActivities(events),
    );
  });
});

// ──────────────────────────────────────────────────────────────────────────────
// Tomorrow's Activities (derived from Feed)
// ──────────────────────────────────────────────────────────────────────────────

final homeTomorrowActivitiesProvider =
    Provider.autoDispose<AsyncValue<List<Activity>>>((ref) {
  return ref.watch(homeFeedProvider).whenData((feed) {
    if (feed.tomorrow.isEmpty) return const <Activity>[];
    final events = feed.tomorrow.map(EventMapper.toEvent).toList();
    return sortActivitiesChronologically(
      EventToActivityMapper.toActivities(events),
    );
  });
});

// ──────────────────────────────────────────────────────────────────────────────
// Nearby Available Activities (location-aware, sorted by next slot)
// ──────────────────────────────────────────────────────────────────────────────

final homeNearbyAvailableActivitiesProvider = StateNotifierProvider.autoDispose<
    _SessionBoundHomeController<List<Activity>>,
    AsyncValue<List<Activity>>>((ref) {
  const nearbyRadiusKm = 30;
  ref.watch(authSessionKeyProvider);
  final eventRepository = ref.watch(eventRepositoryProvider);
  final userLocation = ref.watch(userLocationProvider).valueOrNull;
  final now = ref.watch(homeNowProvider);
  return _SessionBoundHomeController<List<Activity>>(
    now: now,
    cacheLink: ref.keepAlive(),
    invalidate: ref.invalidateSelf,
    load: (ownsRequest) async {
      final requestNow = now();
      if (userLocation != null) {
        try {
          final nearbyActivities = await _fetchAvailableActivities(
            eventRepository,
            requestNow,
            lat: userLocation.lat,
            lng: userLocation.lng,
            radius: nearbyRadiusKm,
          );
          if (!ownsRequest()) return const <Activity>[];
          if (nearbyActivities.isNotEmpty) return nearbyActivities;
        } catch (error) {
          if (!ownsRequest()) return const <Activity>[];
          debugPrint('Nearby activities lookup failed, falling back: $error');
        }
      }
      if (!ownsRequest()) return const <Activity>[];
      return _fetchAvailableActivities(eventRepository, requestNow);
    },
  );
});

Future<List<Activity>> _fetchAvailableActivities(
  EventRepository eventRepository,
  DateTime now, {
  double? lat,
  double? lng,
  int? radius,
}) async {
  const querySize = 50;
  const maxCards = 10;
  // Note: do NOT pass `availableOnly: true` — on prod, crawler-imported
  // discovery events all have `available_capacity: 0`, which the backend
  // treats as unavailable. We filter client-side via _isAvailableForHome
  // so discovery events still surface here.
  final result = await eventRepository.getEvents(
    page: 1,
    perPage: querySize,
    lat: lat,
    lng: lng,
    radius: radius,
    sort: 'date_asc',
  );

  final seenEventIds = <String>{};
  final activities = <Activity>[];

  for (final event in result.events) {
    if (!seenEventIds.add(event.id)) continue;

    final activity = _activityWithNearestAvailableSlot(event, now);
    if (activity == null || activity.nextSlot == null) continue;

    activities.add(activity);
  }

  activities.sort((a, b) => _slotStart(a).compareTo(_slotStart(b)));
  return activities.take(maxCards).toList();
}

Activity? _activityWithNearestAvailableSlot(Event event, DateTime now) {
  final pickedSlot = _nearestAvailableSlot(event, now);
  if (pickedSlot == null) return null;

  return EventToActivityMapper.toActivity(event).copyWith(nextSlot: pickedSlot);
}

Slot? _nearestAvailableSlot(Event event, DateTime now) {
  final slots = event.calendar?.dateSlots ?? const <CalendarDateSlot>[];
  final candidates = slots
      .map((slot) => _activitySlotFromCalendarSlot(event, slot))
      .where((slot) =>
          !_isSlotPast(slot, now) && _isAvailableForHome(event, slot, now))
      .toList()
    ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

  if (candidates.isNotEmpty) return candidates.first;

  if (slots.isNotEmpty) return null;

  final fallback = Slot(
    id: '${event.id}_slot',
    activityId: event.id,
    startDateTime: event.startDate,
    endDateTime: event.endDate,
    capacityTotal: event.totalSeats,
    capacityRemaining: event.availableSeats,
    priceMin: event.buyerPriceFrom,
    priceMax: event.buyerMaxPrice,
    currency: 'EUR',
    indoorOutdoor: event.isIndoor && event.isOutdoor
        ? IndoorOutdoor.both
        : event.isIndoor
            ? IndoorOutdoor.indoor
            : IndoorOutdoor.outdoor,
    status: _eventStatusToSlotStatus(event.status),
  );

  if (_isSlotPast(fallback, now)) return null;
  if (!_isAvailableForHome(event, fallback, now)) return null;
  return fallback;
}

/// Decides whether an (event, slot) pair should appear in home carousels
/// ("Available nearby", "New activities", etc.).
///
/// Background: the prod catalog is dominated by crawler-imported discovery
/// events whose slots have `capacityRemaining == 0` because the venue
/// handles capacity externally — not because they're sold out. The backend's
/// `available_only=1` filter treats them as unavailable, which empties the
/// home on prod. We took over the call here so we can decide what
/// "available" means.
///
/// TODO (you): implement the policy. Available fields you'll likely want:
///   - `event.isDiscovery` (bool) — discovery events: no booking, user just shows up
///   - `event.canAcceptDiscovery` (bool)
///   - `event.bookingMode` — not exposed directly on Event; use isDiscovery
///   - `slot.capacityRemaining` (int?) — null means uncapped, 0 means none left
///   - `slot.status` — 'cancelled', 'sold_out', 'scheduled'
///
/// Question that shapes this: should a sold-out *bookable* event still show
/// up in the home carousel (so users discover it for next time), or be
/// hidden? The answer to that determines the predicate body.
bool _isAvailableForHome(Event event, Slot slot, DateTime now) {
  // TODO: replace this stub with the real policy (~5-10 lines).
  // The stub below mirrors current behaviour (always true) so the app
  // compiles — it will show every future slot including sold-out ones.
  return true;
}

Slot _activitySlotFromCalendarSlot(Event event, CalendarDateSlot slot) {
  final start = _slotDateTime(
    slot.date,
    slot.startTime,
    fallbackDateTime: event.startDate,
  );
  final end = _slotDateTime(
    slot.date,
    slot.endTime,
    fallbackDateTime: event.endDate,
  );
  final normalizedEnd = end.isAfter(start)
      ? end
      : event.duration != null
          ? start.add(event.duration!)
          : start.add(event.endDate.difference(event.startDate));

  return Slot(
    id: slot.id.isNotEmpty ? slot.id : '${event.id}_${start.toIso8601String()}',
    activityId: event.id,
    startDateTime: start,
    endDateTime: normalizedEnd.isAfter(start) ? normalizedEnd : start,
    capacityTotal: slot.totalCapacity ?? event.totalSeats,
    capacityRemaining: slot.spotsRemaining ?? event.availableSeats,
    priceMin: event.buyerPriceFrom,
    priceMax: event.buyerMaxPrice,
    currency: 'EUR',
    indoorOutdoor: event.isIndoor && event.isOutdoor
        ? IndoorOutdoor.both
        : event.isIndoor
            ? IndoorOutdoor.indoor
            : IndoorOutdoor.outdoor,
    status: 'scheduled',
  );
}

DateTime _slotDateTime(
  DateTime date,
  String? time, {
  required DateTime fallbackDateTime,
}) {
  final parsedTime = _parseTimeOfDay(time);
  if (parsedTime != null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsedTime.$1,
      parsedTime.$2,
    );
  }

  if (_isSameDate(date, fallbackDateTime)) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      fallbackDateTime.hour,
      fallbackDateTime.minute,
      fallbackDateTime.second,
    );
  }

  return date;
}

(int, int)? _parseTimeOfDay(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final parts = value.trim().split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return (hour, minute);
}

bool _isSlotPast(Slot slot, DateTime now) =>
    _effectiveSlotEnd(slot).isBefore(now);

DateTime _effectiveSlotEnd(Slot slot) {
  final start = slot.startDateTime;
  final end = slot.endDateTime;
  final isDateOnly = _isMidnight(start) && _isMidnight(end);
  if (isDateOnly && _isSameDate(start, end)) {
    return DateTime(start.year, start.month, start.day, 23, 59, 59, 999);
  }
  return end;
}

bool _isMidnight(DateTime value) =>
    value.hour == 0 &&
    value.minute == 0 &&
    value.second == 0 &&
    value.millisecond == 0 &&
    value.microsecond == 0;

DateTime _slotStart(Activity activity) =>
    activity.nextSlot?.startDateTime ?? DateTime.fromMillisecondsSinceEpoch(0);

bool _isSameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _eventStatusToSlotStatus(EventStatus status) {
  switch (status) {
    case EventStatus.cancelled:
      return 'cancelled';
    case EventStatus.soldOut:
      return 'sold_out';
    default:
      return 'scheduled';
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Event Categories
// ──────────────────────────────────────────────────────────────────────────────

final categoriesProvider = AutoDisposeAsyncNotifierProvider<CategoriesNotifier,
    List<EventCategoryInfo>>(
  CategoriesNotifier.new,
);

final homeCategoriesProvider = AutoDisposeAsyncNotifierProvider<
    HomeCategoriesNotifier, List<EventCategoryInfo>>(
  HomeCategoriesNotifier.new,
);

class CategoriesNotifier
    extends AutoDisposeAsyncNotifier<List<EventCategoryInfo>>
    with _RefreshableHomeProvider<List<EventCategoryInfo>> {
  @override
  Future<List<EventCategoryInfo>> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);
    scheduleBoundedRefresh(now: ref.watch(homeNowProvider)());

    final categories = await eventRepository.getCategories();
    return categories.map(EventCategoryInfo.fromDto).toList();
  }

  Future<void> refresh() => reload();
}

class HomeCategoriesNotifier
    extends AutoDisposeAsyncNotifier<List<EventCategoryInfo>>
    with _RefreshableHomeProvider<List<EventCategoryInfo>> {
  @override
  Future<List<EventCategoryInfo>> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);
    scheduleBoundedRefresh(now: ref.watch(homeNowProvider)());

    final categories = await eventRepository.getCategories(homeOnly: true);
    return categories.map(EventCategoryInfo.fromDto).toList();
  }

  Future<void> refresh() => reload();
}

// ──────────────────────────────────────────────────────────────────────────────
// Cities
// ──────────────────────────────────────────────────────────────────────────────

final homeCitiesProvider =
    AutoDisposeAsyncNotifierProvider<HomeCitiesNotifier, List<City>>(
  HomeCitiesNotifier.new,
);

class HomeCitiesNotifier extends AutoDisposeAsyncNotifier<List<City>>
    with _RefreshableHomeProvider<List<City>> {
  @override
  Future<List<City>> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);
    scheduleBoundedRefresh(now: ref.watch(homeNowProvider)());

    final cities = await eventRepository.getCities();

    final sortedCities = List.of(cities)
      ..sort((a, b) => (b.eventCount ?? 0).compareTo(a.eventCount ?? 0));

    return sortedCities.take(6).map((city) {
      final imageUrl = city.imageUrl ?? _getCityImageUrl(city.name);
      return City(
        id: city.id,
        name: city.name,
        slug: city.slug,
        lat: city.lat,
        lng: city.lng,
        region: city.region,
        description: city.description,
        eventCount: city.eventCount,
        imageUrl: imageUrl,
      );
    }).toList();
  }

  Future<void> refresh() => reload();
}

// ──────────────────────────────────────────────────────────────────────────────
// Popular Cities (curated "Villes populaires" home section)
// ──────────────────────────────────────────────────────────────────────────────

/// Result of [popularCitiesProvider].
///
/// [isFallback] is true when the curated `featured_only=1` set was empty and
/// we silently re-queried `?only_with_upcoming_slots=1` per spec §5.
/// Presentation uses it to swap the section header.
class PopularCitiesResult {
  final List<PopularCity> cities;
  final bool isFallback;

  const PopularCitiesResult({
    required this.cities,
    required this.isFallback,
  });
}

final popularCitiesProvider = AutoDisposeAsyncNotifierProvider<
    PopularCitiesNotifier, PopularCitiesResult>(
  PopularCitiesNotifier.new,
);

class PopularCitiesNotifier
    extends AutoDisposeAsyncNotifier<PopularCitiesResult>
    with _RefreshableHomeProvider<PopularCitiesResult> {
  static const int _maxCards = 6;

  @override
  Future<PopularCitiesResult> build() async {
    final repository = ref.watch(eventRepositoryProvider);
    scheduleBoundedRefresh(now: ref.watch(homeNowProvider)());

    final featured = await repository.getFeaturedCities();
    if (featured.isNotEmpty) {
      return PopularCitiesResult(
        cities: featured.take(_maxCards).toList(),
        isFallback: false,
      );
    }

    final fallback = await repository.getFeaturedCities(fallback: true);
    return PopularCitiesResult(
      cities: fallback.take(_maxCards).toList(),
      isFallback: true,
    );
  }

  Future<void> refresh() => reload();
}

/// Placeholder image fallback for the legacy [homeCitiesProvider]. The curated
/// "Villes populaires" surfaces use [popularCitiesProvider] and the
/// server-provided image instead.
String _getCityImageUrl(String cityName) {
  // Map of known cities to image URLs
  final cityImages = {
    'paris':
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
    'lyon':
        'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=400',
    'marseille':
        'https://images.unsplash.com/photo-1589640512757-e2894e3f9e54?w=400',
    'toulouse':
        'https://images.unsplash.com/photo-1557687790-902ede7ab58c?w=400',
    'nice':
        'https://images.unsplash.com/photo-1504214208698-ea1916a2195a?w=400',
    'nantes': 'https://images.unsplash.com/photo-1551952237-954e52747c69?w=400',
    'bordeaux':
        'https://images.unsplash.com/photo-1563166423-482a4b3a9996?w=400',
    'lille':
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
    'strasbourg':
        'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=400',
    'rennes':
        'https://images.unsplash.com/photo-1610508903813-83e64dfb0f62?w=400',
  };

  final key = cityName.toLowerCase();
  return cityImages[key] ??
      'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400';
}

/// Simple class to hold category info
class EventCategoryInfo {
  final String id;
  final String? parentId;
  final String name;
  final String slug;
  final String? icon;
  final String? imageUrl;
  final String? imageAlt;
  final int directEventCount;
  final int eventCount;
  final List<EventCategoryInfo> children;

  EventCategoryInfo({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.icon,
    this.imageUrl,
    this.imageAlt,
    this.directEventCount = 0,
    required this.eventCount,
    this.children = const [],
  });

  factory EventCategoryInfo.fromDto(EventCategoryDto category) {
    final children = category.children.map(EventCategoryInfo.fromDto).toList();
    final directEventCount = category.eventCount ?? 0;
    final childrenEventCount = children.fold<int>(
      0,
      (sum, child) => sum + child.eventCount,
    );

    return EventCategoryInfo(
      id: category.id.toString(),
      parentId: category.parentId?.toString(),
      name: category.name,
      slug: category.slug,
      icon: category.icon,
      imageUrl: category.imageUrl,
      imageAlt: category.imageAlt,
      directEventCount: directEventCount,
      eventCount: directEventCount + childrenEventCount,
      children: children,
    );
  }

  int get childrenEventCount => eventCount - directEventCount;
}

// ──────────────────────────────────────────────────────────────────────────────
// Mobile App Config
// ──────────────────────────────────────────────────────────────────────────────

final mobileAppConfigProvider =
    AutoDisposeAsyncNotifierProvider<MobileAppConfigNotifier, MobileAppConfig>(
  MobileAppConfigNotifier.new,
);

class MobileAppConfigNotifier extends AutoDisposeAsyncNotifier<MobileAppConfig>
    with _RefreshableHomeProvider<MobileAppConfig> {
  @override
  Future<MobileAppConfig> build() async {
    final dataSource = ref.watch(mobileConfigDataSourceProvider);
    scheduleBoundedRefresh(now: ref.watch(homeNowProvider)());
    return dataSource.getConfig();
  }

  Future<void> refresh() => reload();
}

/// Model for a saved/recent search
class SavedSearch {
  final String query;
  final String? citySlug;
  final String? cityName;
  final String? thematiqueSlug;
  final String? thematiqueName;
  final DateTime savedAt;
  final bool hasAlert;
  final String? displayName;

  SavedSearch({
    required this.query,
    this.citySlug,
    this.cityName,
    this.thematiqueSlug,
    this.thematiqueName,
    required this.savedAt,
    this.hasAlert = false,
    this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'query': query,
        'citySlug': citySlug,
        'cityName': cityName,
        'thematiqueSlug': thematiqueSlug,
        'thematiqueName': thematiqueName,
        'savedAt': savedAt.toIso8601String(),
        'hasAlert': hasAlert,
        'displayName': displayName,
      };

  factory SavedSearch.fromJson(Map<String, dynamic> json) => SavedSearch(
        query: json['query'] ?? '',
        citySlug: json['citySlug'],
        cityName: json['cityName'],
        thematiqueSlug: json['thematiqueSlug'],
        thematiqueName: json['thematiqueName'],
        savedAt: DateTime.tryParse(json['savedAt'] ?? '') ?? DateTime.now(),
        hasAlert: json['hasAlert'] ?? false,
        displayName: json['displayName'],
      );

  /// Display label for the search chip
  String get displayLabel {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }

    final parts = <String>[];
    if (query.isNotEmpty) parts.add('"$query"');
    if (cityName != null) parts.add(cityName!);
    if (thematiqueName != null) parts.add(thematiqueName!);

    final l10n = cachedAppLocalizations();
    if (parts.isEmpty && hasAlert) return l10n.homeSavedSearchAlertFallback;
    if (parts.isEmpty) return l10n.homeSavedSearchFallback;

    return parts.join(' • ');
  }
}

/// Notifier for managing saved searches
class SavedSearchesNotifier extends StateNotifier<List<SavedSearch>> {
  SavedSearchesNotifier() : super([]) {
    _loadSearches();
  }

  Future<void> _loadSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(AppConstants.keyRecentSearches);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString);
        state = decoded.map((e) => SavedSearch.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error loading saved searches: $e');
    }
  }

  Future<void> _saveSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(state.map((s) => s.toJson()).toList());
      await prefs.setString(AppConstants.keyRecentSearches, jsonString);
    } catch (e) {
      debugPrint('Error saving searches: $e');
    }
  }

  Future<void> addSearch(SavedSearch search) async {
    // Remove duplicate if exists (check by name or criteria)
    state = state.where((s) {
      // unique by custom name if provided
      if (search.displayName != null && s.displayName == search.displayName) {
        return false;
      }
      // or unique by criteria if no name provided (fallback)
      if (search.displayName == null && s.displayLabel == search.displayLabel) {
        return false;
      }
      return true;
    }).toList();

    // Add to beginning
    state = [search, ...state].take(AppConstants.maxRecentSearches).toList();
    await _saveSearches();
  }

  Future<void> removeSearch(SavedSearch search) async {
    state = state.where((s) => s.savedAt != search.savedAt).toList();
    await _saveSearches();
  }

  Future<void> clearAll() async {
    state = [];
    await _saveSearches();
  }
}

/// Provider for saved/recent searches
final savedSearchesProvider =
    StateNotifierProvider<SavedSearchesNotifier, List<SavedSearch>>((ref) {
  return SavedSearchesNotifier();
});

// ──────────────────────────────────────────────────────────────────────────────
// New Activities (recently published events)
// ──────────────────────────────────────────────────────────────────────────────

final homeNewActivitiesProvider = StateNotifierProvider.autoDispose<
    _SessionBoundHomeController<List<Activity>>,
    AsyncValue<List<Activity>>>((ref) {
  const querySize = 50;
  const maxCards = 10;
  ref.watch(authSessionKeyProvider);
  final eventRepository = ref.watch(eventRepositoryProvider);
  final now = ref.watch(homeNowProvider);
  return _SessionBoundHomeController<List<Activity>>(
    now: now,
    cacheLink: ref.keepAlive(),
    invalidate: ref.invalidateSelf,
    load: (ownsRequest) async {
      final requestNow = now();
      // See _isAvailableForHome — same rationale as
      // homeNearbyAvailableActivitiesProvider.
      final result = await eventRepository.getEvents(
        page: 1,
        perPage: querySize,
        sort: 'published_at',
        order: 'desc',
      );
      if (!ownsRequest()) return const <Activity>[];

      final seenEventIds = <String>{};
      final activities = <Activity>[];
      for (final event in result.events) {
        if (!seenEventIds.add(event.id)) continue;
        final activity = _activityWithNearestAvailableSlot(event, requestNow);
        if (activity == null || activity.nextSlot == null) continue;
        activities.add(activity);
      }

      if (!ownsRequest()) return const <Activity>[];
      return activities.take(maxCards).toList();
    },
  );
});

// ──────────────────────────────────────────────────────────────────────────────
// Recommended Activities (derived from Feed)
// ──────────────────────────────────────────────────────────────────────────────

final homeActivitiesProvider =
    Provider.autoDispose<AsyncValue<List<Activity>>>((ref) {
  return ref.watch(homeFeedProvider).whenData((feed) {
    if (feed.recommended.isEmpty) return const <Activity>[];
    final events = feed.recommended.map(EventMapper.toEvent).toList();
    return sortActivitiesChronologically(
      EventToActivityMapper.toActivities(events),
    );
  });
});

@visibleForTesting
List<Activity> sortActivitiesChronologically(List<Activity> activities) {
  final indexed = activities.asMap().entries.toList();
  indexed.sort((a, b) {
    final compareDates = _compareNullableDateTimes(
      a.value.nextSlot?.startDateTime,
      b.value.nextSlot?.startDateTime,
    );
    if (compareDates != 0) return compareDates;
    return a.key.compareTo(b.key);
  });
  return indexed.map((entry) => entry.value).toList();
}

int _compareNullableDateTimes(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
