import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
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
/// [OrganizerFollowButton] / [OrganizerJoinButton]).
///
/// Auth gating is awaited by the widget that initiated it. This keeps the
/// intent bound to this organizer even when multiple profiles remain mounted
/// in the navigator during login.
class OrganizerActionBar extends ConsumerStatefulWidget {
  final OrganizerProfileDto organizer;
  final AuthSessionKey ownerSession;
  final bool coordinatesOpen;
  final ValueChanged<bool> onCoordinatesToggle;

  const OrganizerActionBar({
    super.key,
    required this.organizer,
    required this.ownerSession,
    required this.coordinatesOpen,
    required this.onCoordinatesToggle,
  });

  @override
  ConsumerState<OrganizerActionBar> createState() => _OrganizerActionBarState();
}

class _OrganizerActionBarState extends ConsumerState<OrganizerActionBar> {
  late AuthSessionKey _lastSession;
  int _authIdentityGeneration = 0;
  late final ProviderSubscription<AuthSessionKey> _authSubscription;

  @override
  void initState() {
    super.initState();
    _lastSession = ref.read(authSessionKeyProvider);
    _authSubscription = ref.listenManual<AuthSessionKey>(
      authSessionKeyProvider,
      (_, next) {
        if (identical(next, _lastSession)) return;
        _lastSession = next;
        _authIdentityGeneration++;
      },
    );
  }

  @override
  void dispose() {
    _authSubscription.close();
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
                label: context.l10n.organizerContactAction,
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
              label: context.l10n.organizerCoordinatesAction,
              onTap: () => _handle(PendingOrganizerAction.coordinates),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handle(PendingOrganizerAction action) async {
    final renderedOwner = widget.ownerSession;
    if (!identical(
      ref.read(authSessionKeyProvider),
      renderedOwner,
    )) {
      return;
    }
    final initiatingOrganizerUuid = widget.organizer.uuid;
    var actionOwner = renderedOwner;
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      final expectedAuthenticatedGeneration = _authIdentityGeneration + 1;
      final allowed = await GuestRestrictionDialog.show(
        context,
        featureName: switch (action) {
          PendingOrganizerAction.follow =>
            context.l10n.guestFeatureFollowOrganizer,
          PendingOrganizerAction.contact =>
            context.l10n.guestFeatureContactThisOrganizer,
          PendingOrganizerAction.coordinates =>
            context.l10n.guestFeatureViewCoordinates,
          PendingOrganizerAction.join => context.l10n.guestFeatureJoinOrganizer,
        },
      );
      if (!allowed ||
          !mounted ||
          _authIdentityGeneration != expectedAuthenticatedGeneration ||
          widget.organizer.uuid != initiatingOrganizerUuid) {
        return;
      }
      final authenticatedOwner = ref.read(authSessionKeyProvider);
      if (authenticatedOwner.accountId == null) return;
      actionOwner = authenticatedOwner;
    }
    if (actionOwner.accountId == null ||
        !identical(
          ref.read(authSessionKeyProvider),
          actionOwner,
        ) ||
        widget.organizer.uuid != initiatingOrganizerUuid) {
      return;
    }
    _runAction(action, ownerSession: actionOwner);
  }

  void _runAction(
    PendingOrganizerAction action, {
    required AuthSessionKey ownerSession,
  }) {
    if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
    final orgName = widget.organizer.displayName?.isNotEmpty ?? false
        ? widget.organizer.displayName!
        : widget.organizer.name;
    switch (action) {
      case PendingOrganizerAction.follow:
        _toggleFollow(ownerSession);
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
          ownerSession: ownerSession,
        );
    }
  }

  Future<void> _toggleFollow(AuthSessionKey ownerSession) async {
    if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
    final provider = followStateControllerProvider(widget.organizer.uuid);
    if (ownerSession.accountId == null) return;
    final ownerNotifier = ref.read(provider.notifier);
    final wasFollowing = ref.read(provider).valueOrNull?.isFollowed ?? false;
    try {
      await ownerNotifier.toggle();
      if (!mounted ||
          !identical(ref.read(authSessionKeyProvider), ownerSession) ||
          !identical(ref.read(provider.notifier), ownerNotifier)) {
        return;
      }
    } catch (error) {
      if (!mounted ||
          !identical(ref.read(authSessionKeyProvider), ownerSession) ||
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
