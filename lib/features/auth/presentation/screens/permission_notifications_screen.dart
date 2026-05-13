import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../notifications/presentation/providers/push_notification_provider.dart';
import '../../../profile/data/datasources/profile_api_datasource.dart';
import '../providers/auth_provider.dart';
import '../widgets/permission_explainer_scaffold.dart';

class PermissionNotificationsScreen extends ConsumerStatefulWidget {
  const PermissionNotificationsScreen({super.key});

  @override
  ConsumerState<PermissionNotificationsScreen> createState() =>
      _PermissionNotificationsScreenState();
}

class _PermissionNotificationsScreenState
    extends ConsumerState<PermissionNotificationsScreen> {
  bool _busy = false;

  Future<void> _onContinue() async {
    if (_busy) return;
    setState(() => _busy = true);

    // If push is already initialized (permission granted + subscription
    // registered with backend), there's nothing to prompt for.
    final alreadyGranted = ref.read(pushNotificationProvider).status ==
        PushNotificationStatus.initialized;
    final grantedNow = alreadyGranted
        ? true
        : await ref
            .read(pushNotificationProvider.notifier)
            .requestPermission();

    // Persist the user's notification preference on the backend whenever
    // the OS permission ends up granted. Silent failure — a network blip
    // shouldn't block the user from reaching Home; the Settings toggle
    // can recover the flag later.
    if (grantedNow) {
      try {
        final api = ref.read(profileApiDataSourceProvider);
        final updatedUser =
            await api.updateProfile(pushNotificationsEnabled: true);
        ref.read(authProvider.notifier).updateUser(updatedUser);
      } catch (e) {
        debugPrint('PermissionNotifications: updateProfile failed - $e');
      }
    }

    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final alreadyGranted = ref.watch(pushNotificationProvider).status ==
        PushNotificationStatus.initialized;
    return PermissionExplainerScaffold(
      icon: Icons.notifications_active_outlined,
      title: 'Ne ratez rien des bons plans',
      intro:
          'Activez les notifications pour recevoir l\'essentiel directement '
          'sur votre téléphone.',
      bullets: const [
        'Vos billets et confirmations de réservation',
        'Les événements qui matchent vos alertes',
        'Les nouveautés de vos lieux favoris',
        'Vos rappels et alertes personnalisées',
        'Les réponses des organisateurs à vos messages',
      ],
      reassurance:
          'Vous pouvez changer cet accès à tout moment dans les réglages.',
      ctaLabel: 'Continuer',
      busy: _busy,
      onContinue: _onContinue,
      grantedLabel: alreadyGranted ? 'Notifications déjà activées' : null,
    );
  }
}
