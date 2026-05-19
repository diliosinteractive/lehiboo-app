import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

/// Top-of-section block matching the desktop "Participants" header:
/// - Title row with an "X enregistré(s)" badge
/// - Progress bar "X / N participants prêts" + percentage
/// - Two action buttons (fill from profile, pick saved participant)
/// - Amber warning when the connected user's profile is incomplete
class ParticipantsOverviewBlock extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final List<SavedParticipant> savedParticipants;
  final HbUser? user;
  final bool userIsComplete;
  final VoidCallback? onFillFromProfile;
  final VoidCallback? onPickSavedParticipant;
  final VoidCallback? onCompleteProfile;

  const ParticipantsOverviewBlock({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.savedParticipants,
    required this.user,
    required this.userIsComplete,
    this.onFillFromProfile,
    this.onPickSavedParticipant,
    this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    final percent = (progress * 100).round();
    final hasUser = user != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.auto_awesome,
                  color: HbColors.brandPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.bookingMyParticipants,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
              ),
              if (savedParticipants.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    context.l10n.bookingSavedParticipantsCount(
                        savedParticipants.length),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: HbColors.brandPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.bookingPrefillTicketsOneClick,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n
                      .bookingParticipantsReady(completedCount, totalCount),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 6,
              backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                HbColors.brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (hasUser)
            OutlinedButton.icon(
              onPressed: onFillFromProfile,
              icon: const Icon(Icons.person_outline, size: 16),
              label: Text(
                context.l10n.bookingFillAllWithProfile,
                style: const TextStyle(fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: HbColors.brandPrimary,
                side: BorderSide(
                  color: HbColors.brandPrimary.withValues(alpha: 0.4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          if (hasUser && savedParticipants.isNotEmpty)
            const SizedBox(height: 8),
          if (savedParticipants.isNotEmpty)
            OutlinedButton.icon(
              onPressed: onPickSavedParticipant,
              icon: const Icon(Icons.group_outlined, size: 16),
              label: Text(
                context.l10n.bookingChooseSavedParticipant,
                style: const TextStyle(fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: HbColors.textPrimary,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          if (hasUser && !userIsComplete) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED), // amber-50
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: Color(0xFFB45309),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.bookingIncompleteProfileTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l10n.bookingIncompleteProfileBody,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        if (onCompleteProfile != null) ...[
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: onCompleteProfile,
                            child: Text(
                              context.l10n.bookingCompleteProfile,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB45309),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
