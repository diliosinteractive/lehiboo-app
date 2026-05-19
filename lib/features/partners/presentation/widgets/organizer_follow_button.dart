import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/guest_restriction_dialog.dart';
import '../providers/organizer_profile_providers.dart';

/// Compact pill-shaped follow button rendered inline next to the organizer
/// name and verified badge.
///
/// Auth gating: tapping while unauthenticated stores
/// [PendingOrganizerAction.follow] in [pendingOrganizerActionProvider] and
/// opens [GuestRestrictionDialog]. The auth-replay listener in
/// [OrganizerActionBar] picks it back up after login and triggers the
/// toggle through [followStateControllerProvider] — independently of where
/// the visible button lives.
class OrganizerFollowButton extends ConsumerWidget {
  final String organizerUuid;

  const OrganizerFollowButton({super.key, required this.organizerUuid});

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

  void _onTap(WidgetRef ref, BuildContext context) {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      ref.read(pendingOrganizerActionProvider.notifier).state =
          PendingOrganizerAction.follow;
      GuestRestrictionDialog.show(
        context,
        featureName: context.l10n.guestFeatureFollowOrganizer,
      );
      return;
    }
    ref.read(followStateControllerProvider(organizerUuid).notifier).toggle();
  }
}
