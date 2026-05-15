import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/review_enums.dart';

/// Petit badge coloré pour le statut d'un avis (pending/approved/rejected).
class ReviewStatusBadge extends StatelessWidget {
  final ReviewStatus status;
  final bool compact;

  const ReviewStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 11 : 13, color: status.color),
          SizedBox(width: compact ? 3 : 4),
          Text(
            _statusLabel(context),
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    switch (status) {
      case ReviewStatus.pending:
        return context.l10n.reviewsStatusPending;
      case ReviewStatus.approved:
        return context.l10n.reviewsStatusApproved;
      case ReviewStatus.rejected:
        return context.l10n.reviewsStatusRejected;
    }
  }
}
