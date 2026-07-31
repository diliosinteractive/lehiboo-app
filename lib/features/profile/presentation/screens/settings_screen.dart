import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/analytics/analytics_consent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/env_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../../shared/legal/legal_links.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/account_bound_route_guard.dart';
import '../../../notifications/presentation/providers/push_notification_provider.dart';
import '../../../notifications/presentation/utils/push_notification_error_message.dart';
import '../../../petit_boo/presentation/widgets/animated_toast.dart';
import '../../data/datasources/profile_api_datasource.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busyNewsletter = false;
  bool _busyPush = false;
  late final String? _ownerAccountId;
  late final AuthNotifier _ownerAuthNotifier;
  late final ProviderSubscription<String?> _sessionSubscription;
  int _sessionGeneration = 0;
  bool _sessionInvalidated = false;
  bool _exitScheduled = false;
  CancelToken? _newsletterMutationCancelToken;
  CancelToken? _pushMutationCancelToken;

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
    _cancelOutstandingWork();
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

  void _cancelOutstandingWork() {
    _newsletterMutationCancelToken?.cancel('Authentication session changed');
    _pushMutationCancelToken?.cancel('Authentication session changed');
    _newsletterMutationCancelToken = null;
    _pushMutationCancelToken = null;
  }

  void _invalidateSession() {
    if (_sessionInvalidated) return;
    _sessionInvalidated = true;
    _sessionGeneration++;
    _cancelOutstandingWork();
    _busyNewsletter = false;
    _busyPush = false;
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
        // Standalone widget tests may not provide GoRouter. The invalidated
        // screen remains blank and cannot expose or mutate account data.
      }
    });
  }

  Future<void> _togglePref({
    required bool current,
    required bool isPush,
  }) async {
    final generation = _sessionGeneration;
    if (!_ownsSession(generation)) return;

    final newValue = !current;
    final l10n = context.l10n;
    final ownerPushNotifier =
        isPush ? ref.read(pushNotificationProvider.notifier) : null;
    final profileApi = ref.read(profileApiDataSourceProvider);
    final cancelToken = CancelToken();
    if (isPush) {
      _pushMutationCancelToken?.cancel('Superseded preference update');
      _pushMutationCancelToken = cancelToken;
    } else {
      _newsletterMutationCancelToken?.cancel('Superseded preference update');
      _newsletterMutationCancelToken = cancelToken;
    }
    setState(() {
      if (isPush) {
        _busyPush = true;
      } else {
        _busyNewsletter = true;
      }
    });

    try {
      if (isPush && newValue) {
        // Do not persist an enabled preference until device permission and
        // token registration have both succeeded. Otherwise the switch would
        // claim notifications are active after a denied/failed setup.
        final registered = await ownerPushNotifier!.requestPermission();
        if (!_ownsSession(generation) ||
            !identical(
              ref.read(pushNotificationProvider.notifier),
              ownerPushNotifier,
            )) {
          return;
        }
        if (!registered) {
          if (!mounted) return;
          final failure = ref.read(pushNotificationProvider).failureReason;
          PetitBooToast.error(
            context,
            pushNotificationErrorMessage(l10n, failure),
          );
          return;
        }
      }

      if (!_ownsSession(generation)) return;
      final updatedDto = await profileApi.updateProfile(
        newsletter: isPush ? null : newValue,
        pushNotificationsEnabled: isPush ? newValue : null,
        cancelToken: cancelToken,
      );
      if (!_ownsSession(generation) ||
          (isPush
              ? !identical(_pushMutationCancelToken, cancelToken)
              : !identical(_newsletterMutationCancelToken, cancelToken))) {
        return;
      }

      // Synchroniser l'auth state local
      _ownerAuthNotifier.updateUser(updatedDto);

      // Plan 05 : la mise à jour wallet et le toast `+30 H NotificationsOptIn`
      // sont gérés globalement par HibonsUpdateInterceptor.
    } catch (e) {
      if (_ownsSession(generation) &&
          !(e is DioException && CancelToken.isCancel(e))) {
        if (!mounted) return;
        final fallback = isPush
            ? l10n.settingsPushPreferenceUpdateFailed
            : l10n.settingsNewsletterUpdateFailed;
        PetitBooToast.error(
          context,
          ApiResponseHandler.extractError(e, fallback: fallback),
        );
      }
    } finally {
      if (isPush && identical(_pushMutationCancelToken, cancelToken)) {
        _pushMutationCancelToken = null;
      } else if (!isPush &&
          identical(_newsletterMutationCancelToken, cancelToken)) {
        _newsletterMutationCancelToken = null;
      }
      if (_ownsSession(generation)) {
        setState(() {
          if (isPush) {
            _busyPush = false;
          } else {
            _busyNewsletter = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = ref.watch(appLocaleControllerProvider);
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_ownerAccountId == null ||
        currentAccountId != _ownerAccountId ||
        _sessionInvalidated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _invalidateSession();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    final user = ref.watch(authProvider).user;
    final newsletter = user?.newsletter ?? false;
    final pushEnabled = user?.pushNotificationsEnabled ?? false;
    final neitherEverActivated = !newsletter && !pushEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(l10n.settingsSectionPreferences),
          if (neitherEverActivated)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 20,
                    color: Color(0xFFFFB300),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.settingsPushReward,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SwitchListTile(
            key: const ValueKey('settings-push-switch'),
            secondary: const Icon(
              Icons.notifications_active_outlined,
              color: Color(0xFFFF601F),
            ),
            title: Text(l10n.settingsPushTitle),
            subtitle: Text(l10n.settingsPushSubtitle),
            value: pushEnabled,
            onChanged: _busyPush
                ? null
                : (_) => _togglePref(current: pushEnabled, isPush: true),
          ),
          SwitchListTile(
            key: const ValueKey('settings-newsletter-switch'),
            secondary: const Icon(
              Icons.email_outlined,
              color: Color(0xFFFF601F),
            ),
            title: Text(l10n.settingsNewsletterTitle),
            subtitle: Text(l10n.settingsNewsletterSubtitle),
            value: newsletter,
            onChanged: _busyNewsletter
                ? null
                : (_) => _togglePref(current: newsletter, isPush: false),
          ),
          const Divider(),
          _buildSectionHeader(l10n.settingsSectionApplication),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFFF601F)),
            title: Text(l10n.settingsLanguageTitle),
            subtitle: Text(
              l10n.settingsLanguageSubtitle(
                _languageName(l10n, locale.languageCode),
              ),
            ),
            onTap: () => _showLanguagePicker(context),
          ),
          //
          const Divider(),
          // Section Confidentialité — opt-in/out RGPD pour la collecte analytics.
          _buildSectionHeader(l10n.settingsSectionPrivacy),
          Consumer(
            builder: (context, ref, _) {
              final consent = ref.watch(analyticsConsentProvider);
              return SwitchListTile(
                secondary: const Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFFFF601F),
                ),
                title: Text(l10n.settingsAnalyticsConsentTitle),
                subtitle: Text(l10n.settingsAnalyticsConsentSubtitle),
                value: consent.isGranted,
                onChanged: (value) async {
                  final notifier = ref.read(analyticsConsentProvider.notifier);
                  if (value) {
                    await notifier.grant();
                  } else {
                    await notifier.deny();
                  }
                },
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(l10n.settingsSectionAccount),
          ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Colors.red.shade700,
            ),
            title: Text(
              l10n.settingsAccountDeletionTitle,
              style: TextStyle(color: Colors.red.shade700),
            ),
            subtitle: Text(l10n.settingsAccountDeletionSubtitle),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () => _showAccountDeletionConfirmation(context),
            key: const ValueKey('settings-account-deletion'),
          ),
          const Divider(),
          _buildSectionHeader(l10n.settingsSectionLegal),
          for (final doc
              in LegalDocument.values.where((d) => d != LegalDocument.cookies))
            ListTile(
              leading: Icon(doc.icon, color: const Color(0xFFFF601F)),
              title: Text(LegalLinks.labelFor(context, doc)),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
              onTap: () => LegalLinks.open(context, doc),
            ),
          const Divider(),
          _buildSectionHeader(l10n.settingsSectionInformation),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsVersionTitle),
            trailing: const Text(AppConstants.appVersion),
          ),
        ],
      ),
    );
  }

  String _languageName(AppLocalizations l10n, String languageCode) {
    return switch (languageCode) {
      'en' => l10n.languageEnglish,
      _ => l10n.languageFrench,
    };
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final l10n = sheetContext.l10n;

        return SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final selected = ref.watch(appLocaleControllerProvider);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.settingsLanguageDialogTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  for (final option in supportedAppLocales)
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(_languageName(l10n, option.languageCode)),
                      trailing: selected.languageCode == option.languageCode
                          ? const Icon(
                              Icons.check,
                              color: Color(0xFFFF601F),
                            )
                          : null,
                      onTap: () async {
                        await ref
                            .read(appLocaleControllerProvider.notifier)
                            .setLanguageCode(option.languageCode);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Uri _accountDeletionUri(BuildContext context) {
    final baseUrl = EnvConfig.websiteUrl.endsWith('/')
        ? EnvConfig.websiteUrl.substring(0, EnvConfig.websiteUrl.length - 1)
        : EnvConfig.websiteUrl;
    final locale = normalizeLanguageCode(context.appLanguageCode) ??
        fallbackAppLocale.languageCode;

    return Uri.parse('$baseUrl/$locale/account-deletion');
  }

  Future<void> _openAccountDeletionPage(
    BuildContext context, {
    required String ownerAccountId,
    required int generation,
  }) async {
    if (!_ownsSession(generation) || ownerAccountId != _ownerAccountId) return;
    final l10n = context.l10n;
    final uri = _accountDeletionUri(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (ok) return;
    if (!context.mounted ||
        !_ownsSession(generation) ||
        ownerAccountId != _ownerAccountId) {
      return;
    }

    final fallbackOk =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (fallbackOk) return;
    if (!context.mounted ||
        !_ownsSession(generation) ||
        ownerAccountId != _ownerAccountId) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsAccountDeletionOpenFailed)),
    );
  }

  void _showAccountDeletionConfirmation(BuildContext context) {
    final ownerAccountId = _ownerAccountId;
    final generation = _sessionGeneration;
    if (ownerAccountId == null || !_ownsSession(generation)) return;
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      builder: (routeContext) => AccountBoundRouteGuard<void>(
        ownerAccountId: ownerAccountId,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.settingsAccountDeletionDialogTitle),
          content: Text(l10n.settingsAccountDeletionDialogContent),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () {
                if (!_ownsSession(generation)) {
                  dialogContext.pop();
                  return;
                }
                dialogContext.pop();
                _openAccountDeletionPage(
                  context,
                  ownerAccountId: ownerAccountId,
                  generation: generation,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: Text(l10n.commonContinue),
            ),
          ],
        ),
      ),
    );
  }
}
