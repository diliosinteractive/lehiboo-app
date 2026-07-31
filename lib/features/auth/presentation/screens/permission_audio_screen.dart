import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/l10n/l10n.dart';
import '../widgets/permission_explainer_scaffold.dart';

class PermissionAudioScreen extends ConsumerStatefulWidget {
  const PermissionAudioScreen({super.key});

  @override
  ConsumerState<PermissionAudioScreen> createState() =>
      _PermissionAudioScreenState();
}

class _PermissionAudioScreenState extends ConsumerState<PermissionAudioScreen> {
  bool _busy = false;
  bool _alreadyGranted = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    try {
      final status = await Permission.microphone.status;
      if (!mounted) return;
      setState(() {
        _alreadyGranted = status.isGranted;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('PermissionAudio: permission check failed - $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.authPermissionAudioSetupFailed;
      });
    }
  }

  Future<void> _onContinue() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _errorMessage = null;
    });

    try {
      if (!_alreadyGranted) {
        final mic = await Permission.microphone.request();
        // On iOS, speech_to_text also needs the speech recognition permission.
        // On Android it's a no-op, so calling it unconditionally is safe.
        if (mic.isGranted) {
          await Permission.speech.request();
        }
      }

      if (!mounted) return;
      // Final step of first-launch onboarding — land on the login page next.
      context.go('/login');
    } catch (e) {
      debugPrint('PermissionAudio: setup failed - $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.authPermissionAudioSetupFailed;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _continueWithoutAudio() {
    if (_busy) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PermissionExplainerScaffold(
      icon: Icons.mic_none_outlined,
      title: l10n.authPermissionAudioTitle,
      intro: l10n.authPermissionAudioIntro,
      bullets: [
        l10n.authPermissionAudioBulletQuestions,
        l10n.authPermissionAudioBulletDictate,
        l10n.authPermissionAudioBulletHandsFree,
      ],
      reassurance: l10n.authPermissionReassurance,
      ctaLabel: _errorMessage == null ? l10n.commonContinue : l10n.commonRetry,
      busy: _busy,
      onContinue: _onContinue,
      errorMessage: _errorMessage,
      secondaryCtaLabel: _errorMessage == null
          ? null
          : l10n.authPermissionAudioContinueWithout,
      onSecondaryCta: _errorMessage == null ? null : _continueWithoutAudio,
      grantedLabel: _alreadyGranted ? l10n.authPermissionAudioGranted : null,
    );
  }
}
