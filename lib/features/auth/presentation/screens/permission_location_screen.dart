import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      final granted = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      if (!mounted) return;
      setState(() {
        _alreadyGranted = granted;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('PermissionLocation: permission check failed - $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.authPermissionLocationSetupFailed;
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
          _refreshLocationInBackground();
        }
      } else {
        // Already granted earlier — make sure the cached position is fresh.
        _refreshLocationInBackground();
      }

      if (!mounted) return;
      // Next step of first-launch onboarding: the audio permission screen.
      context.go('/post-signup/audio');
    } catch (e) {
      debugPrint('PermissionLocation: setup failed - $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.authPermissionLocationSetupFailed;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _refreshLocationInBackground() {
    unawaited(
      ref.read(userLocationProvider.notifier).refresh().catchError((Object e) {
        debugPrint('PermissionLocation: location refresh failed - $e');
      }),
    );
  }

  void _continueWithoutLocation() {
    if (_busy) return;
    context.go('/post-signup/audio');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PermissionExplainerScaffold(
      icon: Icons.location_on_outlined,
      title: l10n.authPermissionLocationTitle,
      intro: l10n.authPermissionLocationIntro,
      bullets: [
        l10n.authPermissionLocationBulletMap,
        l10n.authPermissionLocationBulletSearch,
        l10n.authPermissionLocationBulletSuggestions,
      ],
      reassurance: l10n.authPermissionReassurance,
      ctaLabel: _errorMessage == null ? l10n.commonContinue : l10n.commonRetry,
      busy: _busy,
      onContinue: _onContinue,
      errorMessage: _errorMessage,
      secondaryCtaLabel: _errorMessage == null
          ? null
          : l10n.authPermissionLocationContinueWithout,
      onSecondaryCta: _errorMessage == null ? null : _continueWithoutLocation,
      grantedLabel: _alreadyGranted ? l10n.authPermissionLocationGranted : null,
    );
  }
}
