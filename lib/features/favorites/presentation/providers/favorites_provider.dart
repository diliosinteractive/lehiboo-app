import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import 'favorite_lists_provider.dart';

/// Callback type for toggle error handling
typedef FavoriteErrorCallback = void Function(String message, bool wasAdding);

// StateNotifier to manage list of favorite events
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final FavoritesRepository _repository;
  final Ref _ref;

  /// Set of favorite IDs for O(1) lookup
  final Set<String> _favoriteIds = {};

  /// Current list ID filter (null = all)
  String? _currentListId;

  /// Callback for error notifications (can be set by UI)
  FavoriteErrorCallback? onFavoriteError;

  FavoritesNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites({String? listId}) async {
    try {
      _currentListId = listId;
      state = const AsyncValue.loading();
      final favorites = await _repository.getFavorites(listId: listId);

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

  /// Recharger avec le filtre actuel
  Future<void> refresh() async {
    await loadFavorites(listId: _currentListId);
  }

  /// Toggle favorite status for an event
  ///
  /// [event] - The event to toggle
  /// [internalId] - DEPRECATED: UUID is now extracted from event.id
  /// [listId] - Optional list ID to add the favorite to
  Future<bool> toggleFavorite(Event event, {int? internalId, String? listId}) async {
    // event.id contient l'UUID (voir FavoritesRepositoryImpl qui utilise stringId)
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot toggle favorite: no valid UUID found for event');
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
      await _repository.toggleFavorite(eventUuid, listId: listId);

      // Update list counter if adding to a specific list
      if (wasAdding && listId != null) {
        _ref.read(favoriteListsProvider.notifier).incrementListCount(listId);
      } else if (!wasAdding) {
        // If removing, decrement the list counter
        final oldListId = event.additionalInfo?['list_id'] as String?;
        if (oldListId != null) {
          _ref.read(favoriteListsProvider.notifier).decrementListCount(oldListId);
        }
      }

      // Reload to ensure sync with server and get complete data
      await loadFavorites(listId: _currentListId);

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

  /// Ajouter à une liste spécifique (pour les événements déjà favoris)
  Future<bool> addToList(Event event, String listId, {int? internalId}) async {
    // event.id contient l'UUID
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot add to list: no valid UUID found for event');
      return false;
    }

    final isFav = isFavorite(event.id);

    try {
      if (isFav) {
        // Si déjà favori, déplacer vers la nouvelle liste
        await _repository.moveFavoriteToList(eventUuid, listId);
      } else {
        // Sinon, ajouter aux favoris avec la liste
        await _repository.addToFavorites(eventUuid, listId: listId);
        _favoriteIds.add(event.id);
      }

      // Mettre à jour les compteurs
      _ref.read(favoriteListsProvider.notifier).incrementListCount(listId);

      // Recharger
      await loadFavorites(listId: _currentListId);

      return true;
    } catch (e) {
      debugPrint('Error adding to list: $e');
      return false;
    }
  }

  /// Déplacer un favori vers une autre liste
  Future<bool> moveToList(Event event, String? newListId, {int? internalId}) async {
    // event.id contient l'UUID
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot move: no valid UUID found for event');
      return false;
    }

    final oldListId = event.additionalInfo?['list_id'] as String?;

    try {
      await _repository.moveFavoriteToList(eventUuid, newListId);

      // Mettre à jour les compteurs
      if (oldListId != null) {
        _ref.read(favoriteListsProvider.notifier).decrementListCount(oldListId);
      }
      if (newListId != null) {
        _ref.read(favoriteListsProvider.notifier).incrementListCount(newListId);
      }

      // Recharger
      await loadFavorites(listId: _currentListId);

      return true;
    } catch (e) {
      debugPrint('Error moving to list: $e');
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

  /// Obtenir l'ID de liste actuel d'un événement
  String? getEventListId(String eventId) {
    final event = state.value?.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );
    return event?.additionalInfo?['list_id'] as String?;
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Event>>>((ref) {
  final repository = ref.watch(favoritesRepositoryImplProvider);
  return FavoritesNotifier(repository, ref);
});

/// Provider filtré par liste sélectionnée
final filteredFavoritesProvider = Provider<AsyncValue<List<Event>>>((ref) {
  final selectedListId = ref.watch(selectedFavoriteListProvider);
  final favorites = ref.watch(favoritesProvider);

  if (selectedListId == null) {
    // Tous les favoris
    return favorites;
  }

  return favorites.whenData((events) {
    if (selectedListId == 'uncategorized') {
      // Non classés (pas de liste)
      return events.where((e) => e.additionalInfo?['list_id'] == null).toList();
    }

    // Filtrer par liste spécifique
    return events.where((e) => e.additionalInfo?['list_id'] == selectedListId).toList();
  });
});
