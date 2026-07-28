import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';

import '../../../domain/entities/locked_event_shell.dart';
import '../../screens/event_detail_screen.dart';
import 'event_password_sheet.dart';

/// Locked-shell preview for password-protected events.
///
/// Shown when [EventDetailController] resolves to
/// `EventDetailState.locked(shell)` — typically a deep link entry where the
/// user lands on the detail screen without first going through a list-side
/// unlock. Auto-opens the password sheet on first paint; the CTA re-opens it
/// if dismissed.
class EventLockedView extends ConsumerStatefulWidget {
  final LockedEventShell shell;
  final String identifier;

  const EventLockedView({
    super.key,
    required this.shell,
    required this.identifier,
  });

  @override
  ConsumerState<EventLockedView> createState() => _EventLockedViewState();
}

class _EventLockedViewState extends ConsumerState<EventLockedView> {
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openSheet();
    });
  }

  Future<void> _openSheet() async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    try {
      await EventPasswordSheet.show(
        context,
        identifier: widget.identifier,
        onSubmit: (password) => ref
            .read(eventDetailControllerProvider(widget.identifier).notifier)
            .unlock(password),
        eventTitle: widget.shell.title,
      );
    } finally {
      if (mounted) {
        _sheetOpen = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.shell.coverImage;
    final excerpt = widget.shell.excerpt;

    return Scaffold(
      backgroundColor: HbColors.textPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (coverUrl != null && coverUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: HbColors.textPrimary),
              errorWidget: (context, url, error) =>
                  Container(color: HbColors.textPrimary),
            )
          else
            Container(color: HbColors.textPrimary),

          // Dim gradient so the lock card stays readable on any image.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _LockCard(
                        title: widget.shell.title,
                        subtitle: excerpt,
                        onUnlockPressed: _openSheet,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LockCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onUnlockPressed;

  const _LockCard({
    required this.title,
    required this.subtitle,
    required this.onUnlockPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline,
              color: HbColors.brandPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: HbColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            (subtitle != null && subtitle!.trim().isNotEmpty)
                ? subtitle!
                : context.l10n.eventPrivateFallbackSubtitle,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onUnlockPressed,
              icon: const Icon(Icons.lock_open, size: 18),
              label: Text(context.l10n.eventEnterPassword),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.white),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }
}
