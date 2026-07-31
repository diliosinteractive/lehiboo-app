import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import '../../data/models/toggle_favorite_result.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'favorite_lists_provider.dart';

// StateNotifier to manage list of favorite events
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final FavoritesRepository _repository;
  final Ref _ref;
  final bool _hasActiveAccount;

  int _loadGeneration = 0;
  int _stateRevision = 0;

  /// Set of favorite IDs for O(1) lookup
  final Set<String> _favoriteIds = {};

  /// Current list ID filter (null = all)
  String? _currentListId;

  FavoritesNotifier(
    this._repository,
    this._ref, {
    required bool hasActiveAccount,
  })  : _hasActiveAccount = hasActiveAccount,
        super(
          hasActiveAccount
              ? const AsyncValue.loading()
              : const AsyncValue.data([]),
        ) {
    if (hasActiveAccount) loadFavorites();
  }

  void _publish(AsyncValue<List<Event>> next) {
    if (!mounted) return;
    state = next;
    _stateRevision++;
  }

  Future<void> loadFavorites({String? listId}) async {
    if (!mounted) return;
    final requestGeneration = ++_loadGeneration;

    // Anonymous users have no favorites — skip the API call.
    if (!_hasActiveAccount) {
      _favoriteIds.clear();
      _currentListId = null;
      _publish(const AsyncValue.data([]));
      return;
    }

    try {
      _currentListId = listId;
      _publish(const AsyncValue.loading());
      final favorites = await _repository.getFavorites(listId: listId);
      if (!mounted || requestGeneration != _loadGeneration) return;

      // Update ID cache
      _favoriteIds.clear();
      for (final event in favorites) {
        _favoriteIds.add(event.id);
      }

      _publish(AsyncValue.data(favorites));
    } catch (e, stack) {
      debugPrint('Error loading favorites: $e');
      if (!mounted || requestGeneration != _loadGeneration) return;
      _publish(AsyncValue.error(e, stack));
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
  /// Returns the authoritative backend result. Failures are rethrown after
  /// rolling back the optimistic state so the initiating UI can explain them.
  Future<ToggleFavoriteResult> toggleFavorite(Event event,
      {int? internalId, String? listId}) async {
    // event.id contient l'UUID (voir FavoritesRepositoryImpl qui utilise stringId)
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot toggle favorite: no valid UUID found for event');
      throw ArgumentError.value(eventUuid, 'event.id', 'Missing event UUID');
    }

    // Optimistic update
    final currentList = state.valueOrNull ?? [];
    final isFav = isFavorite(event.id);
    final wasAdding = !isFav;

    // A load started before this mutation must not overwrite its optimistic
    // state when it eventually completes.
    _loadGeneration++;

    List<Event> newList;
    if (isFav) {
      newList = currentList.where((e) => e.id != event.id).toList();
      _favoriteIds.remove(event.id);
    } else {
      newList = [...currentList, event.copyWith(isFavorite: true)];
      _favoriteIds.add(event.id);
    }
    _publish(AsyncValue.data(newList));
    final optimisticRevision = _stateRevision;

    try {
      final result =
          await _repository.toggleFavorite(eventUuid, listId: listId);
      if (!mounted) return result;

      // Analytics : add_to_wishlist (standard GA4) ou remove_from_wishlist
      // (custom). Le résultat backend `result.isFavorite` est la source de
      // vérité — `wasAdding` peut diverger en cas de désynchro.
      final added = result.isFavorite;
      _ref.read(analyticsServiceProvider).logEvent(
        added
            ? AnalyticsEvent.addToWishlist
            : AnalyticsEvent.removeFromWishlist,
        params: {
          AnalyticsParam.itemId: eventUuid,
          AnalyticsParam.itemName: event.title,
          AnalyticsParam.itemCategory: event.category.name,
        },
      );

      // Update list counter if adding to a specific list
      if (wasAdding && listId != null) {
        _ref.read(favoriteListsProvider.notifier).incrementListCount(listId);
      } else if (!wasAdding) {
        // If removing, decrement the list counter
        final oldListId = event.additionalInfo?['list_id'] as String?;
        if (oldListId != null) {
          _ref
              .read(favoriteListsProvider.notifier)
              .decrementListCount(oldListId);
        }
      }

      // Plan 05 : l'enveloppe `hibons_update` à la racine de la réponse est
      // gérée globalement par HibonsUpdateInterceptor, qui met à jour le
      // wallet et déclenche le toast +X Hibons. Pas de sync manuel ici.

      // Reload to ensure sync with server and get complete data
      await loadFavorites(listId: _currentListId);

      // Favourite signal changed — drop the personalized feed (spec §7).
      if (mounted) _ref.invalidate(personalizedFeedProvider);

      return result;
    } catch (e, stackTrace) {
      debugPrint('Error toggling favorite: $e');

      // Revert only if this optimistic snapshot still owns the state. A
      // disposed notifier belongs to a previous account; a newer operation
      // may also have legitimately replaced this snapshot.
      if (mounted && _stateRevision == optimisticRevision) {
        if (wasAdding) {
          _favoriteIds.remove(event.id);
        } else {
          _favoriteIds.add(event.id);
        }
        _publish(AsyncValue.data(currentList));
      }

      Error.throwWithStackTrace(e, stackTrace);
    }
  }

  /// Ajouter à une liste spécifique (pour les événements déjà favoris).
  ///
  /// Returns the backend result; failures are rethrown for user-facing
  /// handling by the initiating control.
  Future<ToggleFavoriteResult> addToList(Event event, String listId,
      {int? internalId}) async {
    // event.id contient l'UUID
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot add to list: no valid UUID found for event');
      throw ArgumentError.value(eventUuid, 'event.id', 'Missing event UUID');
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
        if (!mounted) return result;
        _favoriteIds.add(event.id);
      }
      if (!mounted) return result;

      // Mettre à jour les compteurs
      _ref.read(favoriteListsProvider.notifier).incrementListCount(listId);

      // Plan 05 : la mise à jour du wallet est faite via HibonsUpdateInterceptor.

      // Recharger
      await loadFavorites(listId: _currentListId);

      // Favourite signal changed if a new favourite was added (spec §7);
      // pure list moves don't change the set of favourited events but the
      // server-side strata are cheap to invalidate.
      if (!isFav && mounted) {
        _ref.invalidate(personalizedFeedProvider);
      }

      return result;
    } catch (e, stackTrace) {
      debugPrint('Error adding to list: $e');
      Error.throwWithStackTrace(e, stackTrace);
    }
  }

  /// Déplacer un favori vers une autre liste
  Future<bool> moveToList(Event event, String? newListId,
      {int? internalId}) async {
    // event.id contient l'UUID
    final eventUuid = event.id;

    if (eventUuid.isEmpty) {
      debugPrint('Cannot move: no valid UUID found for event');
      throw ArgumentError.value(eventUuid, 'event.id', 'Missing event UUID');
    }

    final oldListId = event.additionalInfo?['list_id'] as String?;

    try {
      await _repository.moveFavoriteToList(eventUuid, newListId);
      if (!mounted) return true;

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
    } catch (e, stackTrace) {
      debugPrint('Error moving to list: $e');
      Error.throwWithStackTrace(e, stackTrace);
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
        state.valueOrNull
                ?.any((e) => e.additionalInfo?['internal_id'] == eventId) ==
            true;
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

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Event>>>((ref) {
  // The opaque dependency forces a fresh blank notifier even for a rapid
  // A -> B -> A cycle whose final account-id string equals the initial one.
  ref.watch(authSessionKeyProvider);
  final hasActiveAccount = ref.watch(authSessionUserIdProvider) != null;
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(
    repository,
    ref,
    hasActiveAccount: hasActiveAccount,
  );
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
    return events
        .where((e) => e.additionalInfo?['list_id'] == selectedListId)
        .toList();
  });
});
