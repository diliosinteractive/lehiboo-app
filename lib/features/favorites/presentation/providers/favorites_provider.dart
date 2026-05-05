import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/toggle_favorite_result.dart';
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
    // Anonymous users have no favorites — skip the API call
    final isAuthenticated = _ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) {
      state = const AsyncValue.data([]);
      return;
    }

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
  ///
  /// Retourne `null` en cas d'échec, sinon un [ToggleFavoriteResult] qui
  /// peut contenir la récompense hibons créditée par le backend.
  Future<ToggleFavoriteResult?> toggleFavorite(Event event, {int? internalId, String? listId}) async {
    // event.id contient l'UUID (voir FavoritesRepositoryImpl qui utilise stringId)
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot toggle favorite: no valid UUID found for event');
      onFavoriteError?.call('Impossible de modifier le favori', false);
      return null;
    }

    // Optimistic update
    final currentList = state.valueOrNull ?? [];
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
      final result = await _repository.toggleFavorite(eventUuid, listId: listId);

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

      // Plan 05 : l'enveloppe `hibons_update` à la racine de la réponse est
      // gérée globalement par HibonsUpdateInterceptor, qui met à jour le
      // wallet et déclenche le toast +X Hibons. Pas de sync manuel ici.

      // Reload to ensure sync with server and get complete data
      await loadFavorites(listId: _currentListId);

      return result;
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

      return null;
    }
  }

  /// Ajouter à une liste spécifique (pour les événements déjà favoris).
  ///
  /// Retourne `null` en cas d'échec, sinon un [ToggleFavoriteResult] dont
  /// `hasReward` indique si une récompense hibons a été créditée (seulement
  /// possible sur la branche "ajout aux favoris", jamais sur un simple
  /// déplacement entre listes).
  Future<ToggleFavoriteResult?> addToList(Event event, String listId, {int? internalId}) async {
    // event.id contient l'UUID
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot add to list: no valid UUID found for event');
      return null;
    }

    final isFav = isFavorite(event.id);

    try {
      ToggleFavoriteResult result;
      if (isFav) {
        // Si déjà favori, déplacer vers la nouvelle liste (pas de reward possible)
        await _repository.moveFavoriteToList(eventUuid, listId);
        result = const ToggleFavoriteResult(isFavorite: true);
      } else {
        // Sinon, ajouter aux favoris avec la liste
        result = await _repository.addToFavorites(eventUuid, listId: listId);
        _favoriteIds.add(event.id);
      }

      // Mettre à jour les compteurs
      _ref.read(favoriteListsProvider.notifier).incrementListCount(listId);

      // Plan 05 : la mise à jour du wallet est faite via HibonsUpdateInterceptor.

      // Recharger
      await loadFavorites(listId: _currentListId);

      return result;
    } catch (e) {
      debugPrint('Error adding to list: $e');
      return null;
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
    return state.valueOrNull?.any((e) => e.id == eventId) ?? false;
  }

  /// Check if an event is favorited by numeric ID
  bool isFavoriteById(int eventId) {
    return isFavorite(eventId.toString()) ||
           state.valueOrNull?.any((e) => e.additionalInfo?['internal_id'] == eventId) == true;
  }

  /// Obtenir l'ID de liste actuel d'un événement.
  ///
  /// Lookup dans l'état des favoris (autoritaire), pas dans `additionalInfo`
  /// de l'event passé en paramètre — ce dernier peut venir d'un endpoint qui
  /// n'expose pas la liste (events list, event detail).
  ///
  /// Retourne `null` si l'event n'est pas favori OU est dans "Non classé".
  String? getEventListId(String eventId) {
    final events = state.valueOrNull;
    if (events == null) return null;
    for (final event in events) {
      if (event.id == eventId) {
        return event.additionalInfo?['list_id'] as String?;
      }
    }
    return null;
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
