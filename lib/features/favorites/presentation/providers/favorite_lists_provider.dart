import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/entities/favorite_list.dart';
import '../../domain/repositories/favorites_repository.dart';

/// Provider pour la liste sélectionnée (filtrage)
/// null = tous les favoris
/// 'uncategorized' = non classés
/// 'uuid' = liste spécifique
final selectedFavoriteListProvider = StateProvider<String?>((ref) => null);

/// Provider pour les listes de favoris
final favoriteListsProvider =
    StateNotifierProvider<FavoriteListsNotifier, AsyncValue<List<FavoriteList>>>(
  (ref) {
    final repository = ref.watch(favoritesRepositoryImplProvider);
    return FavoriteListsNotifier(repository);
  },
);

/// Notifier pour gérer l'état des listes de favoris
class FavoriteListsNotifier extends StateNotifier<AsyncValue<List<FavoriteList>>> {
  final FavoritesRepository _repository;

  FavoriteListsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadLists();
  }

  /// Charger les listes depuis l'API
  Future<void> loadLists() async {
    try {
      state = const AsyncValue.loading();
      final lists = await _repository.getLists();
      state = AsyncValue.data(lists);
    } catch (e, stack) {
      debugPrint('Error loading favorite lists: $e');
      state = AsyncValue.error(e, stack);
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

      // Ajouter la nouvelle liste à l'état actuel
      final currentLists = state.value ?? [];
      state = AsyncValue.data([...currentLists, newList]);

      return newList;
    } catch (e) {
      debugPrint('Error creating favorite list: $e');
      return null;
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

      // Mettre à jour la liste dans l'état
      final currentLists = state.value ?? [];
      final updatedLists = currentLists.map((l) {
        if (l.id == listId) return updatedList;
        return l;
      }).toList();

      state = AsyncValue.data(updatedLists);

      return updatedList;
    } catch (e) {
      debugPrint('Error updating favorite list: $e');
      return null;
    }
  }

  /// Supprimer une liste
  Future<bool> deleteList(String listId) async {
    try {
      await _repository.deleteList(listId);

      // Retirer la liste de l'état
      final currentLists = state.value ?? [];
      final updatedLists = currentLists.where((l) => l.id != listId).toList();
      state = AsyncValue.data(updatedLists);

      return true;
    } catch (e) {
      debugPrint('Error deleting favorite list: $e');
      return false;
    }
  }

  /// Réordonner les listes
  Future<bool> reorderLists(List<String> orderedIds) async {
    // Optimistic update
    final currentLists = state.value ?? [];
    final reorderedLists = <FavoriteList>[];

    for (final id in orderedIds) {
      final list = currentLists.firstWhere(
        (l) => l.id == id,
        orElse: () => throw Exception('List not found: $id'),
      );
      reorderedLists.add(list.copyWith(sortOrder: reorderedLists.length));
    }

    state = AsyncValue.data(reorderedLists);

    try {
      await _repository.reorderLists(orderedIds);
      return true;
    } catch (e) {
      debugPrint('Error reordering lists: $e');
      // Revert on error
      state = AsyncValue.data(currentLists);
      return false;
    }
  }

  /// Obtenir une liste par son ID
  FavoriteList? getListById(String listId) {
    return state.value?.firstWhere(
      (l) => l.id == listId,
      orElse: () => throw Exception('List not found'),
    );
  }

  /// Incrémenter le compteur d'une liste
  void incrementListCount(String listId) {
    final currentLists = state.value;
    if (currentLists == null) return;

    final updatedLists = currentLists.map((l) {
      if (l.id == listId) {
        return l.copyWith(favoritesCount: l.favoritesCount + 1);
      }
      return l;
    }).toList();

    state = AsyncValue.data(updatedLists);
  }

  /// Décrémenter le compteur d'une liste
  void decrementListCount(String listId) {
    final currentLists = state.value;
    if (currentLists == null) return;

    final updatedLists = currentLists.map((l) {
      if (l.id == listId && l.favoritesCount > 0) {
        return l.copyWith(favoritesCount: l.favoritesCount - 1);
      }
      return l;
    }).toList();

    state = AsyncValue.data(updatedLists);
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
