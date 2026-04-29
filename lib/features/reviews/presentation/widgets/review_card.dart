import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entities/review.dart';
import 'rating_stars.dart';

/// Carte d'affichage d'un avis (utilisée sur la fiche événement et la full
/// reviews screen). Pour l'écran "Mes Avis", utiliser [UserReviewCard].
class ReviewCard extends StatelessWidget {
  final Review review;
  final void Function(String reviewUuid, bool isHelpful)? onVote;
  final VoidCallback? onReport;
  final bool showFull;

  const ReviewCard({
    super.key,
    required this.review,
    this.onVote,
    this.onReport,
    this.showFull = false,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(context),
          const SizedBox(height: 12),
          if (review.title.isNotEmpty) ...[
            Text(
              review.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
          ],
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
          if (review.response != null) ...[
            const SizedBox(height: 12),
            _buildResponseBlock(),
          ],
          if (onVote != null || onReport != null) ...[
            const SizedBox(height: 12),
            _buildActionsRow(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final author = review.author;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.1),
          backgroundImage: author?.avatar != null
              ? NetworkImage(author!.avatar!)
              : null,
          child: author?.avatar == null
              ? Text(
                  author?.displayInitials ?? '?',
                  style: const TextStyle(
                    color: HbColors.brandPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      author?.name.isNotEmpty == true
                          ? author!.name
                          : 'Anonyme',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: HbColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (review.isVerifiedPurchase) ...[
                    const SizedBox(width: 6),
                    _buildVerifiedBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                review.createdAtFormatted,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        RatingStars(rating: review.rating.toDouble(), size: 14),
      ],
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 10, color: Colors.green),
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
    );
  }

  Widget _buildResponseBlock() {
    final r = review.response!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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
              const Icon(Icons.reply, size: 14, color: HbColors.brandPrimary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Réponse de ${r.organizationName}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HbColors.brandPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (r.createdAtFormatted.isNotEmpty)
                Text(
                  r.createdAtFormatted,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            r.response,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow() {
    // Quand l'utilisateur a déjà voté, on désactive les deux boutons :
    // l'actif garde sa couleur (indique son choix), l'inactif passe en grisé.
    // Le serveur refuse de re-voter (422 "already voted") sans unvote préalable
    // — le visuel doit refléter ce verrou.
    final hasVoted = review.userVote != null;

    return Row(
      children: [
        if (onVote != null) ...[
          _VoteButton(
            icon: Icons.thumb_up_outlined,
            activeIcon: Icons.thumb_up,
            count: review.helpfulCount,
            isActive: review.userVote == true,
            enabled: !hasVoted,
            onTap: () => onVote!(review.uuid, true),
          ),
          const SizedBox(width: 16),
          _VoteButton(
            icon: Icons.thumb_down_outlined,
            activeIcon: Icons.thumb_down,
            count: review.notHelpfulCount,
            isActive: review.userVote == false,
            enabled: !hasVoted,
            onTap: () => onVote!(review.uuid, false),
          ),
        ],
        const Spacer(),
        if (onReport != null)
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 18,
            tooltip: 'Signaler',
            color: Colors.grey.shade500,
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              onReport!();
            },
          ),
      ],
    );
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final int count;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  const _VoteButton({
    required this.icon,
    required this.activeIcon,
    required this.count,
    required this.isActive,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Couleurs : actif → orange brand ; inactif & enabled → gris neutre ;
    // inactif & disabled → gris très clair (effet "grisé / verrouillé").
    final Color fgColor;
    final Color bgColor;
    if (isActive) {
      fgColor = HbColors.brandPrimary;
      bgColor = HbColors.brandPrimary.withValues(alpha: enabled ? 0.1 : 0.08);
    } else if (enabled) {
      fgColor = Colors.grey.shade600;
      bgColor = Colors.grey.shade100;
    } else {
      fgColor = Colors.grey.shade400;
      bgColor = Colors.grey.shade50;
    }

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon, size: 16, color: fgColor),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: fgColor,
              ),
            ),
          ],
        ],
      ),
    );

    if (!enabled) {
      // MouseRegion forbidden cursor + pas de GestureDetector → button non
      // interactif. On garde l'opacité 1 pour que le choix reste lisible.
      return MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: content,
      );
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: content,
    );
  }
}
