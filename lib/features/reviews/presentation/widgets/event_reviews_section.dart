import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_enums.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/reviews_providers.dart';
import 'can_review_message.dart';
import 'my_review_block.dart';
import 'rating_stars.dart';
import 'review_card.dart';

/// Section "Avis" de la fiche événement.
///
/// Affiche stats + 3 reviews + CTA. Le bouton "Écrire" n'apparaît que si
/// `canReview` est `Allowed`. Sinon, affiche un message contextuel ([reason]).
class EventReviewsSection extends ConsumerWidget {
  final String eventSlug;
  final String eventTitle;
  final VoidCallback? onWriteReview;
  final VoidCallback? onViewAll;

  const EventReviewsSection({
    super.key,
    required this.eventSlug,
    this.eventTitle = '',
    this.onWriteReview,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewSession = ref.watch(authSessionKeyProvider);
    final statsAsync = ref.watch(eventReviewStatsProvider(eventSlug));
    final reviewsAsync = ref.watch(
      eventReviewsProvider(EventReviewsParams(
        eventSlug: eventSlug,
        ownerSession: viewSession,
        query: const ReviewsQuery(perPage: 3),
      )),
    );
    final canReviewParams = CanReviewParams(
      eventSlug: eventSlug,
      ownerSession: viewSession,
    );
    final canReviewAsync = ref.watch(canReviewProvider(canReviewParams));
    final explicitCanReview = !canReviewAsync.isLoading &&
            !canReviewAsync.hasError &&
            canReviewAsync.hasValue
        ? canReviewAsync.valueOrNull
        : null;
    final canWriteReview = explicitCanReview is CanReviewAllowed;
    // Si l'utilisateur a déjà laissé un avis, on récupère son existingReview
    // depuis can-review pour l'afficher en tête de section (pattern Q&A
    // "Votre question").
    final myReview = explicitCanReview is CanReviewDenied
        ? explicitCanReview.existingReview
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          context,
          statsAsync,
          canWriteReview: canWriteReview,
        ),
        const SizedBox(height: 16),
        canReviewAsync.when(
          skipLoadingOnRefresh: false,
          skipLoadingOnReload: false,
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(context.l10n.reviewsEligibilityChecking),
                ),
              ],
            ),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CanReviewLoadError(
              error: error,
              onRetry: () => ref.invalidate(canReviewProvider(canReviewParams)),
            ),
          ),
          data: (result) => result is CanReviewDenied &&
                  result.reason != CanReviewReason.alreadyReviewed
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CanReviewMessage(denied: result),
                )
              : const SizedBox.shrink(),
        ),
        if (canReviewAsync.isLoading ||
            canReviewAsync.hasError ||
            (explicitCanReview is CanReviewDenied &&
                explicitCanReview.reason != CanReviewReason.alreadyReviewed))
          const SizedBox(height: 16),
        statsAsync.when(
          loading: _buildLoading,
          error: (e, _) => _buildError(
            context,
            ApiResponseHandler.extractError(e),
          ),
          data: (stats) {
            return reviewsAsync.when(
              loading: _buildLoading,
              error: (e, _) => _buildError(
                context,
                ApiResponseHandler.extractError(e),
              ),
              data: (page) {
                // Évite le doublon : si l'avis user est déjà dans la liste
                // publique (status approved), on le retire du bloc dédié.
                final myInList = myReview != null &&
                    page.items.any((r) => r.uuid == myReview.uuid);
                final myReviewToShow = myInList ? null : myReview;

                if (!stats.hasReviews && myReviewToShow == null) {
                  return _buildEmpty(
                    context,
                    canWriteReview: canWriteReview,
                  );
                }
                return _buildContent(
                  context,
                  ref,
                  stats,
                  page.items,
                  myReview: myReviewToShow,
                  viewSession: viewSession,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AsyncValue<ReviewStats> statsAsync, {
    required bool canWriteReview,
  }) {
    final hasReviews = statsAsync.maybeWhen(
      data: (s) => s.hasReviews,
      orElse: () => true,
    );
    final showWriteButton =
        onWriteReview != null && hasReviews && canWriteReview;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                context.l10n.reviewsSectionTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              statsAsync.maybeWhen(
                data: (s) {
                  if (!s.hasReviews) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: HbColors.brandPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${s.totalReviews}',
                        style: const TextStyle(
                          color: HbColors.brandPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          if (showWriteButton)
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onWriteReview!();
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(context.l10n.reviewsWriteAction),
              style: TextButton.styleFrom(
                foregroundColor: HbColors.brandPrimary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: CircularProgressIndicator(color: HbColors.brandPrimary),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(
              context.l10n.organizerReviewsLoadError,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 13, color: Colors.red.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(
    BuildContext context, {
    required bool canWriteReview,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HbColors.grey200),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rate_review_outlined,
                color: HbColors.brandPrimary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.reviewsEmptyTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.reviewsEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: HbColors.grey500,
                height: 1.4,
              ),
            ),
            if (onWriteReview != null && canWriteReview) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(context.l10n.reviewsWriteFirstAction),
                style: FilledButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onWriteReview!();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ReviewStats stats,
    List<Review> reviews, {
    Review? myReview,
    required AuthSessionKey viewSession,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (myReview != null)
            MyReviewBlock(
              review: myReview,
              eventSlug: eventSlug,
              eventTitle: eventTitle,
              ownerSession: viewSession,
            ),
          if (stats.hasReviews) ...[
            ReviewStatsCard(stats: stats),
            const SizedBox(height: 16),
          ],
          ...reviews.take(3).map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _EventSectionReviewCard(
                review: review,
                eventSlug: eventSlug,
                ownerSession: viewSession,
              ),
            );
          }),
          if (stats.totalReviews > 3)
            OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onViewAll?.call();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: HbColors.brandPrimary,
                side: const BorderSide(color: HbColors.brandPrimary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n.reviewsViewAllAction(stats.totalReviews)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EventSectionReviewCard extends ConsumerStatefulWidget {
  final Review review;
  final String eventSlug;
  final AuthSessionKey ownerSession;

  const _EventSectionReviewCard({
    required this.review,
    required this.eventSlug,
    required this.ownerSession,
  });

  @override
  ConsumerState<_EventSectionReviewCard> createState() =>
      _EventSectionReviewCardState();
}

class _EventSectionReviewCardState
    extends ConsumerState<_EventSectionReviewCard> {
  late Review _review = widget.review;
  bool _isVoting = false;

  @override
  void didUpdateWidget(covariant _EventSectionReviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.ownerSession, widget.ownerSession)) {
      _isVoting = false;
      _review = widget.review.copyWith(userVote: null);
      return;
    }
    if (!_isVoting && oldWidget.review != widget.review) {
      _review = widget.review;
    }
  }

  Future<void> _vote(String uuid, bool isHelpful) async {
    if (!mounted) return;
    final renderOwner = widget.ownerSession;
    if (!identical(ref.read(authSessionKeyProvider), renderOwner)) return;
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureVoteReview,
    );
    if (!allowed || !mounted) return;
    final actionOwner = ref.read(authSessionKeyProvider);
    if (actionOwner.accountId == null ||
        (renderOwner.accountId != null &&
            !identical(actionOwner, renderOwner))) {
      return;
    }
    if (_isVoting || _review.userVote != null) return;
    final original = _review;
    setState(() {
      _isVoting = true;
      _review = original.copyWith(
        helpfulCount: original.helpfulCount + (isHelpful ? 1 : 0),
        notHelpfulCount: original.notHelpfulCount + (isHelpful ? 0 : 1),
        userVote: isHelpful,
      );
    });

    final voteFailureFallback = context.l10n.reviewsVoteFailed;
    final actionsNotifier = ref.read(reviewsActionsProvider.notifier);
    ReviewActionResult<VoteCounts> result;
    try {
      result = await actionsNotifier.voteReview(
        reviewUuid: uuid,
        isHelpful: isHelpful,
        eventSlug: widget.eventSlug,
      );
    } catch (error) {
      result = ReviewActionFailure(
        ApiResponseHandler.extractError(
          error,
          fallback: voteFailureFallback,
        ),
        error,
      );
    }

    if (!mounted ||
        !identical(ref.read(authSessionKeyProvider), actionOwner) ||
        !identical(
          ref.read(reviewsActionsProvider.notifier),
          actionsNotifier,
        )) {
      return;
    }
    setState(() {
      _isVoting = false;
      switch (result) {
        case ReviewActionSuccess(value: final counts):
          _review = _review.copyWith(
            helpfulCount: counts.helpfulCount,
            notHelpfulCount: counts.notHelpfulCount,
            userVote: isHelpful,
          );
        case ReviewActionFailure():
          _review = original;
      }
    });

    if (result case ReviewActionFailure(message: final message)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: HbColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReviewCard(
      review: _review,
      onVote: _vote,
      isVotePending: _isVoting,
    );
  }
}

/// Card de statistiques (note moyenne + distribution). Réutilisable sur la
/// full reviews screen.
class ReviewStatsCard extends StatelessWidget {
  final ReviewStats stats;

  const ReviewStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                stats.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              RatingStars(rating: stats.averageRating, size: 18),
              const SizedBox(height: 4),
              Text(
                context.l10n.reviewsTotalCount(stats.totalReviews),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: RatingDistributionBar(
                    starCount: star,
                    count: stats.countForStar(star),
                    total: stats.totalReviews,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
