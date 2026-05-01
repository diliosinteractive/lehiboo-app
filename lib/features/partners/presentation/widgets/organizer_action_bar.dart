import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/guest_restriction_dialog.dart';
import '../../../memberships/presentation/widgets/organizer_join_button.dart'
    show confirmAndJoin;
import '../../data/models/organizer_profile_dto.dart';
import '../providers/organizer_profile_providers.dart';

/// Compact action bar: Contact / Coordinates.
///
/// - **Contact** is hidden when `organizer.allow_public_contact == false`.
/// - **Coordinates** is a UI toggle owned by the parent screen.
///
/// The Follow and Join buttons live next to the organizer name (see
/// [OrganizerFollowButton] / [OrganizerJoinButton]); this widget still
/// owns the auth-replay listener so any pending intent — captured before
/// the user logged in — fires through the appropriate provider regardless
/// of where the visible button sits.
///
/// Auth gating: tapping any button while unauthenticated stores the intent
/// in [pendingOrganizerActionProvider] and opens [GuestRestrictionDialog].
/// After successful login, the screen replays the pending action.
class OrganizerActionBar extends ConsumerStatefulWidget {
  final OrganizerProfileDto organizer;
  final bool coordinatesOpen;
  final ValueChanged<bool> onCoordinatesToggle;

  const OrganizerActionBar({
    super.key,
    required this.organizer,
    required this.coordinatesOpen,
    required this.onCoordinatesToggle,
  });

  @override
  ConsumerState<OrganizerActionBar> createState() => _OrganizerActionBarState();
}

class _OrganizerActionBarState extends ConsumerState<OrganizerActionBar> {
  @override
  void initState() {
    super.initState();
    // Replay a pending gated action when auth flips to authenticated.
    //
    // Listener is registered manually (not in `build`) because the auth
    // status can change while the user is off the screen on the login
    // flow. The widget stays mounted underneath because `/login` is pushed,
    // not pushed-as-replacement, so when the user pops back the listener
    // catches the transition.
    ref.listenManual<AuthState>(authProvider, (previous, next) {
      if (!mounted) return;

      final wasUnauthenticated =
          previous == null || previous.status != AuthStatus.authenticated;
      final isNowAuthenticated = next.status == AuthStatus.authenticated;
      if (!wasUnauthenticated || !isNowAuthenticated) return;

      final pending = ref.read(pendingOrganizerActionProvider);
      if (pending == null) return;
      ref.read(pendingOrganizerActionProvider.notifier).state = null;
      _runAction(pending);
    });
  }

  @override
  void dispose() {
    // Scope pending intent to this screen's lifecycle. If the user tapped
    // Follow then navigated to a different organizer profile without
    // authenticating, the stale intent shouldn't replay against the new
    // organizer (its toggle would target the wrong UUID anyway because
    // `_runAction` reads `widget.organizer.uuid` — but clearing here makes
    // the contract explicit).
    if (mounted) {
      ref.read(pendingOrganizerActionProvider.notifier).state = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showContact = widget.organizer.allowPublicContact;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          if (showContact) ...[
            Expanded(
              child: _PrimaryButton(
                icon: Icons.mail_outline,
                label: 'Contacter',
                onTap: () => _handle(PendingOrganizerAction.contact),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: _SecondaryButton(
              icon: widget.coordinatesOpen
                  ? Icons.expand_less
                  : Icons.expand_more,
              label: 'Coordonnées',
              onTap: () => _handle(PendingOrganizerAction.coordinates),
            ),
          ),
        ],
      ),
    );
  }

  void _handle(PendingOrganizerAction action) {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      ref.read(pendingOrganizerActionProvider.notifier).state = action;
      GuestRestrictionDialog.show(
        context,
        featureName: switch (action) {
          PendingOrganizerAction.follow => "suivre cet organisateur",
          PendingOrganizerAction.contact => "contacter cet organisateur",
          PendingOrganizerAction.coordinates => "voir les coordonnées",
          PendingOrganizerAction.join => "rejoindre cet organisateur",
        },
      );
      return;
    }
    _runAction(action);
  }

  void _runAction(PendingOrganizerAction action) {
    final orgName = widget.organizer.displayName?.isNotEmpty ?? false
        ? widget.organizer.displayName!
        : widget.organizer.name;
    switch (action) {
      case PendingOrganizerAction.follow:
        ref
            .read(followStateControllerProvider(widget.organizer.uuid).notifier)
            .toggle();
      case PendingOrganizerAction.contact:
        context.push(
          '/messages/new/from-organizer/${widget.organizer.uuid}'
          '?name=${Uri.encodeQueryComponent(orgName)}',
        );
      case PendingOrganizerAction.coordinates:
        widget.onCoordinatesToggle(!widget.coordinatesOpen);
      case PendingOrganizerAction.join:
        // Re-show the confirm dialog after login replay so the user still
        // sees the "Rejoindre l'espace privé de X ?" prompt and isn't
        // silently joined the moment they authenticate.
        confirmAndJoin(
          context,
          ref,
          widget.organizer.uuid,
          orgName,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: HbColors.brandPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: HbColors.brandPrimary,
        side: const BorderSide(color: HbColors.brandPrimary),
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
