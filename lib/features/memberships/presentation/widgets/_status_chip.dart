import 'package:flutter/material.dart';

/// Color-coded status chip — spec §15.1.
///
/// Shared between [MembershipCard] and [InvitationCard] so the visual
/// language stays consistent with the web dashboard.
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  /// Pending — amber.
  factory StatusChip.pending() => const StatusChip(
        label: 'En attente',
        color: Color(0xFFF59E0B),
      );

  /// Active — green.
  factory StatusChip.active() => const StatusChip(
        label: 'Actif',
        color: Color(0xFF10B981),
      );

  /// Rejected — grey.
  factory StatusChip.rejected() => const StatusChip(
        label: 'Refusée',
        color: Color(0xFF6B7280),
      );

  /// Invitation — blue.
  factory StatusChip.invitation() => const StatusChip(
        label: 'Invitation',
        color: Color(0xFF3B82F6),
      );

  /// Expired invitation — light grey, only for the deep-link landing screen.
  factory StatusChip.expired() => const StatusChip(
        label: 'Expirée',
        color: Color(0xFF9CA3AF),
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
