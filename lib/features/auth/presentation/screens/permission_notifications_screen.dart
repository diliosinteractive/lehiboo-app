import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../notifications/presentation/providers/push_notification_provider.dart';
import '../../../notifications/presentation/utils/push_notification_error_message.dart';
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
  String? _errorMessage;

  Future<void> _onContinue() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _errorMessage = null;
    });

    try {
      // If push is already initialized (permission granted + subscription
      // registered with backend), there's nothing to prompt for.
      final alreadyGranted = ref.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized;
      final grantedNow = alreadyGranted
          ? true
          : await ref
              .read(pushNotificationProvider.notifier)
              .requestPermission();

      if (!grantedNow) {
        if (!mounted) return;
        final failure = ref.read(pushNotificationProvider).failureReason;
        setState(() {
          _errorMessage = pushNotificationErrorMessage(context.l10n, failure);
        });
        return;
      }

      // Persist only after the device setup succeeds. If this request fails,
      // keep the user on this optional step so they can retry or skip it.
      try {
        final api = ref.read(profileApiDataSourceProvider);
        final updatedUser =
            await api.updateProfile(pushNotificationsEnabled: true);
        ref.read(authProvider.notifier).updateUser(updatedUser);
      } catch (e) {
        debugPrint('PermissionNotifications: updateProfile failed - $e');
        if (!mounted) return;
        setState(() {
          _errorMessage = ApiResponseHandler.extractError(
            e,
            fallback: context.l10n.settingsPushPreferenceUpdateFailed,
          );
        });
        return;
      }

      if (!mounted) return;
      context.go('/');
    } catch (e) {
      debugPrint('PermissionNotifications: setup failed - $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.settingsPushSetupFailed;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _skip() {
    if (_busy) return;
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
      ctaLabel: _errorMessage != null
          ? l10n.commonRetry
          : alreadyGranted
              ? l10n.commonContinue
              : l10n.authPermissionNotificationsEnable,
      busy: _busy,
      onContinue: _onContinue,
      errorMessage: _errorMessage,
      secondaryCtaLabel: l10n.authPermissionNotificationsNotNow,
      onSecondaryCta: _skip,
      grantedLabel:
          alreadyGranted ? l10n.authPermissionNotificationsGranted : null,
    );
  }
}
