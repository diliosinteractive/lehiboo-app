import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';

/// Local cache for favorite IDs using SharedPreferences
///
/// Stores:
/// - Set of favorite event IDs for O(1) lookup
/// - Last sync timestamp for cache invalidation
class FavoritesLocalDatasource {
  static const String _favoriteIdsKey = 'favorite_ids';
  static const String _lastSyncKey = 'favorites_last_sync';
  static const Duration _cacheValidityDuration = Duration(hours: 24);

  final SharedPreferences _prefs;

  FavoritesLocalDatasource(this._prefs);

  /// Get cached favorite IDs
  Set<String> getFavoriteIds() {
    final jsonStr = _prefs.getString(_favoriteIdsKey);
    if (jsonStr == null) return {};

    try {
      final List<dynamic> ids = jsonDecode(jsonStr);
      return ids.map((e) => e.toString()).toSet();
    } catch (e) {
      debugPrint('Error parsing cached favorite IDs: $e');
      return {};
    }
  }

  /// Save favorite IDs to cache
  Future<void> saveFavoriteIds(Set<String> ids) async {
    try {
      final jsonStr = jsonEncode(ids.toList());
      await _prefs.setString(_favoriteIdsKey, jsonStr);
      await _prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Error saving favorite IDs to cache: $e');
    }
  }

  /// Check if a specific event is favorited (O(1) lookup)
  bool isFavorite(String eventId) {
    return getFavoriteIds().contains(eventId);
  }

  /// Add a favorite ID to cache (optimistic update)
  Future<void> addFavorite(String eventId) async {
    final ids = getFavoriteIds();
    ids.add(eventId);
    await saveFavoriteIds(ids);
  }

  /// Remove a favorite ID from cache (optimistic update)
  Future<void> removeFavorite(String eventId) async {
    final ids = getFavoriteIds();
    ids.remove(eventId);
    await saveFavoriteIds(ids);
  }

  /// Check if cache needs refresh
  bool needsRefresh() {
    final lastSync = _prefs.getInt(_lastSyncKey);
    if (lastSync == null) return true;

    final lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSync);
    return DateTime.now().difference(lastSyncTime) > _cacheValidityDuration;
  }

  /// Clear cache (e.g., on logout)
  Future<void> clear() async {
    await _prefs.remove(_favoriteIdsKey);
    await _prefs.remove(_lastSyncKey);
  }

  /// Get last sync timestamp
  DateTime? getLastSyncTime() {
    final lastSync = _prefs.getInt(_lastSyncKey);
    if (lastSync == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastSync);
  }
}

/// Provider for FavoritesLocalDatasource
final favoritesLocalDatasourceProvider = Provider<FavoritesLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesLocalDatasource(prefs);
});
