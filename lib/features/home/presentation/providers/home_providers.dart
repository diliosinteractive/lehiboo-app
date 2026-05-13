import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/city.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../events/domain/entities/popular_city.dart';
import '../../../events/domain/repositories/event_repository.dart';
import '../../../events/data/mappers/event_to_activity_mapper.dart';
import '../../data/models/mobile_app_config.dart';
import '../../data/datasources/mobile_config_datasource.dart';
import 'user_location_provider.dart';
import '../../../../features/events/data/models/home_feed_response_dto.dart'
    show HomeFeedDataDto;
import '../../../events/data/mappers/event_mapper.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Home Feed
// ──────────────────────────────────────────────────────────────────────────────

final homeFeedProvider =
    AutoDisposeAsyncNotifierProvider<HomeFeedNotifier, HomeFeedDataDto>(
  HomeFeedNotifier.new,
);

class HomeFeedNotifier extends AutoDisposeAsyncNotifier<HomeFeedDataDto> {
  @override
  Future<HomeFeedDataDto> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);
    final userLocationAsync = ref.watch(userLocationProvider);
    final userLocation = userLocationAsync.valueOrNull;

    final result = await eventRepository.getHomeFeed(
      lat: userLocation?.lat,
      lng: userLocation?.lng,
      radius: userLocation != null ? 30 : null,
      limit: 10,
    );
    ref.keepAlive();
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Today's Activities (derived from Feed)
// ──────────────────────────────────────────────────────────────────────────────

final homeTodayActivitiesProvider = AutoDisposeAsyncNotifierProvider<
    HomeTodayActivitiesNotifier, List<Activity>>(
  HomeTodayActivitiesNotifier.new,
);

class HomeTodayActivitiesNotifier
    extends AutoDisposeAsyncNotifier<List<Activity>> {
  @override
  Future<List<Activity>> build() async {
    final feed = await ref.watch(homeFeedProvider.future);

    if (feed.today.isEmpty) {
      ref.keepAlive();
      return [];
    }

    final events = feed.today.map(EventMapper.toEvent).toList();
    ref.keepAlive();
    return EventToActivityMapper.toActivities(events);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Tomorrow's Activities (derived from Feed)
// ──────────────────────────────────────────────────────────────────────────────

final homeTomorrowActivitiesProvider = AutoDisposeAsyncNotifierProvider<
    HomeTomorrowActivitiesNotifier, List<Activity>>(
  HomeTomorrowActivitiesNotifier.new,
);

class HomeTomorrowActivitiesNotifier
    extends AutoDisposeAsyncNotifier<List<Activity>> {
  @override
  Future<List<Activity>> build() async {
    final feed = await ref.watch(homeFeedProvider.future);

    if (feed.tomorrow.isEmpty) {
      ref.keepAlive();
      return [];
    }

    final events = feed.tomorrow.map(EventMapper.toEvent).toList();
    ref.keepAlive();
    return EventToActivityMapper.toActivities(events);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Event Categories
// ──────────────────────────────────────────────────────────────────────────────

final categoriesProvider = AutoDisposeAsyncNotifierProvider<CategoriesNotifier,
    List<EventCategoryInfo>>(
  CategoriesNotifier.new,
);

class CategoriesNotifier
    extends AutoDisposeAsyncNotifier<List<EventCategoryInfo>> {
  @override
  Future<List<EventCategoryInfo>> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);

    final categories = await eventRepository.getCategories();
    ref.keepAlive();
    return categories
        .map((cat) => EventCategoryInfo(
              id: cat.id.toString(),
              name: cat.name,
              slug: cat.slug,
              icon: cat.icon,
              eventCount: cat.eventCount ?? 0,
            ))
        .toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Cities
// ──────────────────────────────────────────────────────────────────────────────

final homeCitiesProvider =
    AutoDisposeAsyncNotifierProvider<HomeCitiesNotifier, List<City>>(
  HomeCitiesNotifier.new,
);

class HomeCitiesNotifier extends AutoDisposeAsyncNotifier<List<City>> {
  @override
  Future<List<City>> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);

    final cities = await eventRepository.getCities();

    final sortedCities = List.of(cities)
      ..sort((a, b) => (b.eventCount ?? 0).compareTo(a.eventCount ?? 0));

    ref.keepAlive();
    return sortedCities.map((city) {
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

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
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
    extends AutoDisposeAsyncNotifier<PopularCitiesResult> {
  static const int _maxCards = 6;

  @override
  Future<PopularCitiesResult> build() async {
    final repository = ref.watch(eventRepositoryProvider);

    final featured = await repository.getFeaturedCities();
    if (featured.isNotEmpty) {
      ref.keepAlive();
      return PopularCitiesResult(
        cities: featured.take(_maxCards).toList(),
        isFallback: false,
      );
    }

    final fallback = await repository.getFeaturedCities(fallback: true);
    ref.keepAlive();
    return PopularCitiesResult(
      cities: fallback.take(_maxCards).toList(),
      isFallback: true,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Placeholder image fallback for the legacy [homeCitiesProvider], which still
/// powers the search/filter sheets. The home "Villes populaires" section uses
/// [popularCitiesProvider] and the server-provided image instead.
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
  final String name;
  final String slug;
  final String? icon;
  final int eventCount;

  EventCategoryInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    required this.eventCount,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// Mobile App Config
// ──────────────────────────────────────────────────────────────────────────────

final mobileAppConfigProvider =
    AutoDisposeAsyncNotifierProvider<MobileAppConfigNotifier, MobileAppConfig>(
  MobileAppConfigNotifier.new,
);

class MobileAppConfigNotifier
    extends AutoDisposeAsyncNotifier<MobileAppConfig> {
  @override
  Future<MobileAppConfig> build() async {
    final dataSource = ref.watch(mobileConfigDataSourceProvider);
    final result = await dataSource.getConfig();
    ref.keepAlive();
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
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

    if (parts.isEmpty && hasAlert) return 'Alerte personnalisée';
    if (parts.isEmpty) return 'Recherche sauvegardée';

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
// Recommended Activities (derived from Feed)
// ──────────────────────────────────────────────────────────────────────────────

final homeActivitiesProvider =
    AutoDisposeAsyncNotifierProvider<HomeActivitiesNotifier, List<Activity>>(
  HomeActivitiesNotifier.new,
);

class HomeActivitiesNotifier extends AutoDisposeAsyncNotifier<List<Activity>> {
  @override
  Future<List<Activity>> build() async {
    final feed = await ref.watch(homeFeedProvider.future);

    if (feed.recommended.isEmpty) {
      ref.keepAlive();
      return [];
    }

    final events = feed.recommended.map(EventMapper.toEvent).toList();
    ref.keepAlive();
    return EventToActivityMapper.toActivities(events);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
