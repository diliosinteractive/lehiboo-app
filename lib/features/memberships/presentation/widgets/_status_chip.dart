import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

/// Color-coded status chip — spec §15.1.
///
/// Shared between [MembershipCard] and [InvitationCard] so the visual
/// language stays consistent with the web dashboard.
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  /// Pending — amber.
  factory StatusChip.pending(BuildContext context) => StatusChip(
        label: context.l10n.membershipStatusPending,
        color: const Color(0xFFF59E0B),
      );

  /// Active — green.
  factory StatusChip.active(BuildContext context) => StatusChip(
        label: context.l10n.membershipStatusActive,
        color: const Color(0xFF10B981),
      );

  /// Rejected — grey.
  factory StatusChip.rejected(BuildContext context) => StatusChip(
        label: context.l10n.membershipStatusRejected,
        color: const Color(0xFF6B7280),
      );

  /// Invitation — blue.
  factory StatusChip.invitation(BuildContext context) => StatusChip(
        label: context.l10n.membershipStatusInvitation,
        color: const Color(0xFF3B82F6),
      );

  /// Expired invitation — light grey, only for the deep-link landing screen.
  factory StatusChip.expired(BuildContext context) => StatusChip(
        label: context.l10n.membershipStatusExpired,
        color: const Color(0xFF9CA3AF),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
