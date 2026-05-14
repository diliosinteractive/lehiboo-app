import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../partners/presentation/widgets/organizer_avatar.dart';
import '../../data/models/membership_dto.dart';
import '../providers/membership_state_providers.dart';
import '_status_chip.dart';
import 'organizer_join_button.dart';

/// One membership row on the Mes adhésions screen — spec §13.1, §15.2.
///
/// Action buttons are computed from the row's status:
/// - `pending`  → Annuler la demande + Voir la fiche
/// - `active`   → Quitter + Voir la fiche
///                (Voir les événements privés ships in chunk 4)
/// - `rejected` → Refaire une demande + Voir la fiche
class MembershipCard extends ConsumerWidget {
  final MembershipDto membership;

  const MembershipCard({super.key, required this.membership});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = membership.organization;
    final orgName = org?.name ?? '—';
    final orgUuid = org?.uuid ?? '';

    final action = ref.watch(membershipActionControllerProvider(orgUuid));
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        _chipFor(membership.status),
                      ],
                    ),
                    const SizedBox(height: 2),
                    _OrgMetaRow(organization: org),
                    const SizedBox(height: 4),
                    Text(
                      _subText(context, membership),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _OutlinedAction(
                label: 'Voir la fiche',
                icon: Icons.open_in_new,
                onTap: orgUuid.isEmpty
                    ? null
                    : () => context.push('/organizers/$orgUuid'),
              ),
              if (membership.status == MembershipStatus.active)
                _OutlinedAction(
                  label: 'Événements privés',
                  icon: Icons.lock_outline,
                  onTap: orgUuid.isEmpty
                      ? null
                      : () => context.push('/me/private-events?org=$orgUuid'),
                ),
              SizedBox(
                width: 180,
                child: _PrimaryAction(
                  membership: membership,
                  isInFlight: isInFlight,
                  onAction: () => _onPrimary(context, ref, orgUuid, orgName),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  StatusChip _chipFor(MembershipStatus s) => switch (s) {
        MembershipStatus.pending => StatusChip.pending(),
        MembershipStatus.active => StatusChip.active(),
        MembershipStatus.rejected => StatusChip.rejected(),
      };

  String _subText(BuildContext context, MembershipDto m) {
    final fmt = context.appDateFormat('dd/MM/yyyy', enPattern: 'MM/dd/yyyy');
    final approved = _parse(m.approvedAt);
    final requested = _parse(m.requestedAt);
    return switch (m.status) {
      MembershipStatus.active => approved != null
          ? context.l10n.membershipMemberSince(fmt.format(approved))
          : context.l10n.membershipMember,
      MembershipStatus.pending => requested != null
          ? context.l10n.membershipRequestSentOn(fmt.format(requested))
          : context.l10n.membershipRequestSent,
      MembershipStatus.rejected => requested != null
          ? context.l10n.membershipRequestRejectedOn(fmt.format(requested))
          : context.l10n.membershipRequestRejected,
    };
  }

  DateTime? _parse(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    return DateTime.tryParse(iso);
  }

  void _onPrimary(
    BuildContext context,
    WidgetRef ref,
    String orgUuid,
    String orgName,
  ) {
    if (orgUuid.isEmpty) return;
    switch (membership.status) {
      case MembershipStatus.pending:
        confirmAndCancelMembership(context, ref, orgUuid, orgName);
      case MembershipStatus.active:
        confirmAndLeaveMembership(context, ref, orgUuid, orgName);
      case MembershipStatus.rejected:
        confirmAndJoin(context, ref, orgUuid, orgName);
    }
  }
}

/// Address + members-count row under the org name. Members count is hidden
/// when the backend hasn't shipped the field yet (null) — graceful degrade.
class _OrgMetaRow extends StatelessWidget {
  final OrganizationSummaryDto? organization;
  const _OrgMetaRow({required this.organization});

  @override
  Widget build(BuildContext context) {
    final org = organization;
    if (org == null) return const SizedBox.shrink();

    final hasAddress = org.address != null && org.address!.isNotEmpty;
    final count = org.membersCountOrNull;
    final hasCount = count != null;
    if (!hasAddress && !hasCount) return const SizedBox.shrink();

    final compact = context.appCompactNumberFormat;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (hasAddress)
            _MetaChip(
              icon: Icons.place_outlined,
              label: org.address!,
            ),
          if (hasCount)
            _MetaChip(
              icon: Icons.groups_outlined,
              label: '${compact.format(count)} '
                  '${count > 1 ? "membres" : "membre"}',
            ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.figtree(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final MembershipDto membership;
  final bool isInFlight;
  final VoidCallback onAction;

  const _PrimaryAction({
    required this.membership,
    required this.isInFlight,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final spec = switch (membership.status) {
      MembershipStatus.pending => (
          'Annuler la demande',
          HbColors.brandPrimary,
          false,
        ),
      MembershipStatus.active => ('Quitter', HbColors.error, false),
      MembershipStatus.rejected => (
          'Refaire la demande',
          HbColors.brandPrimary,
          true,
        ),
    };
    final label = spec.$1;
    final color = spec.$2;
    final filled = spec.$3;

    final child = isInFlight
        ? SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: filled ? Colors.white : color,
            ),
          )
        : Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.figtree(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: filled ? Colors.white : color,
            ),
          );

    return InkWell(
      onTap: isInFlight ? null : onAction,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _OutlinedAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final fg = disabled ? Colors.grey[400]! : HbColors.brandPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: fg),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
