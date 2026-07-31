import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
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
  final String? loadMoreError;

  const UserReviewsState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
    this.loadMoreError,
  });

  bool get isEmpty => items.isEmpty && !isLoading && error == null;

  UserReviewsState copyWith({
    List<UserReview>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    Object? error = _sentinel,
    Object? loadMoreError = _sentinel,
  }) {
    return UserReviewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: identical(error, _sentinel) ? this.error : error as String?,
      loadMoreError: identical(loadMoreError, _sentinel)
          ? this.loadMoreError
          : loadMoreError as String?,
    );
  }
}

const Object _sentinel = Object();

class UserReviewsNotifier extends StateNotifier<UserReviewsState> {
  final ReviewsRepository _repo;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;
  static const int _perPage = 10;

  UserReviewsNotifier(
    this._repo, {
    required Ref ref,
    required AuthSessionKey ownerSession,
  })  : _ref = ref,
        _ownerSession = ownerSession,
        super(const UserReviewsState()) {
    if (_hasActiveAccount) refresh();
  }

  bool get _hasActiveAccount => _ownerSession.accountId != null;

  bool get _ownsActiveSession =>
      mounted && identical(_ref.read(authSessionKeyProvider), _ownerSession);

  Future<void> refresh() async {
    if (!_ownsActiveSession) return;
    final requestGeneration = ++_requestGeneration;
    if (!_hasActiveAccount) {
      state = const UserReviewsState();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      loadMoreError: null,
    );
    try {
      final page = await _repo.getUserReviews(page: 1, perPage: _perPage);
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = state.copyWith(
        items: page.items,
        isLoading: false,
        currentPage: page.meta.currentPage,
        hasMore: page.meta.hasMore,
      );
    } catch (e) {
      debugPrint('UserReviewsNotifier.refresh error: $e');
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        error: cachedAppLocalizations().reviewsUserLoadError,
      );
    }
  }

  Future<void> loadMore() async {
    if (!_ownsActiveSession || !_hasActiveAccount) return;
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.isLoading ||
        state.loadMoreError != null) {
      return;
    }
    final requestGeneration = ++_requestGeneration;
    final nextPage = state.currentPage + 1;
    state = state.copyWith(isLoadingMore: true, loadMoreError: null);
    try {
      final next = await _repo.getUserReviews(
        page: nextPage,
        perPage: _perPage,
      );
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = state.copyWith(
        items: [...state.items, ...next.items],
        isLoadingMore: false,
        currentPage: next.meta.currentPage,
        hasMore: next.meta.hasMore,
        loadMoreError: null,
      );
    } catch (e) {
      debugPrint('UserReviewsNotifier.loadMore error: $e');
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: cachedAppLocalizations().reviewsUserLoadMoreError,
      );
    }
  }

  Future<void> retryLoadMore() async {
    if (!_ownsActiveSession) return;
    state = state.copyWith(loadMoreError: null);
    await loadMore();
  }

  /// Optimistic remove (utilisé après suppression confirmée d'un avis).
  void removeLocal(String reviewUuid) {
    if (!_ownsActiveSession) return;
    _requestGeneration++;
    state = state.copyWith(
      items: state.items.where((r) => r.uuid != reviewUuid).toList(),
    );
  }

  /// Optimistic update (utilisé après édition d'un avis).
  void updateLocal(UserReview updated) {
    if (!_ownsActiveSession) return;
    _requestGeneration++;
    state = state.copyWith(
      items:
          state.items.map((r) => r.uuid == updated.uuid ? updated : r).toList(),
    );
  }
}

final userReviewsProvider =
    StateNotifierProvider<UserReviewsNotifier, UserReviewsState>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repo = ref.watch(reviewsRepositoryProvider);
  return UserReviewsNotifier(
    repo,
    ref: ref,
    ownerSession: ownerSession,
  );
});

/// Helper pour récupérer un PaginatedUserReviews factice depuis le state.
extension UserReviewsStateX on UserReviewsState {
  PaginatedUserReviews toPage() => PaginatedUserReviews(items: items);
}
