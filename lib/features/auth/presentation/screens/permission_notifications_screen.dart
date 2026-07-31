import 'package:dio/dio.dart';
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
  late final String? _ownerAccountId;
  late final AuthNotifier _ownerAuthNotifier;
  late final ProviderSubscription<String?> _sessionSubscription;
  int _sessionGeneration = 0;
  bool _sessionInvalidated = false;
  bool _exitScheduled = false;
  CancelToken? _profileMutationCancelToken;

  @override
  void initState() {
    super.initState();
    _ownerAccountId = ref.read(authSessionUserIdProvider);
    _ownerAuthNotifier = ref.read(authProvider.notifier);
    _sessionSubscription = ref.listenManual<String?>(
      authSessionUserIdProvider,
      (_, next) {
        if (next != _ownerAccountId) _invalidateSession();
      },
    );
  }

  @override
  void dispose() {
    _sessionGeneration++;
    _profileMutationCancelToken?.cancel('Authentication session changed');
    _profileMutationCancelToken = null;
    _sessionSubscription.close();
    super.dispose();
  }

  bool _ownsSession(int generation) {
    final ownerAccountId = _ownerAccountId;
    return mounted &&
        !_sessionInvalidated &&
        ownerAccountId != null &&
        generation == _sessionGeneration &&
        ref.read(authSessionUserIdProvider) == ownerAccountId &&
        identical(ref.read(authProvider.notifier), _ownerAuthNotifier);
  }

  void _invalidateSession() {
    if (_sessionInvalidated) return;
    _sessionInvalidated = true;
    _sessionGeneration++;
    _profileMutationCancelToken?.cancel('Authentication session changed');
    _profileMutationCancelToken = null;
    _busy = false;
    _errorMessage = null;
    if (mounted) setState(() {});
    _scheduleFailClosedExit();
  }

  void _scheduleFailClosedExit() {
    if (_exitScheduled || !mounted) return;
    _exitScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ownedRoute = ModalRoute.of(context);
      final navigator = Navigator.of(context);
      if (ownedRoute != null) {
        navigator.popUntil((route) => identical(route, ownedRoute));
        if (ownedRoute.isCurrent && navigator.canPop()) {
          navigator.pop();
          return;
        }
      }
      try {
        GoRouter.of(context).go('/');
      } catch (_) {
        // A standalone test host may not provide GoRouter. The invalidated
        // screen is still blank and all callbacks are disabled.
      }
    });
  }

  Future<void> _onContinue() async {
    final generation = _sessionGeneration;
    if (_busy || !_ownsSession(generation)) return;
    final l10n = context.l10n;
    final ownerPushNotifier = ref.read(pushNotificationProvider.notifier);
    final profileApi = ref.read(profileApiDataSourceProvider);
    final cancelToken = CancelToken();
    _profileMutationCancelToken?.cancel('Superseded notification setup');
    _profileMutationCancelToken = cancelToken;
    setState(() {
      _busy = true;
      _errorMessage = null;
    });

    try {
      // If push is already initialized (permission granted + subscription
      // registered with backend), there's nothing to prompt for.
      final alreadyGranted = ref.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized;
      final grantedNow =
          alreadyGranted ? true : await ownerPushNotifier.requestPermission();

      if (!_ownsSession(generation) ||
          !identical(
            ref.read(pushNotificationProvider.notifier),
            ownerPushNotifier,
          )) {
        return;
      }

      if (!grantedNow) {
        final failure = ref.read(pushNotificationProvider).failureReason;
        setState(() {
          _errorMessage = pushNotificationErrorMessage(l10n, failure);
        });
        return;
      }

      // Persist only after the device setup succeeds. If this request fails,
      // keep the user on this optional step so they can retry or skip it.
      try {
        final updatedUser = await profileApi.updateProfile(
          pushNotificationsEnabled: true,
          cancelToken: cancelToken,
        );
        if (!_ownsSession(generation) ||
            !identical(_profileMutationCancelToken, cancelToken) ||
            !identical(
              ref.read(pushNotificationProvider.notifier),
              ownerPushNotifier,
            )) {
          return;
        }
        _ownerAuthNotifier.updateUser(updatedUser);
      } catch (e) {
        debugPrint('PermissionNotifications: updateProfile failed - $e');
        if (!_ownsSession(generation) ||
            (e is DioException && CancelToken.isCancel(e))) {
          return;
        }
        setState(() {
          _errorMessage = ApiResponseHandler.extractError(
            e,
            fallback: l10n.settingsPushPreferenceUpdateFailed,
          );
        });
        return;
      }

      if (!_ownsSession(generation)) return;
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      debugPrint('PermissionNotifications: setup failed - $e');
      if (!_ownsSession(generation) ||
          (e is DioException && CancelToken.isCancel(e))) {
        return;
      }
      setState(() {
        _errorMessage = l10n.settingsPushSetupFailed;
      });
    } finally {
      if (identical(_profileMutationCancelToken, cancelToken)) {
        _profileMutationCancelToken = null;
      }
      if (_ownsSession(generation)) {
        setState(() => _busy = false);
      }
    }
  }

  void _skip() {
    if (_busy || !_ownsSession(_sessionGeneration)) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_ownerAccountId == null ||
        currentAccountId != _ownerAccountId ||
        _sessionInvalidated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _invalidateSession();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
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
