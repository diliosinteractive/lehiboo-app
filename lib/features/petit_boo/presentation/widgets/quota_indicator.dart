import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/quota_dto.dart';

/// Widget showing remaining message quota
class QuotaIndicator extends StatelessWidget {
  final QuotaDto quota;
  final bool showLabel;

  const QuotaIndicator({
    super.key,
    required this.quota,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress indicator
        SizedBox(
          width: 80,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: 1 - quota.usagePercentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            quota.remainingDisplay,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Color _getColor() {
    if (quota.isExhausted) return HbColors.error;
    if (quota.usagePercentage > 0.8) return HbColors.warning;
    return HbColors.success;
  }
}

/// Compact quota badge
class QuotaBadge extends StatelessWidget {
  final QuotaDto quota;

  const QuotaBadge({
    super.key,
    required this.quota,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${quota.remaining}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (quota.isExhausted) return HbColors.error;
    if (quota.usagePercentage > 0.8) return HbColors.warning;
    return HbColors.brandPrimary;
  }
}

/// Full quota display with reset time
class QuotaDisplay extends StatelessWidget {
  final QuotaDto quota;

  const QuotaDisplay({
    super.key,
    required this.quota,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: HbColors.brandPrimary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Message Quota',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                quota.remainingDisplay,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 1 - quota.usagePercentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
              minHeight: 8,
            ),
          ),
          if (quota.resetsAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Resets: ${_formatResetTime(quota.resetsAt!)}',
              style: TextStyle(
                fontSize: 12,
                color: HbColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColor() {
    if (quota.isExhausted) return HbColors.error;
    if (quota.usagePercentage > 0.8) return HbColors.warning;
    return HbColors.success;
  }

  String _formatResetTime(String isoTime) {
    try {
      final resetTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = resetTime.difference(now);

      if (difference.inHours > 24) {
        return 'in ${difference.inDays} days';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} hours';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} minutes';
      } else {
        return 'soon';
      }
    } catch (e) {
      return isoTime;
    }
  }
}
