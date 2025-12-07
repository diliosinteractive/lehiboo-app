import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../events/domain/entities/event.dart';

abstract class FavoritesRepository {
  Future<List<Event>> getFavorites();
  Future<void> addToFavorites(int eventId);
  Future<void> removeFromFavorites(int eventId);
  Future<bool> isFavorite(int eventId);
  Future<bool> toggleFavorite(int eventId);
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  throw UnimplementedError('favoritesRepositoryProvider not initialized');
});
