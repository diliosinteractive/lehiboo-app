import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../data/repositories/favorites_repository_impl.dart';

/// Callback type for toggle error handling
typedef FavoriteErrorCallback = void Function(String message, bool wasAdding);

// StateNotifier to manage list of favorite events
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final FavoritesRepository _repository;

  /// Set of favorite IDs for O(1) lookup
  final Set<String> _favoriteIds = {};

  /// Callback for error notifications (can be set by UI)
  FavoriteErrorCallback? onFavoriteError;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      state = const AsyncValue.loading();
      final favorites = await _repository.getFavorites();

      // Update ID cache
      _favoriteIds.clear();
      for (final event in favorites) {
        _favoriteIds.add(event.id);
      }

      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      debugPrint('Error loading favorites: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Toggle favorite status for an event
  ///
  /// [event] - The event to toggle
  /// [internalId] - Optional numeric ID for API (if not stored in event.additionalInfo)
  Future<bool> toggleFavorite(Event event, {int? internalId}) async {
    // Extract numeric ID for API call
    // Priority: internalId param > additionalInfo > parsed event.id
    int? eventId = internalId;
    eventId ??= event.additionalInfo?['internal_id'] as int?;
    eventId ??= int.tryParse(event.id);

    if (eventId == null) {
      debugPrint('Cannot toggle favorite: no valid numeric ID found for event ${event.id}');
      onFavoriteError?.call('Impossible de modifier le favori', false);
      return false;
    }

    // Optimistic update
    final currentList = state.value ?? [];
    final isFav = isFavorite(event.id);
    final wasAdding = !isFav;

    List<Event> newList;
    if (isFav) {
      newList = currentList.where((e) => e.id != event.id).toList();
      _favoriteIds.remove(event.id);
    } else {
      newList = [...currentList, event.copyWith(isFavorite: true)];
      _favoriteIds.add(event.id);
    }
    state = AsyncValue.data(newList);

    try {
      await _repository.toggleFavorite(eventId);

      // Reload to ensure sync with server and get complete data
      await loadFavorites();

      return true;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');

      // Revert optimistic update
      if (wasAdding) {
        _favoriteIds.remove(event.id);
      } else {
        _favoriteIds.add(event.id);
      }
      state = AsyncValue.data(currentList);

      // Notify error
      onFavoriteError?.call(
        wasAdding ? 'Impossible d\'ajouter aux favoris' : 'Impossible de retirer des favoris',
        wasAdding,
      );

      return false;
    }
  }

  /// Check if an event is favorited using O(1) lookup
  bool isFavorite(String eventId) {
    // First check the cached set
    if (_favoriteIds.contains(eventId)) return true;

    // Fallback to list check (handles race conditions during loading)
    return state.value?.any((e) => e.id == eventId) ?? false;
  }

  /// Check if an event is favorited by numeric ID
  bool isFavoriteById(int eventId) {
    return isFavorite(eventId.toString()) ||
           state.value?.any((e) => e.additionalInfo?['internal_id'] == eventId) == true;
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Event>>>((ref) {
  final repository = ref.watch(favoritesRepositoryImplProvider);
  return FavoritesNotifier(repository);
});
