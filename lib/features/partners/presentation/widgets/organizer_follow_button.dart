import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../auth/presentation/widgets/guest_restriction_dialog.dart';
import '../providers/organizer_profile_providers.dart';

/// Compact pill-shaped follow button rendered inline next to the organizer
/// name and verified badge.
///
/// Auth gating is awaited here so the resumed action remains bound to this
/// exact organizer instead of passing through a global replay slot.
class OrganizerFollowButton extends ConsumerWidget {
  final String organizerUuid;
  final AuthSessionKey ownerSession;

  const OrganizerFollowButton({
    super.key,
    required this.organizerUuid,
    required this.ownerSession,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final follow = ref.watch(followStateControllerProvider(organizerUuid));
    final state = follow.valueOrNull;
    final isFollowing = state?.isFollowed ?? false;
    final isLoading = state?.isInFlight ?? false;

    final label = isFollowing
        ? context.l10n.organizerUnfollowAction
        : context.l10n.organizerFollowAction;
    final icon = isFollowing ? Icons.person_remove_outlined : Icons.add;

    final filled = !isFollowing;
    final bg = filled ? HbColors.brandPrimary : Colors.transparent;
    final fg = filled ? Colors.white : HbColors.brandPrimary;
    final border = Border.all(color: HbColors.brandPrimary);

    return InkWell(
      onTap: isLoading ? null : () => _onTap(ref, context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          border: border,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5, color: fg),
              )
            else
              Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTap(WidgetRef ref, BuildContext context) async {
    if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
    final initiatingOrganizerUuid = organizerUuid;
    var actionOwner = ownerSession;
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
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
        allowed = await GuestRestrictionDialog.show(
          context,
          featureName: context.l10n.guestFeatureFollowOrganizer,
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
        !identical(ref.read(authSessionKeyProvider), actionOwner) ||
        organizerUuid != initiatingOrganizerUuid) {
      return;
    }
    final provider = followStateControllerProvider(initiatingOrganizerUuid);
    final ownerNotifier = ref.read(provider.notifier);
    final wasFollowing = ref.read(provider).valueOrNull?.isFollowed ?? false;
    try {
      await ownerNotifier.toggle();
      if (!context.mounted ||
          !identical(ref.read(authSessionKeyProvider), actionOwner) ||
          !identical(ref.read(provider.notifier), ownerNotifier)) {
        return;
      }
    } catch (error) {
      if (!context.mounted ||
          !identical(ref.read(authSessionKeyProvider), actionOwner) ||
          !identical(ref.read(provider.notifier), ownerNotifier)) {
        return;
      }
      final fallback = wasFollowing
          ? context.l10n.organizerUnfollowError
          : context.l10n.organizerFollowError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiResponseHandler.extractError(error, fallback: fallback),
          ),
        ),
      );
    }
  }
}
