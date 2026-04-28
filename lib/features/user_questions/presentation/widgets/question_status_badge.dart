import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../events/domain/entities/event_question.dart';

extension QuestionStatusUi on QuestionStatus {
  String get label {
    switch (this) {
      case QuestionStatus.pending:
        return 'En attente';
      case QuestionStatus.approved:
        return 'Approuvée';
      case QuestionStatus.answered:
        return 'Répondue';
      case QuestionStatus.rejected:
        return 'Rejetée';
    }
  }

  Color get color {
    switch (this) {
      case QuestionStatus.pending:
        return HbColors.warning;
      case QuestionStatus.approved:
        return HbColors.brandSecondary;
      case QuestionStatus.answered:
        return HbColors.success;
      case QuestionStatus.rejected:
        return HbColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionStatus.pending:
        return Icons.schedule;
      case QuestionStatus.approved:
        return Icons.check;
      case QuestionStatus.answered:
        return Icons.verified;
      case QuestionStatus.rejected:
        return Icons.block;
    }
  }
}

class QuestionStatusBadge extends StatelessWidget {
  final QuestionStatus status;
  final bool compact;

  const QuestionStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: compact ? 12 : 14,
            color: status.color,
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            status.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
