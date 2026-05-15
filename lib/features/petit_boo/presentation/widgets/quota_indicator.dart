import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/themes/petit_boo_theme.dart';
import '../../data/models/quota_dto.dart';

/// Circular quota indicator - compact design for app bar
class CircularQuotaIndicator extends StatelessWidget {
  final QuotaDto quota;
  final double size;

  const CircularQuotaIndicator({
    super.key,
    required this.quota,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final progress = 1 - quota.usagePercentage;

    return GestureDetector(
      onTap: () => QuotaExplanationSheet.show(context, quota),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            CustomPaint(
              size: Size(size, size),
              painter: _CircularProgressPainter(
                progress: progress,
                color: color,
                backgroundColor: PetitBooTheme.grey200,
                strokeWidth: 3,
              ),
            ),
            // Text in center
            Text(
              '${quota.remaining}',
              style: TextStyle(
                fontSize: size * 0.32,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    if (quota.isExhausted) return PetitBooTheme.error;
    if (quota.usagePercentage > 0.8) return PetitBooTheme.warning;
    return PetitBooTheme.primary;
  }
}

/// Bottom sheet pédagogique expliquant le système de quota
class QuotaExplanationSheet extends StatelessWidget {
  final QuotaDto quota;

  const QuotaExplanationSheet({
    super.key,
    required this.quota,
  });

  static void show(BuildContext context, QuotaDto quota) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuotaExplanationSheet(quota: quota),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = _getColor();
    final progress = 1 - quota.usagePercentage;
    final resetTime = quota.effectiveResetsAt;

    return Container(
      decoration: BoxDecoration(
        color: PetitBooTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: PetitBooTheme.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Header avec icône Petit Boo
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: PetitBooTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: PetitBooTheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.petitBooQuotaHeaderTitle,
                          style: PetitBooTheme.headingSm.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.petitBooQuotaHeaderSubtitle,
                          style: PetitBooTheme.bodySm.copyWith(
                            color: PetitBooTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Big circular progress
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: _CircularProgressPainter(
                        progress: progress,
                        color: color,
                        backgroundColor: PetitBooTheme.grey200,
                        strokeWidth: 8,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${quota.remaining}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: color,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.petitBooQuotaRemainingLabel,
                          style: PetitBooTheme.caption.copyWith(
                            color: PetitBooTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Usage text
              Text(
                l10n.petitBooQuotaUsage(quota.used, quota.limit),
                style: PetitBooTheme.bodySm.copyWith(
                  color: PetitBooTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              // Explanation cards
              _buildExplanationCard(
                icon: Icons.refresh_rounded,
                iconColor: PetitBooTheme.success,
                title: l10n.petitBooQuotaRenewalTitle(
                  _getPeriodText(context),
                ),
                description: resetTime != null
                    ? l10n.petitBooQuotaRenewsAt(
                        _formatResetTime(context, resetTime),
                      )
                    : l10n.petitBooQuotaRenewsAutomatically,
              ),

              const SizedBox(height: 12),

              _buildExplanationCard(
                icon: Icons.lightbulb_outline_rounded,
                iconColor: PetitBooTheme.warning,
                title: l10n.petitBooQuotaTipTitle,
                description: l10n.petitBooQuotaTipDescription,
              ),

              const SizedBox(height: 12),

              _buildExplanationCard(
                icon: Icons.auto_awesome_rounded,
                iconColor: PetitBooTheme.primary,
                title: l10n.petitBooQuotaWhyTitle,
                description: l10n.petitBooQuotaWhyDescription,
              ),

              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: PetitBooTheme.grey100,
                    foregroundColor: PetitBooTheme.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.petitBooQuotaUnderstood,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PetitBooTheme.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PetitBooTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PetitBooTheme.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: PetitBooTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: PetitBooTheme.caption.copyWith(
                    color: PetitBooTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (quota.isExhausted) return PetitBooTheme.error;
    if (quota.usagePercentage > 0.8) return PetitBooTheme.warning;
    return PetitBooTheme.primary;
  }

  String _getPeriodText(BuildContext context) {
    final l10n = context.l10n;

    switch (quota.period) {
      case 'daily':
        return l10n.petitBooQuotaPeriodDaily;
      case 'weekly':
        return l10n.petitBooQuotaPeriodWeekly;
      case 'monthly':
        return l10n.petitBooQuotaPeriodMonthly;
      default:
        return l10n.petitBooQuotaPeriodAutomatic;
    }
  }

  String _formatResetTime(BuildContext context, String isoTime) {
    final l10n = context.l10n;

    try {
      final resetTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = resetTime.difference(now);

      if (difference.isNegative) {
        return l10n.petitBooQuotaResetVerySoon;
      }

      if (difference.inDays > 1) {
        return l10n.petitBooQuotaResetInDays(difference.inDays);
      } else if (difference.inDays == 1) {
        return l10n.petitBooQuotaResetTomorrow;
      } else if (difference.inHours > 1) {
        return l10n.petitBooQuotaResetInHours(difference.inHours);
      } else if (difference.inHours == 1) {
        return l10n.petitBooQuotaResetInOneHour;
      } else if (difference.inMinutes >= 1) {
        return l10n.petitBooQuotaResetInMinutes(difference.inMinutes);
      } else {
        return l10n.petitBooQuotaResetSoon;
      }
    } catch (e) {
      return l10n.petitBooQuotaResetAutomatically;
    }
  }
}

/// Custom painter for circular progress
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Widget showing remaining message quota (linear version)
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
              Text(
                context.l10n.petitBooQuotaDisplayTitle,
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
          if (quota.effectiveResetsAt != null) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.petitBooQuotaDisplayResets(
                _formatResetTime(context, quota.effectiveResetsAt!),
              ),
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

  String _formatResetTime(BuildContext context, String isoTime) {
    final l10n = context.l10n;

    try {
      final resetTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = resetTime.difference(now);

      if (difference.inHours > 24) {
        return l10n.petitBooQuotaResetInDays(difference.inDays);
      } else if (difference.inHours > 0) {
        return difference.inHours == 1
            ? l10n.petitBooQuotaResetInOneHour
            : l10n.petitBooQuotaResetInHours(difference.inHours);
      } else if (difference.inMinutes >= 1) {
        return l10n.petitBooQuotaResetInMinutes(difference.inMinutes);
      } else {
        return l10n.petitBooQuotaResetSoon;
      }
    } catch (e) {
      return isoTime;
    }
  }
}
