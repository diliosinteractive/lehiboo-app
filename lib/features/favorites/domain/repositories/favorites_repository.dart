import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../events/domain/entities/event.dart';
import '../entities/favorite_list.dart';

abstract class FavoritesRepository {
  // Favoris
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  Future<List<Event>> getFavorites({String? listId});
  Future<void> addToFavorites(String eventUuid, {String? listId});
  Future<void> removeFromFavorites(String eventUuid);
  Future<bool> isFavorite(String eventUuid);
  Future<bool> toggleFavorite(String eventUuid, {String? listId});
  Future<void> moveFavoriteToList(String eventUuid, String? listId);

  // Listes
  Future<List<FavoriteList>> getLists();
  Future<FavoriteList> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  });
  Future<FavoriteList> getListDetails(String listId);
  Future<FavoriteList> updateList(
    String listId, {
    String? name,
    String? description,
    String? color,
    String? icon,
  });
  Future<void> deleteList(String listId);
  Future<void> reorderLists(List<String> orderedIds);
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  throw UnimplementedError('favoritesRepositoryProvider not initialized');
});
