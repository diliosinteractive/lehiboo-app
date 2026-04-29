import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entities/review_enums.dart';
import '../../domain/entities/user_review.dart';
import 'rating_stars.dart';
import 'status_badge.dart';

/// Carte d'un avis dans l'écran "Mes Avis".
///
/// Affiche l'événement (image + titre + organisation) et l'avis avec son
/// statut. Boutons Modifier / Supprimer (et Réécrire si rejeté).
class UserReviewCard extends StatelessWidget {
  final UserReview review;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserReviewCard({
    super.key,
    required this.review,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventHeader(),
              const SizedBox(height: 12),
              Row(
                children: [
                  RatingStars(rating: review.rating.toDouble(), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      review.createdAtFormatted,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  ReviewStatusBadge(status: review.status),
                  if (onEdit != null)
                    _buildIconAction(
                      icon: review.status == ReviewStatus.rejected
                          ? Icons.refresh
                          : Icons.edit_outlined,
                      tooltip: review.status == ReviewStatus.rejected
                          ? 'Réécrire'
                          : 'Modifier',
                      color: HbColors.brandPrimary,
                      onPressed: onEdit!,
                    ),
                  if (onDelete != null)
                    _buildIconAction(
                      icon: Icons.delete_outline,
                      tooltip: 'Supprimer',
                      color: Colors.red.shade400,
                      onPressed: onDelete!,
                    ),
                ],
              ),
              if (review.title.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  review.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                review.comment,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              if (review.hasResponse) ...[
                const SizedBox(height: 8),
                _buildResponseHint(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconAction({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  Widget _buildEventHeader() {
    final cover = review.eventCoverImage;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: cover != null && cover.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: cover,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (_, __, ___) => _coverFallback(),
                )
              : _coverFallback(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.eventTitle.isNotEmpty
                    ? review.eventTitle
                    : 'Événement',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (review.organizationName.isNotEmpty)
                Text(
                  review.organizationName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coverFallback() {
    return Container(
      width: 48,
      height: 48,
      color: HbColors.brandPrimary.withValues(alpha: 0.1),
      child: const Icon(Icons.event, color: HbColors.brandPrimary, size: 22),
    );
  }

  Widget _buildResponseHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.reply, size: 14, color: HbColors.brandPrimary),
          SizedBox(width: 6),
          Text(
            'L\'organisateur a répondu',
            style: TextStyle(
              fontSize: 12,
              color: HbColors.brandPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

}
