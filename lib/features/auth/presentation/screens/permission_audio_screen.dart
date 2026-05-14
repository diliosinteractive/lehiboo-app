import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.microphone.status;
    if (!mounted) return;
    setState(() => _alreadyGranted = status.isGranted);
  }

  Future<void> _onContinue() async {
    if (_busy) return;
    setState(() => _busy = true);

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
  }

  @override
  Widget build(BuildContext context) {
    return PermissionExplainerScaffold(
      icon: Icons.mic_none_outlined,
      title: 'Discutez en vocal avec Petit Boo',
      intro:
          'Activez le micro pour interagir à la voix avec Petit Boo, notre '
          'assistant IA dédié aux sorties.',
      bullets: const [
        'Posez vos questions à la voix, sans clavier',
        'Dictez vos messages plus rapidement',
        'Trouvez des sorties les mains libres',
      ],
      reassurance:
          'Vous pouvez changer cet accès à tout moment dans les réglages.',
      ctaLabel: 'Continuer',
      busy: _busy,
      onContinue: _onContinue,
      grantedLabel: _alreadyGranted ? 'Micro déjà activé' : null,
    );
  }
}
