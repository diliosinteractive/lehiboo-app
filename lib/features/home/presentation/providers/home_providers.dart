import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/city.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../events/domain/repositories/event_repository.dart';
import '../../../events/data/mappers/event_to_activity_mapper.dart';
import '../../data/models/mobile_app_config.dart';

/// Provider for recommended activities/events from the real API
final homeActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  try {
    // Fetch events from real API
    final result = await eventRepository.getEvents(
      page: 1,
      perPage: 10,
      orderBy: 'date',
      order: 'asc',
    );

    // Convert Event to Activity for compatibility with existing widgets
    return EventToActivityMapper.toActivities(result.events);
  } catch (e) {
    // If real API fails, return empty list instead of crashing
    return [];
  }
});

/// Provider for featured/promoted activities
final featuredActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  try {
    // Fetch featured events
    final result = await eventRepository.getEvents(
      page: 1,
      perPage: 5,
      orderBy: 'views', // Most popular
      order: 'desc',
    );

    return EventToActivityMapper.toActivities(result.events);
  } catch (e) {
    return [];
  }
});

/// Provider for event categories from real API
final categoriesProvider = FutureProvider<List<EventCategoryInfo>>((ref) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  try {
    final categories = await eventRepository.getCategories();
    return categories
        .map((cat) => EventCategoryInfo(
              id: cat.id.toString(),
              name: cat.name,
              slug: cat.slug,
              icon: cat.icon,
              eventCount: cat.eventCount ?? 0,
            ))
        .toList();
  } catch (e) {
    return [];
  }
});

/// Provider for cities from real API
final homeCitiesProvider = FutureProvider<List<City>>((ref) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  try {
    final citiesDto = await eventRepository.getCities();
    // Convert CityDto to City objects, sorted by event count
    final sortedCities = List.of(citiesDto)
      ..sort((a, b) => (b.eventCount ?? 0).compareTo(a.eventCount ?? 0));

    return sortedCities
        .take(6) // Top 6 cities with most events
        .map((cityDto) => City(
              id: cityDto.id.toString(),
              name: cityDto.name,
              slug: cityDto.slug,
              eventCount: cityDto.eventCount,
              // Default image for cities - could be enhanced with real images
              imageUrl: _getCityImageUrl(cityDto.name),
            ))
        .toList();
  } catch (e) {
    return [];
  }
});

/// Get a placeholder image URL for a city
String _getCityImageUrl(String cityName) {
  // Map of known cities to image URLs
  final cityImages = {
    'paris': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
    'lyon': 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=400',
    'marseille': 'https://images.unsplash.com/photo-1589640512757-e2894e3f9e54?w=400',
    'toulouse': 'https://images.unsplash.com/photo-1557687790-902ede7ab58c?w=400',
    'nice': 'https://images.unsplash.com/photo-1504214208698-ea1916a2195a?w=400',
    'nantes': 'https://images.unsplash.com/photo-1551952237-954e52747c69?w=400',
    'bordeaux': 'https://images.unsplash.com/photo-1563166423-482a4b3a9996?w=400',
    'lille': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
    'strasbourg': 'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=400',
    'rennes': 'https://images.unsplash.com/photo-1610508903813-83e64dfb0f62?w=400',
  };

  final key = cityName.toLowerCase();
  return cityImages[key] ?? 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400';
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

/// Provider for mobile app configuration from WordPress admin
final mobileAppConfigProvider = FutureProvider<MobileAppConfig>((ref) async {
  try {
    // Call the eventlist/v1 API endpoint directly
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://preprod.lehiboo.com/wp-json',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final response = await dio.get('/eventlist/v1/mobile-app/config');
    final data = response.data;

    debugPrint('=== Mobile App Config API Response ===');
    debugPrint('Response: $data');

    if (data != null) {
      return MobileAppConfig.fromJson(data);
    }

    return MobileAppConfig.defaultConfig();
  } catch (e) {
    debugPrint('Error loading mobile app config: $e');
    // Return default config if API fails
    return MobileAppConfig.defaultConfig();
  }
});

/// Model for a saved/recent search
class SavedSearch {
  final String query;
  final String? citySlug;
  final String? cityName;
  final String? thematiqueSlug;
  final String? thematiqueName;
  final DateTime savedAt;

  SavedSearch({
    required this.query,
    this.citySlug,
    this.cityName,
    this.thematiqueSlug,
    this.thematiqueName,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'query': query,
    'citySlug': citySlug,
    'cityName': cityName,
    'thematiqueSlug': thematiqueSlug,
    'thematiqueName': thematiqueName,
    'savedAt': savedAt.toIso8601String(),
  };

  factory SavedSearch.fromJson(Map<String, dynamic> json) => SavedSearch(
    query: json['query'] ?? '',
    citySlug: json['citySlug'],
    cityName: json['cityName'],
    thematiqueSlug: json['thematiqueSlug'],
    thematiqueName: json['thematiqueName'],
    savedAt: DateTime.tryParse(json['savedAt'] ?? '') ?? DateTime.now(),
  );

  /// Display label for the search chip
  String get displayLabel {
    final parts = <String>[];
    if (query.isNotEmpty) parts.add('"$query"');
    if (cityName != null) parts.add(cityName!);
    if (thematiqueName != null) parts.add(thematiqueName!);
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
    // Remove duplicate if exists
    state = state.where((s) => s.displayLabel != search.displayLabel).toList();
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
final savedSearchesProvider = StateNotifierProvider<SavedSearchesNotifier, List<SavedSearch>>((ref) {
  return SavedSearchesNotifier();
});
