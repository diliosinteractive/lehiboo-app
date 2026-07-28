import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
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
        : await ref.read(pushNotificationProvider.notifier).requestPermission();

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
    final l10n = context.l10n;
    final alreadyGranted = ref.watch(pushNotificationProvider).status ==
        PushNotificationStatus.initialized;

    return PermissionExplainerScaffold(
      icon: Icons.notifications_active_outlined,
      title: l10n.authPermissionNotificationsTitle,
      intro: l10n.authPermissionNotificationsIntro,
      bullets: [
        l10n.authPermissionNotificationsBulletTickets,
        l10n.authPermissionNotificationsBulletAlerts,
        l10n.authPermissionNotificationsBulletFavorites,
        l10n.authPermissionNotificationsBulletReminders,
        l10n.authPermissionNotificationsBulletMessages,
      ],
      reassurance: l10n.authPermissionReassurance,
      ctaLabel: l10n.commonContinue,
      busy: _busy,
      onContinue: _onContinue,
      grantedLabel:
          alreadyGranted ? l10n.authPermissionNotificationsGranted : null,
    );
  }
}
