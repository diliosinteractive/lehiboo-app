import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/api_response_handler.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_enums.dart';
import '../../domain/repositories/reviews_repository.dart';
import 'pending_count_provider.dart';
import 'reviews_providers.dart';
import 'user_reviews_provider.dart';

/// Résultat typé d'une mutation pour permettre une UX adaptée
/// (vs simplement true/false).
sealed class ReviewActionResult<T> {
  const ReviewActionResult();
}

class ReviewActionSuccess<T> extends ReviewActionResult<T> {
  final T value;
  const ReviewActionSuccess(this.value);
}

class ReviewActionFailure<T> extends ReviewActionResult<T> {
  final String message;
  final Object? error;
  const ReviewActionFailure(this.message, [this.error]);
}

/// Notifier pour TOUTES les mutations sur les avis : create, update, delete,
/// vote, unvote, report. Invalide les providers de lecture concernés après
/// chaque mutation réussie.
///
/// **Pas autoDispose** : les écrans qui dispatchent des mutations utilisent
/// `ref.read(provider.notifier)`, qui ne garde pas le provider alive. Les
/// modals (write/report sheets) peuvent être disposés avant la fin de l'await,
/// d'où le besoin que ce notifier survive de manière indépendante.
class ReviewsActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ReviewsRepository _repo;
  final Ref _ref;

  ReviewsActionsNotifier(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  void _setState(AsyncValue<void> value) {
    if (mounted) state = value;
  }

  void _invalidateAfterMutation({String? eventSlug}) {
    if (!mounted) return;
    if (eventSlug != null) {
      _ref.invalidate(eventReviewStatsProvider(eventSlug));
      _ref.invalidate(canReviewProvider(eventSlug));
    }
    _ref.invalidate(eventReviewsProvider);
    _ref.invalidate(pendingReviewCountProvider);
    // Refresh user reviews list (best-effort).
    try {
      _ref.read(userReviewsProvider.notifier).refresh();
    } catch (_) {
      // Provider may not be initialized yet — safe to ignore.
    }
  }

  Future<ReviewActionResult<Review>> createReview({
    required String eventSlug,
    required int rating,
    required String title,
    required String comment,
    String? bookingUuid,
  }) async {
    _setState(const AsyncValue.loading());
    try {
      final review = await _repo.createReview(
        eventSlug,
        rating: rating,
        title: title,
        comment: comment,
        bookingUuid: bookingUuid,
      );
      _setState(const AsyncValue.data(null));
      _invalidateAfterMutation(eventSlug: eventSlug);
      return ReviewActionSuccess(review);
    } catch (e, st) {
      _setState(AsyncValue.error(e, st));
      return ReviewActionFailure(_messageFor(e), e);
    }
  }

  Future<ReviewActionResult<Review>> updateReview({
    required String reviewUuid,
    String? eventSlug,
    int? rating,
    String? title,
    String? comment,
  }) async {
    _setState(const AsyncValue.loading());
    try {
      final review = await _repo.updateReview(
        reviewUuid,
        rating: rating,
        title: title,
        comment: comment,
      );
      _setState(const AsyncValue.data(null));
      _invalidateAfterMutation(eventSlug: eventSlug);
      return ReviewActionSuccess(review);
    } catch (e, st) {
      _setState(AsyncValue.error(e, st));
      return ReviewActionFailure(_messageFor(e), e);
    }
  }

  Future<ReviewActionResult<void>> deleteReview({
    required String reviewUuid,
    String? eventSlug,
  }) async {
    try {
      await _repo.deleteReview(reviewUuid);
      _invalidateAfterMutation(eventSlug: eventSlug);
      return const ReviewActionSuccess(null);
    } catch (e) {
      return ReviewActionFailure(_messageFor(e), e);
    }
  }

  Future<ReviewActionResult<VoteCounts>> voteReview({
    required String reviewUuid,
    required bool isHelpful,
    String? eventSlug,
  }) async {
    try {
      final counts = await _repo.voteReview(
        reviewUuid,
        isHelpful: isHelpful,
      );
      if (mounted && eventSlug != null) {
        _ref.invalidate(eventReviewsProvider);
      }
      return ReviewActionSuccess(counts);
    } catch (e) {
      return ReviewActionFailure(_messageFor(e), e);
    }
  }

  Future<ReviewActionResult<VoteCounts>> unvoteReview({
    required String reviewUuid,
    String? eventSlug,
  }) async {
    try {
      final counts = await _repo.unvoteReview(reviewUuid);
      if (mounted && eventSlug != null) {
        _ref.invalidate(eventReviewsProvider);
      }
      return ReviewActionSuccess(counts);
    } catch (e) {
      return ReviewActionFailure(_messageFor(e), e);
    }
  }

  Future<ReviewActionResult<void>> reportReview({
    required String reviewUuid,
    required ReportReason reason,
    String? details,
  }) async {
    try {
      await _repo.reportReview(
        reviewUuid,
        reason: reason,
        details: details,
      );
      return const ReviewActionSuccess(null);
    } catch (e) {
      return ReviewActionFailure(_messageFor(e), e);
    }
  }

  String _messageFor(Object error) {
    debugPrint('ReviewsActionsNotifier error: $error');
    if (error is DioException) {
      return ApiResponseHandler.extractError(error);
    }
    return ApiResponseHandler.extractError(error);
  }
}

final reviewsActionsProvider =
    StateNotifierProvider<ReviewsActionsNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(reviewsRepositoryProvider);
  return ReviewsActionsNotifier(repo, ref);
});
