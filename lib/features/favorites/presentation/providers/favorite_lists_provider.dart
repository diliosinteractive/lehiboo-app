import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/favorite_list.dart';
import '../../domain/repositories/favorites_repository.dart';

/// Provider pour la liste sélectionnée (filtrage)
/// null = tous les favoris
/// 'uncategorized' = non classés
/// 'uuid' = liste spécifique
final selectedFavoriteListProvider = StateProvider<String?>((ref) {
  // Recreate the selection for every account so a route kept alive during an
  // account switch cannot retain a list UUID owned by the previous user.
  ref.watch(authSessionKeyProvider);
  return null;
});

/// Provider pour les listes de favoris
final favoriteListsProvider = StateNotifierProvider<FavoriteListsNotifier,
    AsyncValue<List<FavoriteList>>>(
  (ref) {
    ref.watch(authSessionKeyProvider);
    final hasActiveAccount = ref.watch(authSessionUserIdProvider) != null;
    final repository = ref.watch(favoritesRepositoryProvider);
    return FavoriteListsNotifier(
      repository,
      hasActiveAccount: hasActiveAccount,
    );
  },
);

/// Notifier pour gérer l'état des listes de favoris
class FavoriteListsNotifier
    extends StateNotifier<AsyncValue<List<FavoriteList>>> {
  final FavoritesRepository _repository;
  final bool _hasActiveAccount;
  int _loadGeneration = 0;
  int _stateRevision = 0;

  FavoriteListsNotifier(
    this._repository, {
    required bool hasActiveAccount,
  })  : _hasActiveAccount = hasActiveAccount,
        super(
          hasActiveAccount
              ? const AsyncValue.loading()
              : const AsyncValue.data([]),
        ) {
    if (hasActiveAccount) loadLists();
  }

  void _publish(AsyncValue<List<FavoriteList>> next) {
    if (!mounted) return;
    state = next;
    _stateRevision++;
  }

  /// Charger les listes depuis l'API
  Future<void> loadLists() async {
    if (!mounted) return;
    final requestGeneration = ++_loadGeneration;
    if (!_hasActiveAccount) {
      _publish(const AsyncValue.data([]));
      return;
    }

    try {
      _publish(const AsyncValue.loading());
      final lists = await _repository.getLists();
      if (!mounted || requestGeneration != _loadGeneration) return;
      _publish(AsyncValue.data(lists));
    } catch (e, stack) {
      debugPrint('Error loading favorite lists: $e');
      if (!mounted || requestGeneration != _loadGeneration) return;
      _publish(AsyncValue.error(e, stack));
    }
  }

  /// Rafraîchir les listes
  Future<void> refresh() async {
    await loadLists();
  }

  /// Créer une nouvelle liste
  Future<FavoriteList?> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    try {
      final newList = await _repository.createList(
        name: name,
        description: description,
        color: color,
        icon: icon,
      );
      if (!mounted) return newList;

      // Ajouter la nouvelle liste à l'état actuel
      final currentLists = state.valueOrNull ?? [];
      _publish(AsyncValue.data([...currentLists, newList]));

      return newList;
    } catch (e, stack) {
      debugPrint('Error creating favorite list: $e');
      Error.throwWithStackTrace(e, stack);
    }
  }

  /// Mettre à jour une liste existante
  Future<FavoriteList?> updateList(
    String listId, {
    String? name,
    String? description,
    String? color,
    String? icon,
  }) async {
    try {
      final updatedList = await _repository.updateList(
        listId,
        name: name,
        description: description,
        color: color,
        icon: icon,
      );
      if (!mounted) return updatedList;

      // Mettre à jour la liste dans l'état
      final currentLists = state.valueOrNull ?? [];
      final updatedLists = currentLists.map((l) {
        if (l.id == listId) return updatedList;
        return l;
      }).toList();

      _publish(AsyncValue.data(updatedLists));

      return updatedList;
    } catch (e, stack) {
      debugPrint('Error updating favorite list: $e');
      Error.throwWithStackTrace(e, stack);
    }
  }

  /// Supprimer une liste
  Future<bool> deleteList(String listId) async {
    try {
      await _repository.deleteList(listId);
      if (!mounted) return true;

      // Retirer la liste de l'état
      final currentLists = state.valueOrNull ?? [];
      final updatedLists = currentLists.where((l) => l.id != listId).toList();
      _publish(AsyncValue.data(updatedLists));

      return true;
    } catch (e, stack) {
      debugPrint('Error deleting favorite list: $e');
      Error.throwWithStackTrace(e, stack);
    }
  }

  /// Réordonner les listes
  Future<bool> reorderLists(List<String> orderedIds) async {
    // Optimistic update
    final currentLists = state.valueOrNull ?? [];
    final reorderedLists = <FavoriteList>[];

    for (final id in orderedIds) {
      final list = currentLists.firstWhere(
        (l) => l.id == id,
        orElse: () => throw Exception('List not found: $id'),
      );
      reorderedLists.add(list.copyWith(sortOrder: reorderedLists.length));
    }

    _publish(AsyncValue.data(reorderedLists));
    final optimisticRevision = _stateRevision;

    try {
      await _repository.reorderLists(orderedIds);
      return true;
    } catch (e) {
      debugPrint('Error reordering lists: $e');
      // Revert only while this exact optimistic snapshot still owns state.
      // A disposed notifier belongs to the previous account.
      if (mounted && _stateRevision == optimisticRevision) {
        _publish(AsyncValue.data(currentLists));
      }
      return false;
    }
  }

  /// Obtenir une liste par son ID
  FavoriteList? getListById(String listId) {
    return state.valueOrNull?.firstWhere(
      (l) => l.id == listId,
      orElse: () => throw Exception('List not found'),
    );
  }

  /// Incrémenter le compteur d'une liste
  void incrementListCount(String listId) {
    if (!mounted) return;
    final currentLists = state.valueOrNull;
    if (currentLists == null) return;

    final updatedLists = currentLists.map((l) {
      if (l.id == listId) {
        return l.copyWith(favoritesCount: l.favoritesCount + 1);
      }
      return l;
    }).toList();

    _publish(AsyncValue.data(updatedLists));
  }

  /// Décrémenter le compteur d'une liste
  void decrementListCount(String listId) {
    if (!mounted) return;
    final currentLists = state.valueOrNull;
    if (currentLists == null) return;

    final updatedLists = currentLists.map((l) {
      if (l.id == listId && l.favoritesCount > 0) {
        return l.copyWith(favoritesCount: l.favoritesCount - 1);
      }
      return l;
    }).toList();

    _publish(AsyncValue.data(updatedLists));
  }
}

/// Provider pour le compteur total de favoris
final totalFavoritesCountProvider = Provider<int>((ref) {
  final lists = ref.watch(favoriteListsProvider);
  return lists.when(
    data: (lists) => lists.fold(0, (sum, list) => sum + list.favoritesCount),
    loading: () => 0,
    error: (_, __) => 0,
  );
});
