import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/user_review.dart';
import '../../domain/repositories/reviews_repository.dart';

/// État de la liste paginée "Mes Avis".
class UserReviewsState {
  final List<UserReview> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const UserReviewsState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  bool get isEmpty => items.isEmpty && !isLoading && error == null;

  UserReviewsState copyWith({
    List<UserReview>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    Object? error = _sentinel,
  }) {
    return UserReviewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }
}

const Object _sentinel = Object();

class UserReviewsNotifier extends StateNotifier<UserReviewsState> {
  final ReviewsRepository _repo;
  final Ref _ref;
  static const int _perPage = 10;

  UserReviewsNotifier(this._repo, this._ref) : super(const UserReviewsState()) {
    refresh();
    _ref.listen<AuthStatus>(
      authProvider.select((s) => s.status),
      (previous, next) {
        final loggedOut = next == AuthStatus.unauthenticated &&
            previous == AuthStatus.authenticated;
        final loggedIn = next == AuthStatus.authenticated &&
            previous != AuthStatus.authenticated &&
            previous != AuthStatus.initial;
        if (loggedOut) {
          state = const UserReviewsState();
        } else if (loggedIn) {
          refresh();
        }
      },
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final page = await _repo.getUserReviews(page: 1, perPage: _perPage);
      state = state.copyWith(
        items: page.items,
        isLoading: false,
        currentPage: page.meta.currentPage,
        hasMore: page.meta.hasMore,
      );
    } catch (e) {
      debugPrint('UserReviewsNotifier.refresh error: $e');
      state = state.copyWith(
        isLoading: false,
        error: cachedAppLocalizations().reviewsUserLoadError,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final next = await _repo.getUserReviews(
        page: state.currentPage + 1,
        perPage: _perPage,
      );
      state = state.copyWith(
        items: [...state.items, ...next.items],
        isLoadingMore: false,
        currentPage: next.meta.currentPage,
        hasMore: next.meta.hasMore,
      );
    } catch (e) {
      debugPrint('UserReviewsNotifier.loadMore error: $e');
      state = state.copyWith(
        isLoadingMore: false,
        error: cachedAppLocalizations().reviewsUserLoadMoreError,
      );
    }
  }

  /// Optimistic remove (utilisé après suppression confirmée d'un avis).
  void removeLocal(String reviewUuid) {
    state = state.copyWith(
      items: state.items.where((r) => r.uuid != reviewUuid).toList(),
    );
  }

  /// Optimistic update (utilisé après édition d'un avis).
  void updateLocal(UserReview updated) {
    state = state.copyWith(
      items:
          state.items.map((r) => r.uuid == updated.uuid ? updated : r).toList(),
    );
  }
}

final userReviewsProvider =
    StateNotifierProvider<UserReviewsNotifier, UserReviewsState>((ref) {
  final repo = ref.watch(reviewsRepositoryProvider);
  return UserReviewsNotifier(repo, ref);
});

/// Helper pour récupérer un PaginatedUserReviews factice depuis le state.
extension UserReviewsStateX on UserReviewsState {
  PaginatedUserReviews toPage() => PaginatedUserReviews(items: items);
}
