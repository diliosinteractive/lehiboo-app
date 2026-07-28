import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/review.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/user_reviews_provider.dart';
import 'delete_review_dialog.dart';
import 'rating_stars.dart';
import 'status_badge.dart';
import 'write_review_sheet.dart';

/// Bloc "Votre avis" affiché sur la fiche événement / la full reviews screen
/// quand l'utilisateur a déjà laissé un avis.
///
/// Permet à l'utilisateur de voir son propre avis (statut pending/rejected
/// non visible publiquement, ou approved) avec actions Modifier / Supprimer.
class MyReviewBlock extends ConsumerWidget {
  final Review review;
  final String eventSlug;
  final String eventTitle;
  final VoidCallback? onChanged;

  const MyReviewBlock({
    super.key,
    required this.review,
    required this.eventSlug,
    required this.eventTitle,
    this.onChanged,
  });

  Future<void> _handleEdit(BuildContext context) async {
    HapticFeedback.lightImpact();
    final updated = await WriteReviewSheet.showEdit(
      context,
      review: review,
      eventSlug: eventSlug,
      eventTitle: eventTitle,
    );
    if (updated != null) onChanged?.call();
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final confirmed = await DeleteReviewDialog.show(context);
    if (!confirmed || !context.mounted) return;

    final result = await ref.read(reviewsActionsProvider.notifier).deleteReview(
          reviewUuid: review.uuid,
          eventSlug: eventSlug,
        );

    if (!context.mounted) return;

    switch (result) {
      case ReviewActionSuccess():
        // Si la liste "Mes Avis" est ouverte ailleurs, la nettoyer aussi.
        try {
          ref.read(userReviewsProvider.notifier).removeLocal(review.uuid);
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.reviewsDeleteSuccess),
            backgroundColor: Colors.green,
          ),
        );
        onChanged?.call();
      case ReviewActionFailure(message: final msg):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.l10n.reviewsYourReviewLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 8),
              ReviewStatusBadge(status: review.status, compact: true),
              const Spacer(),
              RatingStars(rating: review.rating.toDouble(), size: 14),
              const SizedBox(width: 4),
              _buildIconAction(
                icon: Icons.edit_outlined,
                tooltip: context.l10n.reviewsEditAction,
                color: HbColors.brandPrimary,
                onPressed: () => _handleEdit(context),
              ),
              _buildIconAction(
                icon: Icons.delete_outline,
                tooltip: context.l10n.reviewsDeleteAction,
                color: Colors.red.shade400,
                onPressed: () => _handleDelete(context, ref),
              ),
            ],
          ),
          if (review.title.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
          ],
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          if (review.createdAtFormatted.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.createdAtFormatted,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
          if (review.response != null) ...[
            const SizedBox(height: 10),
            _buildResponseBlock(context),
          ],
        ],
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

  Widget _buildResponseBlock(BuildContext context) {
    final r = review.response!;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: HbColors.brandPrimary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reply, size: 13, color: HbColors.brandPrimary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  context.l10n.organizerReplyBy(r.organizationName),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HbColors.brandPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            r.response,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
