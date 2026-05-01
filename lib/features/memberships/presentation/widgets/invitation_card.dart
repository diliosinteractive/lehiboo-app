import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/colors.dart';
import '../../../partners/presentation/widgets/organizer_avatar.dart';
import '../../data/models/invitation_dto.dart';
import '../../data/models/membership_dto.dart';
import '../providers/memberships_screen_providers.dart';
import '_status_chip.dart';

/// One invitation row on the Mes adhésions screen — spec §13.2, §15.2.
class InvitationCard extends ConsumerWidget {
  final InvitationDto invitation;
  final VoidCallback? onAccepted;

  const InvitationCard({
    super.key,
    required this.invitation,
    this.onAccepted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = invitation.organization;
    final orgName = org?.name ?? '—';
    final orgUuid = org?.uuid;

    final token = invitation.token ?? '';
    final action = ref.watch(invitationActionControllerProvider(token));
    final isInFlight = action.valueOrNull?.isInFlight ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrganizerAvatar(
                logoUrl: org?.logoOrUrl,
                fallbackName: orgName,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            orgName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: HbColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusChip.invitation(),
                      ],
                    ),
                    if (org?.city != null && org!.city!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          org.city!,
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    if (invitation.invitedBy?.name.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Invité par ${invitation.invitedBy!.name}',
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    Text(
                      _expiresLabel(invitation.expiresAt),
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OutlinedAction(
                  label: 'Décliner',
                  color: Colors.grey[600]!,
                  isInFlight: isInFlight,
                  onTap: token.isEmpty
                      ? null
                      : () => _onDecline(context, ref, token, orgName),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilledAction(
                  label: 'Accepter',
                  color: HbColors.brandPrimary,
                  isInFlight: isInFlight,
                  onTap: token.isEmpty
                      ? null
                      : () => _onAccept(context, ref, token, orgName, orgUuid),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _expiresLabel(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final exp = DateTime.tryParse(iso);
    if (exp == null) return '';
    final now = DateTime.now();
    if (exp.isBefore(now)) return 'Expirée';
    final diff = exp.difference(now);
    if (diff.inHours >= 24) {
      final days = diff.inDays;
      return 'Expire dans $days ${days > 1 ? "jours" : "jour"}';
    }
    final hours = diff.inHours.clamp(1, 100);
    return 'Expire dans $hours h';
  }

  Future<void> _onAccept(
    BuildContext context,
    WidgetRef ref,
    String token,
    String orgName,
    String? orgUuid,
  ) async {
    final ok = await ref
        .read(invitationActionControllerProvider(token).notifier)
        .accept();
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenue dans $orgName')),
      );
      onAccepted?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'accepter cette invitation."),
        ),
      );
    }
  }

  Future<void> _onDecline(
    BuildContext context,
    WidgetRef ref,
    String token,
    String orgName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Décliner l'invitation ?"),
        content: Text("Refuser l'invitation de $orgName ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Retour'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: HbColors.error),
            child: const Text('Décliner'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(invitationActionControllerProvider(token).notifier)
        .decline();
  }
}

class _FilledAction extends StatelessWidget {
  final String label;
  final Color color;
  final bool isInFlight;
  final VoidCallback? onTap;

  const _FilledAction({
    required this.label,
    required this.color,
    required this.isInFlight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isInFlight ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: isInFlight
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  final String label;
  final Color color;
  final bool isInFlight;
  final VoidCallback? onTap;

  const _OutlinedAction({
    required this.label,
    required this.color,
    required this.isInFlight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isInFlight ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
