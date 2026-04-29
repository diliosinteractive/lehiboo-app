import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/reviews_providers.dart';
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
    final statsAsync = ref.watch(eventReviewStatsProvider(eventSlug));
    final reviewsAsync = ref.watch(
      eventReviewsProvider(EventReviewsParams(
        eventSlug: eventSlug,
        query: const ReviewsQuery(perPage: 3),
      )),
    );
    final canReviewAsync = ref.watch(canReviewProvider(eventSlug));
    // Si l'utilisateur a déjà laissé un avis, on récupère son existingReview
    // depuis can-review pour l'afficher en tête de section (pattern Q&A
    // "Votre question").
    final myReview = canReviewAsync.maybeWhen(
      data: (r) => r is CanReviewDenied ? r.existingReview : null,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pattern Q&A : le bouton "Écrire" est toujours visible, sauf si
        // l'utilisateur a déjà un avis (entry-point d'édition dans le bloc
        // "Votre avis"). Le tap est protégé par GuestGuard côté parent —
        // les non-authentifiés sont invités à se connecter.
        _buildHeader(statsAsync, hasMyReview: myReview != null),
        const SizedBox(height: 16),
        statsAsync.when(
          loading: _buildLoading,
          error: (e, _) => _buildError(e.toString()),
          data: (stats) {
            return reviewsAsync.when(
              loading: _buildLoading,
              error: (e, _) => _buildError(e.toString()),
              data: (page) {
                // Évite le doublon : si l'avis user est déjà dans la liste
                // publique (status approved), on le retire du bloc dédié.
                final myInList = myReview != null &&
                    page.items.any((r) => r.uuid == myReview.uuid);
                final myReviewToShow = myInList ? null : myReview;

                if (!stats.hasReviews && myReviewToShow == null) {
                  return _buildEmpty();
                }
                return _buildContent(
                  ref,
                  stats,
                  page.items,
                  myReview: myReviewToShow,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(
    AsyncValue<ReviewStats> statsAsync, {
    bool hasMyReview = false,
  }) {
    final hasReviews = statsAsync.maybeWhen(
      data: (s) => s.hasReviews,
      orElse: () => true,
    );
    // Pas besoin du bouton "Écrire" en header quand l'utilisateur a déjà
    // son bloc "Votre avis" en haut de la section (qui contient déjà Modifier).
    final showWriteButton =
        onWriteReview != null && hasReviews && !hasMyReview;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Avis',
                style: TextStyle(
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
                          horizontal: 8, vertical: 4),
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
              label: const Text('Écrire'),
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

  Widget _buildError(String message) {
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
              'Erreur de chargement',
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

  Widget _buildEmpty() {
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
            const Text(
              'Pas encore d\'avis',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Partagez votre expérience et\naidez les autres à choisir !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: HbColors.grey500,
                height: 1.4,
              ),
            ),
            if (onWriteReview != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Écrire le premier avis'),
                style: FilledButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
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
    WidgetRef ref,
    ReviewStats stats,
    List<Review> reviews, {
    Review? myReview,
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
            ),
          if (stats.hasReviews) ...[
            ReviewStatsCard(stats: stats),
            const SizedBox(height: 16),
          ],
          ...reviews.take(3).map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(
                review: review,
                onVote: (uuid, isHelpful) {
                  ref.read(reviewsActionsProvider.notifier).voteReview(
                        reviewUuid: uuid,
                        isHelpful: isHelpful,
                        eventSlug: eventSlug,
                      );
                },
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
                  Text('Voir tous les avis (${stats.totalReviews})'),
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
                '${stats.totalReviews} avis',
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
