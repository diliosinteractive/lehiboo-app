import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
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
  final AuthSessionKey _ownerSession;

  ReviewsActionsNotifier(
    this._repo,
    this._ref, {
    required AuthSessionKey ownerSession,
  })  : _ownerSession = ownerSession,
        super(const AsyncValue.data(null));

  String? get _accountId => _ownerSession.accountId;

  bool get _ownsActiveSession =>
      mounted &&
      _accountId != null &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession);

  ReviewActionFailure<T> _sessionChanged<T>() =>
      ReviewActionFailure<T>(authSessionExpiredMessage);

  bool _canPublish() => _ownsActiveSession;

  void _setState(AsyncValue<void> value) {
    if (_canPublish()) state = value;
  }

  void _invalidateAfterMutation({String? eventSlug}) {
    if (!_canPublish()) return;
    if (eventSlug != null) {
      _ref.invalidate(eventReviewStatsProvider(eventSlug));
      _ref.invalidate(
        canReviewProvider(
          CanReviewParams(
            eventSlug: eventSlug,
            ownerSession: _ownerSession,
          ),
        ),
      );
    }
    _ref.invalidate(eventReviewsProvider);
    _ref.invalidate(pendingReviewCountProvider(_ownerSession));
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
    if (!_ownsActiveSession) return _sessionChanged();
    _setState(const AsyncValue.loading());
    try {
      final review = await _repo.createReview(
        eventSlug,
        rating: rating,
        title: title,
        comment: comment,
        bookingUuid: bookingUuid,
      );
      if (!_ownsActiveSession) return _sessionChanged();
      _setState(const AsyncValue.data(null));
      _invalidateAfterMutation(eventSlug: eventSlug);
      return ReviewActionSuccess(review);
    } catch (e, st) {
      if (!_ownsActiveSession) return _sessionChanged();
      _setState(AsyncValue.error(e, st));
      return ReviewActionFailure(
        _messageFor(e, cachedAppLocalizations().reviewsCreateFailed),
        e,
      );
    }
  }

  Future<ReviewActionResult<Review>> updateReview({
    required String reviewUuid,
    String? eventSlug,
    int? rating,
    String? title,
    String? comment,
  }) async {
    if (!_ownsActiveSession) return _sessionChanged();
    _setState(const AsyncValue.loading());
    try {
      final review = await _repo.updateReview(
        reviewUuid,
        rating: rating,
        title: title,
        comment: comment,
      );
      if (!_ownsActiveSession) return _sessionChanged();
      _setState(const AsyncValue.data(null));
      _invalidateAfterMutation(eventSlug: eventSlug);
      return ReviewActionSuccess(review);
    } catch (e, st) {
      if (!_ownsActiveSession) return _sessionChanged();
      _setState(AsyncValue.error(e, st));
      return ReviewActionFailure(
        _messageFor(e, cachedAppLocalizations().reviewsUpdateFailed),
        e,
      );
    }
  }

  Future<ReviewActionResult<void>> deleteReview({
    required String reviewUuid,
    String? eventSlug,
  }) async {
    if (!_ownsActiveSession) return _sessionChanged();
    try {
      await _repo.deleteReview(reviewUuid);
      if (!_ownsActiveSession) return _sessionChanged();
      _invalidateAfterMutation(eventSlug: eventSlug);
      return const ReviewActionSuccess(null);
    } catch (e) {
      if (!_ownsActiveSession) return _sessionChanged();
      return ReviewActionFailure(
        _messageFor(e, cachedAppLocalizations().reviewsDeleteFailed),
        e,
      );
    }
  }

  Future<ReviewActionResult<VoteCounts>> voteReview({
    required String reviewUuid,
    required bool isHelpful,
    String? eventSlug,
  }) async {
    if (!_ownsActiveSession) return _sessionChanged();
    try {
      final counts = await _repo.voteReview(
        reviewUuid,
        isHelpful: isHelpful,
      );
      if (!_ownsActiveSession) return _sessionChanged();
      // Vote callers apply these server-authoritative counters immediately.
      // Invalidating here would dispose their optimistic card before they can
      // reconcile or roll it back.
      return ReviewActionSuccess(counts);
    } catch (e) {
      if (!_ownsActiveSession) return _sessionChanged();
      return ReviewActionFailure(
        _messageFor(e, cachedAppLocalizations().reviewsVoteFailed),
        e,
      );
    }
  }

  Future<ReviewActionResult<VoteCounts>> unvoteReview({
    required String reviewUuid,
    String? eventSlug,
  }) async {
    if (!_ownsActiveSession) return _sessionChanged();
    try {
      final counts = await _repo.unvoteReview(reviewUuid);
      if (!_ownsActiveSession) return _sessionChanged();
      return ReviewActionSuccess(counts);
    } catch (e) {
      if (!_ownsActiveSession) return _sessionChanged();
      return ReviewActionFailure(
        _messageFor(e, cachedAppLocalizations().reviewsVoteFailed),
        e,
      );
    }
  }

  Future<ReviewActionResult<void>> reportReview({
    required String reviewUuid,
    required ReportReason reason,
    String? details,
  }) async {
    if (!_ownsActiveSession) return _sessionChanged();
    try {
      await _repo.reportReview(
        reviewUuid,
        reason: reason,
        details: details,
      );
      if (!_ownsActiveSession) return _sessionChanged();
      return const ReviewActionSuccess(null);
    } catch (e) {
      if (!_ownsActiveSession) return _sessionChanged();
      return ReviewActionFailure(
        _messageFor(e, cachedAppLocalizations().reviewsReportFailed),
        e,
      );
    }
  }

  String _messageFor(Object error, String fallback) {
    debugPrint('ReviewsActionsNotifier error: $error');
    return ApiResponseHandler.extractError(error, fallback: fallback);
  }
}

final reviewsActionsProvider =
    StateNotifierProvider<ReviewsActionsNotifier, AsyncValue<void>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repo = ref.watch(reviewsRepositoryProvider);
  return ReviewsActionsNotifier(repo, ref, ownerSession: ownerSession);
});
