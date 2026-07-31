import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../auth/presentation/widgets/account_bound_route_guard.dart';
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
  final AuthSessionKey ownerSession;

  const OrganizerJoinButton({
    super.key,
    required this.organizerUuid,
    required this.organizerName,
    required this.ownerSession,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(myMembershipForOrgProvider(organizerUuid));
    final action = ref.watch(membershipActionControllerProvider(organizerUuid));
    final isInFlight =
        action.isLoading || (action.valueOrNull?.isInFlight ?? false);

    final spec = _specFor(context, membership);

    return InkWell(
      onTap: isInFlight
          ? null
          : () => _handleTap(
                ref,
                context,
                membership,
                ownerSession,
              ),
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
    AuthSessionKey ownerSession,
  ) {
    if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
    switch (membership?.status) {
      case null:
      case MembershipStatus.rejected:
        confirmAndJoin(
          context,
          ref,
          organizerUuid,
          organizerName,
          ownerSession: ownerSession,
        );
      case MembershipStatus.pending:
        if (ownerSession.accountId == null) return;
        confirmAndCancelMembership(
          context,
          ref,
          organizerUuid,
          organizerName,
          ownerSession: ownerSession,
        );
      case MembershipStatus.active:
        if (ownerSession.accountId == null) return;
        confirmAndLeaveMembership(
          context,
          ref,
          organizerUuid,
          organizerName,
          ownerSession: ownerSession,
        );
    }
  }

  _ButtonSpec _specFor(BuildContext context, MembershipDto? m) {
    final l10n = context.l10n;
    return switch (m?.status) {
      null => _ButtonSpec(
          label: l10n.membershipJoinAction,
          icon: Icons.group_add_outlined,
          filled: true,
        ),
      MembershipStatus.pending => _ButtonSpec(
          label: l10n.membershipPendingAction,
          icon: Icons.schedule_outlined,
          filled: false,
        ),
      MembershipStatus.active => _ButtonSpec(
          label: l10n.membershipMember,
          icon: Icons.check_circle_outline,
          filled: false,
        ),
      MembershipStatus.rejected => _ButtonSpec(
          label: l10n.membershipRetryRequestAction,
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
  String organizerName, {
  required AuthSessionKey ownerSession,
}) async {
  final ownerAccountId = ownerSession.accountId;
  if (ownerAccountId == null ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return;
  }
  final provider = membershipActionControllerProvider(organizerUuid);
  final actionController = ref.read(provider.notifier);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AccountBoundRouteGuard<bool>(
      ownerAccountId: ownerAccountId,
      ownerSession: ownerSession,
      invalidResult: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.membershipCancelRequestTitle),
        content: Text(
          dialogContext.l10n.membershipCancelRequestBody(organizerName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonBack),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: HbColors.brandPrimary,
            ),
            child: Text(dialogContext.l10n.membershipCancelRequestAction),
          ),
        ],
      ),
    ),
  );
  if (confirmed != true ||
      !context.mounted ||
      !identical(ref.read(authSessionKeyProvider), ownerSession) ||
      !identical(ref.read(provider.notifier), actionController)) {
    return;
  }
  final fallback = context.l10n.membershipCancelRequestFailed;
  final succeeded = await actionController.cancelOrLeave(
    fallbackMessage: fallback,
  );
  if (succeeded ||
      !context.mounted ||
      !identical(ref.read(authSessionKeyProvider), ownerSession) ||
      !identical(ref.read(provider.notifier), actionController)) {
    return;
  }
  _showMembershipActionError(
    context,
    ref.read(provider).valueOrNull?.error ?? fallback,
  );
}

/// Confirm-and-leave an active membership. Reused by the join button and
/// the membership card on the Mes adhésions screen.
Future<void> confirmAndLeaveMembership(
  BuildContext context,
  WidgetRef ref,
  String organizerUuid,
  String organizerName, {
  required AuthSessionKey ownerSession,
}) async {
  final ownerAccountId = ownerSession.accountId;
  if (ownerAccountId == null ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return;
  }
  final provider = membershipActionControllerProvider(organizerUuid);
  final actionController = ref.read(provider.notifier);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AccountBoundRouteGuard<bool>(
      ownerAccountId: ownerAccountId,
      ownerSession: ownerSession,
      invalidResult: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.membershipLeaveTitle),
        content: Text(
          dialogContext.l10n.membershipLeaveBody(organizerName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonBack),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: HbColors.error),
            child: Text(dialogContext.l10n.membershipLeaveAction),
          ),
        ],
      ),
    ),
  );
  if (confirmed != true ||
      !context.mounted ||
      !identical(ref.read(authSessionKeyProvider), ownerSession) ||
      !identical(ref.read(provider.notifier), actionController)) {
    return;
  }
  final fallback = context.l10n.membershipLeaveFailed;
  final succeeded = await actionController.cancelOrLeave(
    fallbackMessage: fallback,
  );
  if (succeeded ||
      !context.mounted ||
      !identical(ref.read(authSessionKeyProvider), ownerSession) ||
      !identical(ref.read(provider.notifier), actionController)) {
    return;
  }
  _showMembershipActionError(
    context,
    ref.read(provider).valueOrNull?.error ?? fallback,
  );
}

/// Top-level helper so the auth-replay listener in `OrganizerActionBar` can
/// trigger the same confirm-and-post flow after the user logs in. Shared
/// between the button itself and the post-login replay path.
Future<void> confirmAndJoin(
  BuildContext context,
  WidgetRef ref,
  String organizerUuid,
  String organizerName, {
  required AuthSessionKey ownerSession,
}) async {
  if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
  var actionOwner = ownerSession;
  if (ownerSession.accountId == null) {
    var sessionTransitions = 0;
    var lastSession = ownerSession;
    final subscription = ref.listenManual<AuthSessionKey>(
      authSessionKeyProvider,
      (_, next) {
        if (identical(next, lastSession)) return;
        lastSession = next;
        sessionTransitions++;
      },
    );
    bool allowed;
    try {
      allowed = await GuestGuard.check(
        context: context,
        ref: ref,
        featureName: context.l10n.guestFeatureJoinOrganizer,
      );
    } finally {
      subscription.close();
    }
    if (!allowed || !context.mounted || sessionTransitions != 1) {
      return;
    }
    final authenticatedOwner = ref.read(authSessionKeyProvider);
    if (authenticatedOwner.accountId == null) return;
    actionOwner = authenticatedOwner;
  }

  final ownerAccountId = actionOwner.accountId;
  if (ownerAccountId == null ||
      !identical(ref.read(authSessionKeyProvider), actionOwner)) {
    return;
  }
  final provider = membershipActionControllerProvider(organizerUuid);
  final actionController = ref.read(provider.notifier);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AccountBoundRouteGuard<bool>(
      ownerAccountId: ownerAccountId,
      ownerSession: actionOwner,
      invalidResult: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          dialogContext.l10n.membershipJoinTitle(organizerName),
        ),
        content: Text(dialogContext.l10n.membershipJoinBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonBack),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: Colors.white,
            ),
            child: Text(dialogContext.l10n.membershipJoinAction),
          ),
        ],
      ),
    ),
  );
  if (confirmed != true ||
      !context.mounted ||
      !identical(ref.read(authSessionKeyProvider), actionOwner) ||
      !identical(ref.read(provider.notifier), actionController)) {
    return;
  }

  final fallback = context.l10n.membershipJoinFailed;
  final succeeded = await actionController.requestJoin(
    fallbackMessage: fallback,
  );
  if (succeeded ||
      !context.mounted ||
      !identical(ref.read(authSessionKeyProvider), actionOwner) ||
      !identical(ref.read(provider.notifier), actionController)) {
    return;
  }
  _showMembershipActionError(
    context,
    ref.read(provider).valueOrNull?.error ?? fallback,
  );
}

void _showMembershipActionError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: HbColors.error,
    ),
  );
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
