import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../partners/presentation/widgets/organizer_avatar.dart';
import '../../data/models/invitation_dto.dart';
import '../../data/models/membership_dto.dart';
import '../providers/invitation_peek_provider.dart';
import '../providers/memberships_screen_providers.dart';
import '../widgets/_status_chip.dart';

/// Deep-link landing for `/invitations/:token` — spec §14.3.
///
/// Renders the invitation preview for both authenticated and
/// unauthenticated users. Unauth users see a "Se connecter" CTA that
/// pushes /login with a redirect back to this screen on success. Auth users
/// see Accept/Décliner buttons.
class InvitationLandingScreen extends ConsumerWidget {
  final String token;

  const InvitationLandingScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(
      authProvider.select((s) => s.isAuthenticated),
    );
    final peekAsync = ref.watch(invitationPeekProvider(token));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Invitation',
          style: TextStyle(
            color: HbColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: HbColors.textPrimary),
      ),
      body: peekAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (e, _) => _NotFoundState(),
        data: (preview) {
          final invitation = preview.data;
          if (invitation == null) {
            return _NotFoundState();
          }
          return _Body(
            invitation: invitation,
            preview: preview,
            isAuthenticated: isAuthenticated,
            token: token,
          );
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final InvitationDto invitation;
  final InvitationPreviewDto preview;
  final bool isAuthenticated;
  final String token;

  const _Body({
    required this.invitation,
    required this.preview,
    required this.isAuthenticated,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = invitation.organization;
    final orgName = org?.name ?? '—';
    final isExpiredOrAccepted = invitation.isExpired || invitation.isAccepted;
    final action = ref.watch(invitationActionControllerProvider(token));
    final isInFlight = action.valueOrNull?.isInFlight ?? false;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrganizerAvatar(
              logoUrl: org?.logoOrUrl,
              fallbackName: orgName,
              size: 64,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          orgName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: HbColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (invitation.isExpired)
                        StatusChip.expired()
                      else
                        StatusChip.invitation(),
                    ],
                  ),
                  if (org?.city != null && org!.city!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        org.city!,
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (invitation.invitedBy?.name.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Invité par ${invitation.invitedBy!.name}',
              style: GoogleFonts.figtree(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        Text(
          _statusBlurb(invitation, preview),
          style: GoogleFonts.figtree(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        if (isExpiredOrAccepted)
          _DismissedNotice(invitation: invitation)
        else if (!isAuthenticated)
          _LoginCta(token: token, hasAccount: invitation.hasAccount)
        else
          _AcceptDeclineRow(
            isInFlight: isInFlight,
            onAccept: () => _onAccept(context, ref, orgName),
            onDecline: () => _onDecline(context, ref, orgName),
          ),
      ],
    );
  }

  String _statusBlurb(InvitationDto i, InvitationPreviewDto preview) {
    if (i.isExpired) {
      return "Cette invitation a expiré. Demandez à l'organisation de "
          "vous renvoyer une invitation.";
    }
    if (i.isAccepted) {
      return "Cette invitation a déjà été acceptée. Retrouvez l'organisation "
          "dans votre liste d'adhésions.";
    }
    final hours = preview.meta?.expiresInHours;
    if (hours != null && hours > 0) {
      return "Vous êtes invité(e) à rejoindre cet espace privé. "
          "Acceptez l'invitation pour accéder aux événements exclusifs. "
          "Cette invitation expire dans $hours h.";
    }
    return "Vous êtes invité(e) à rejoindre cet espace privé. "
        "Acceptez l'invitation pour accéder aux événements exclusifs.";
  }

  Future<void> _onAccept(
    BuildContext context,
    WidgetRef ref,
    String orgName,
  ) async {
    final ok = await ref
        .read(invitationActionControllerProvider(token).notifier)
        .accept();
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenue dans $orgName')),
      );
      context.go('/me/memberships?tab=active');
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
    final ok = await ref
        .read(invitationActionControllerProvider(token).notifier)
        .decline();
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation déclinée')),
      );
      context.go('/me/memberships');
    }
  }
}

class _AcceptDeclineRow extends StatelessWidget {
  final bool isInFlight;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _AcceptDeclineRow({
    required this.isInFlight,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isInFlight ? null : onDecline,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[800],
              side: BorderSide(color: Colors.grey[400]!),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Décliner'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isInFlight ? null : onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isInFlight
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Accepter'),
          ),
        ),
      ],
    );
  }
}

class _LoginCta extends StatelessWidget {
  final String token;
  final bool? hasAccount;

  const _LoginCta({required this.token, required this.hasAccount});

  @override
  Widget build(BuildContext context) {
    final redirect = Uri.encodeQueryComponent('/invitations/$token');
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/login?redirect=$redirect'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Se connecter pour accepter',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (hasAccount == false) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.push('/register'),
            child: const Text('Créer un compte'),
          ),
        ],
      ],
    );
  }
}

class _DismissedNotice extends StatelessWidget {
  final InvitationDto invitation;

  const _DismissedNotice({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            invitation.isAccepted
                ? Icons.check_circle_outline
                : Icons.history_toggle_off,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              invitation.isAccepted
                  ? 'Invitation déjà acceptée.'
                  : 'Invitation expirée.',
              style: GoogleFonts.figtree(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link_off, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Cette invitation est introuvable.',
              style: GoogleFonts.figtree(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Le lien a peut-être été désactivé. Demandez à l'organisateur "
              "de vous renvoyer une invitation.",
              textAlign: TextAlign.center,
              style: GoogleFonts.figtree(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
