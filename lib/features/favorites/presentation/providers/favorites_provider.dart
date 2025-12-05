import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage list of favorite activity IDs
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String activityId) {
    if (state.contains(activityId)) {
      state = {...state}..remove(activityId);
    } else {
      state = {...state}..add(activityId);
    }
  }

  bool isFavorite(String activityId) {
    return state.contains(activityId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
