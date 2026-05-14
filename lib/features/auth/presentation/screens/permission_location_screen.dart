import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../home/presentation/providers/user_location_provider.dart';
import '../widgets/permission_explainer_scaffold.dart';

class PermissionLocationScreen extends ConsumerStatefulWidget {
  const PermissionLocationScreen({super.key});

  @override
  ConsumerState<PermissionLocationScreen> createState() =>
      _PermissionLocationScreenState();
}

class _PermissionLocationScreenState
    extends ConsumerState<PermissionLocationScreen> {
  bool _busy = false;
  bool _alreadyGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final permission = await Geolocator.checkPermission();
    final granted = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    if (!mounted) return;
    setState(() => _alreadyGranted = granted);
  }

  Future<void> _onContinue() async {
    if (_busy) return;
    setState(() => _busy = true);

    // If permission is already granted (e.g. previously installed app or
    // re-entering this screen), don't re-prompt — just navigate.
    if (!_alreadyGranted) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final granted = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      if (granted) {
        unawaited(ref.read(userLocationProvider.notifier).refresh());
      }
    } else {
      // Already granted earlier — make sure the cached position is fresh.
      unawaited(ref.read(userLocationProvider.notifier).refresh());
    }

    if (!mounted) return;
    // Next step of first-launch onboarding: the audio permission screen.
    context.go('/post-signup/audio');
  }

  @override
  Widget build(BuildContext context) {
    return PermissionExplainerScaffold(
      icon: Icons.location_on_outlined,
      title: 'Trouvez des sorties près de vous',
      intro:
          'LeHiboo Experiences utilise votre position pour vous suggérer les '
          'meilleurs événements à proximité.',
      bullets: const [
        'Voir les événements à proximité sur la carte',
        'Filtrer la recherche selon votre position',
        'Recevoir des suggestions adaptées à votre ville',
      ],
      reassurance:
          'Vous pouvez changer cet accès à tout moment dans les réglages.',
      ctaLabel: 'Continuer',
      busy: _busy,
      onContinue: _onContinue,
      grantedLabel: _alreadyGranted ? 'Localisation déjà activée' : null,
    );
  }
}
