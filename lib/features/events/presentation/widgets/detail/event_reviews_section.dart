import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/themes/colors.dart';
import '../../../data/models/event_review_dto.dart';
import '../../providers/event_social_providers.dart';
import '../shared/rating_stars.dart';

/// Section complète des avis - Version connectée à l'API
class EventReviewsSection extends ConsumerWidget {
  final String eventSlug;
  final VoidCallback? onWriteReview;
  final VoidCallback? onViewAll;

  const EventReviewsSection({
    super.key,
    required this.eventSlug,
    this.onWriteReview,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(eventReviewStatsProvider(eventSlug));
    final reviewsAsync = ref.watch(
      eventReviewsProvider(EventReviewsParams(eventSlug: eventSlug, perPage: 3)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(statsAsync),
        const SizedBox(height: 16),

        // Contenu
        statsAsync.when(
          loading: () => _buildLoading(),
          error: (error, _) => _buildError(error.toString()),
          data: (stats) {
            return reviewsAsync.when(
              loading: () => _buildLoading(),
              error: (error, _) => _buildError(error.toString()),
              data: (response) {
                if (stats.totalReviews == 0 && stats.totalReviewsCamel == 0) {
                  return _buildEmpty();
                }
                return _buildContent(ref, stats, response.data);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(AsyncValue<ReviewStatsDto> statsAsync) {
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
                data: (stats) {
                  final total = stats.totalReviews > 0 ? stats.totalReviews : stats.totalReviewsCamel;
                  if (total > 0) {
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
                          '$total',
                          style: const TextStyle(
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          if (onWriteReview != null)
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
        child: CircularProgressIndicator(
          color: HbColors.brandPrimary,
        ),
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
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
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
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade600,
              ),
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'Aucun avis pour le moment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Soyez le premier à donner votre avis !',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            if (onWriteReview != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onWriteReview!();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Écrire un avis'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    WidgetRef ref,
    ReviewStatsDto stats,
    List<EventReviewDto> reviews,
  ) {
    final total = stats.totalReviews > 0 ? stats.totalReviews : stats.totalReviewsCamel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Stats card
          _buildStatsCard(stats),
          const SizedBox(height: 16),

          // Preview des avis (max 3)
          ...reviews.take(3).map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(
                review: review,
                onVote: (reviewUuid, isHelpful) {
                  ref.read(eventReviewsNotifierProvider.notifier).voteReview(
                        reviewUuid,
                        isHelpful: isHelpful,
                      );
                },
              ),
            );
          }),

          // Bouton voir tous
          if (total > 3)
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
                  Text('Voir tous les avis ($total)'),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ReviewStatsDto stats) {
    final avgRating = stats.averageRating > 0 ? stats.averageRating : stats.averageRatingCamel;
    final total = stats.totalReviews > 0 ? stats.totalReviews : stats.totalReviewsCamel;

    // Convertir les clés String en int pour la distribution
    final distribution = <int, int>{};
    for (final entry in stats.distribution.entries) {
      final key = int.tryParse(entry.key);
      if (key != null) {
        distribution[key] = entry.value;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Score global
          Column(
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              RatingStars(
                rating: avgRating,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                '$total avis',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),

          // Distribution
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: RatingDistributionBar(
                    starCount: star,
                    count: distribution[star] ?? 0,
                    total: total,
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

/// Card individuelle pour un avis
class ReviewCard extends StatelessWidget {
  final EventReviewDto review;
  final Function(String reviewUuid, bool isHelpful)? onVote;
  final bool showFull;

  const ReviewCard({
    super.key,
    required this.review,
    this.onVote,
    this.showFull = false,
  });

  @override
  Widget build(BuildContext context) {
    final helpfulCount = review.helpfulCount > 0 ? review.helpfulCount : review.helpfulCountCamel;
    final notHelpfulCount = review.notHelpfulCount > 0 ? review.notHelpfulCount : review.notHelpfulCountCamel;
    final isVerified = review.isVerifiedPurchase || review.isVerifiedPurchaseCamel;
    final createdAt = review.createdAtFormatted.isNotEmpty
        ? review.createdAtFormatted
        : review.createdAtFormattedCamel;
    final userVote = review.userVote ?? review.userVoteCamel;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Nom + Rating + Date
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.1),
                backgroundImage: review.author?.avatar != null
                    ? NetworkImage(review.author!.avatar!)
                    : null,
                child: review.author?.avatar == null
                    ? Text(
                        review.author?.initials ?? '?',
                        style: const TextStyle(
                          color: HbColors.brandPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Nom et badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            review.author?.name ?? 'Anonyme',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: HbColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 10,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'Vérifié',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      createdAt,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              RatingStars(
                rating: review.rating.toDouble(),
                size: 14,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Titre (optionnel)
          if (review.title != null && review.title!.isNotEmpty) ...[
            Text(
              review.title!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
          ],

          // Commentaire
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            maxLines: showFull ? null : 4,
            overflow: showFull ? null : TextOverflow.ellipsis,
          ),

          // Réponse de l'organisateur
          if (review.response != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(
                    color: HbColors.brandPrimary,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.reply,
                        size: 14,
                        color: HbColors.brandPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Réponse de ${review.response!.organizationName.isNotEmpty ? review.response!.organizationName : review.response!.organizationNameCamel}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: HbColors.brandPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.response!.response,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Actions: Utile / Pas utile
          if (onVote != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _buildVoteButton(
                  icon: Icons.thumb_up_outlined,
                  activeIcon: Icons.thumb_up,
                  count: helpfulCount,
                  isActive: userVote == true,
                  onTap: () => onVote!(review.uuid, true),
                ),
                const SizedBox(width: 16),
                _buildVoteButton(
                  icon: Icons.thumb_down_outlined,
                  activeIcon: Icons.thumb_down,
                  count: notHelpfulCount,
                  isActive: userVote == false,
                  onTap: () => onVote!(review.uuid, false),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoteButton({
    required IconData icon,
    required IconData activeIcon,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? HbColors.brandPrimary.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 16,
              color: isActive ? HbColors.brandPrimary : Colors.grey.shade600,
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? HbColors.brandPrimary : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Barre de distribution pour les étoiles
class RatingDistributionBar extends StatelessWidget {
  final int starCount;
  final int count;
  final int total;

  const RatingDistributionBar({
    super.key,
    required this.starCount,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            '$starCount',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const Icon(Icons.star, size: 12, color: Colors.amber),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
