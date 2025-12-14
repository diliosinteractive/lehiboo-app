import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../data/repositories/favorites_repository_impl.dart';

// StateNotifier to manage list of favorite events
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      state = const AsyncValue.loading();
      final favorites = await _repository.getFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(Event event) async {
    final eventId = int.tryParse(event.id);
    if (eventId == null) return;

    // Optimistic update
    final currentList = state.value ?? [];
    final isFav = currentList.any((e) => e.id == event.id);

    List<Event> newList;
    if (isFav) {
      newList = currentList.where((e) => e.id != event.id).toList();
    } else {
      newList = [...currentList, event.copyWith(isFavorite: true)];
    }
    state = AsyncValue.data(newList);

    try {
      await _repository.toggleFavorite(eventId);
      // Optional: reload to ensure sync, but optimistic is usually enough
      // await loadFavorites(); 
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentList);
      // You might want to show a snackbar here via a listener or separate state
    }
  }

  bool isFavorite(String eventId) {
    return state.value?.any((e) => e.id == eventId) ?? false;
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Event>>>((ref) {
  final repository = ref.watch(favoritesRepositoryImplProvider);
  return FavoritesNotifier(repository);
});
