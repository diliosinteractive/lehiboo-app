import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/guest_restriction_dialog.dart';
import '../../../partners/presentation/providers/organizer_profile_providers.dart';
import '../../data/models/membership_dto.dart';
import '../providers/membership_state_providers.dart';

/// Compact pill-shaped Join button — sits in the organizer profile action
/// bar alongside Contacter / Coordonnées. Handles all four state machine
/// branches from spec MEMBERSHIPS_MOBILE_SPEC.md §15.2.
///
/// Hidden when the authenticated user is the organization owner
/// (`organization.is_owner == true`).
class OrganizerJoinButton extends ConsumerWidget {
  final String organizerUuid;
  final String organizerName;

  const OrganizerJoinButton({
    super.key,
    required this.organizerUuid,
    required this.organizerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(myMembershipForOrgProvider(organizerUuid));
    final action =
        ref.watch(membershipActionControllerProvider(organizerUuid));
    final isInFlight = action.valueOrNull?.isInFlight ?? false;

    final spec = _specFor(membership);

    return InkWell(
      onTap: isInFlight
          ? null
          : () => _handleTap(ref, context, membership, spec),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: spec.filled ? HbColors.brandPrimary : Colors.transparent,
          border: Border.all(color: HbColors.brandPrimary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isInFlight)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: spec.filled ? Colors.white : HbColors.brandPrimary,
                ),
              )
            else
              Icon(
                spec.icon,
                size: 14,
                color: spec.filled ? Colors.white : HbColors.brandPrimary,
              ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                spec.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: spec.filled ? Colors.white : HbColors.brandPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(
    WidgetRef ref,
    BuildContext context,
    MembershipDto? membership,
    _ButtonSpec spec,
  ) {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      ref.read(pendingOrganizerActionProvider.notifier).state =
          PendingOrganizerAction.join;
      GuestRestrictionDialog.show(
        context,
        featureName: "rejoindre cet organisateur",
      );
      return;
    }

    switch (membership?.status) {
      case null:
      case MembershipStatus.rejected:
        confirmAndJoin(context, ref, organizerUuid, organizerName);
      case MembershipStatus.pending:
        confirmAndCancelMembership(context, ref, organizerUuid, organizerName);
      case MembershipStatus.active:
        confirmAndLeaveMembership(context, ref, organizerUuid, organizerName);
    }
  }

  _ButtonSpec _specFor(MembershipDto? m) {
    return switch (m?.status) {
      null => const _ButtonSpec(
          label: 'Rejoindre',
          icon: Icons.group_add_outlined,
          filled: true,
        ),
      MembershipStatus.pending => const _ButtonSpec(
          label: 'En attente',
          icon: Icons.schedule_outlined,
          filled: false,
        ),
      MembershipStatus.active => const _ButtonSpec(
          label: 'Membre',
          icon: Icons.check_circle_outline,
          filled: false,
        ),
      MembershipStatus.rejected => const _ButtonSpec(
          label: 'Refaire la demande',
          icon: Icons.refresh,
          filled: true,
        ),
    };
  }
}

/// Confirm-and-cancel a pending membership request. Reused by the join
/// button and the membership card on the Mes adhésions screen.
Future<void> confirmAndCancelMembership(
  BuildContext context,
  WidgetRef ref,
  String organizerUuid,
  String organizerName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Annuler la demande ?'),
      content: Text(
        "Votre demande de rejoindre $organizerName sera annulée. "
        "Vous pourrez en refaire une à tout moment.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Retour'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: HbColors.brandPrimary),
          child: const Text('Annuler la demande'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await ref
      .read(membershipActionControllerProvider(organizerUuid).notifier)
      .cancelOrLeave();
}

/// Confirm-and-leave an active membership. Reused by the join button and
/// the membership card on the Mes adhésions screen.
Future<void> confirmAndLeaveMembership(
  BuildContext context,
  WidgetRef ref,
  String organizerUuid,
  String organizerName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Quitter l'organisation ?"),
      content: Text(
        "Vous ne verrez plus les événements privés de $organizerName. "
        "Vous pourrez refaire une demande à tout moment.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Retour'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: HbColors.error),
          child: const Text('Quitter'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await ref
      .read(membershipActionControllerProvider(organizerUuid).notifier)
      .cancelOrLeave();
}

/// Top-level helper so the auth-replay listener in `OrganizerActionBar` can
/// trigger the same confirm-and-post flow after the user logs in. Shared
/// between the button itself and the post-login replay path.
Future<void> confirmAndJoin(
  BuildContext context,
  WidgetRef ref,
  String organizerUuid,
  String organizerName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text("Rejoindre l'espace privé de $organizerName ?"),
      content: const Text(
        "En rejoignant, vous accédez aux événements exclusifs proposés "
        "aux membres. Votre demande sera examinée par l'organisateur.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Retour'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: HbColors.brandPrimary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Rejoindre'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  await ref
      .read(membershipActionControllerProvider(organizerUuid).notifier)
      .requestJoin();
}

class _ButtonSpec {
  final String label;
  final IconData icon;
  final bool filled;

  const _ButtonSpec({
    required this.label,
    required this.icon,
    required this.filled,
  });
}
