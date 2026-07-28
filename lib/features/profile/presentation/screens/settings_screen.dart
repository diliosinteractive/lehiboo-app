import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/analytics/analytics_consent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/dio_client.dart';
import '../../../../config/env_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/legal/legal_links.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/push_notification_provider.dart';
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
  bool _testingRefresh = false;

  Future<void> _togglePref({
    required bool current,
    required bool isPush,
  }) async {
    final newValue = !current;
    setState(() {
      if (isPush) {
        _busyPush = true;
      } else {
        _busyNewsletter = true;
      }
    });

    try {
      final api = ref.read(profileApiDataSourceProvider);

      final updatedDto = await api.updateProfile(
        newsletter: isPush ? null : newValue,
        pushNotificationsEnabled: isPush ? newValue : null,
      );

      // Synchroniser l'auth state local
      ref.read(authProvider.notifier).updateUser(updatedDto);

      if (isPush && newValue) {
        // requestPermission() triggers the OS prompt when needed and registers
        // the subscription with the backend on grant. The OS prompt is the
        // canonical path now that initialize() no longer prompts.
        final registered = await ref
            .read(pushNotificationProvider.notifier)
            .requestPermission();
        if (!registered && mounted) {
          PetitBooToast.error(
            context,
            context.l10n.settingsPushPermissionRequired,
          );
        }
      }

      // Plan 05 : la mise à jour wallet et le toast `+30 H NotificationsOptIn`
      // sont gérés globalement par HibonsUpdateInterceptor.
    } catch (e) {
      if (mounted) {
        PetitBooToast.error(context, context.l10n.settingsUpdateFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _busyPush = false;
          _busyNewsletter = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = ref.watch(appLocaleControllerProvider);
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
                  final notifier =
                      ref.read(analyticsConsentProvider.notifier);
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
          // ── Debug only ────────────────────────────────────────────────────
          // Outil de diagnostic du flow de refresh token (cf.
          // docs/audits/analyse-authentification-deconnexions.md). Corrompt
          // l'access token puis tape une route protégée pour forcer un vrai 401
          // → l'intercepteur JwtAuthInterceptor déclenche _refreshAccessToken().
          // Jamais compilé en release (kDebugMode).
          if (kDebugMode) ...[
            const Divider(),
            _buildSectionHeader('Debug'),
            ListTile(
              leading: _testingRefresh
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.refresh, color: Color(0xFFFF601F)),
              title: const Text('Tester le refresh token'),
              subtitle: const Text(
                'Simule un 401 → déclenche le flow de refresh',
              ),
              onTap: _testingRefresh ? null : _testTokenRefreshFlow,
            ),
          ],
        ],
      ),
    );
  }

  /// Diagnostic : force un 401 réel sur une route protégée pour exercer le
  /// vrai chemin de refresh de [JwtAuthInterceptor].
  ///
  /// 1. lit access + refresh token (et détecte le cas `refresh == access`,
  ///    hypothèse C1 de l'audit) ;
  /// 2. corrompt l'access token en storage ;
  /// 3. tape `/me/alerts` via `DioClient.instance` (passe par l'intercepteur) ;
  /// 4. interprète le résultat :
  ///    - 200 → le refresh a réussi et la requête a été rejouée ;
  ///    - exception 401 → le refresh a échoué (et `forceLogout` se déclenche).
  Future<void> _testTokenRefreshFlow() async {
    final messenger = ScaffoldMessenger.of(context);
    const storage = SharedSecureStorage.instance;

    final accessBefore = await storage.read(key: AppConstants.keyAuthToken);
    final refreshBefore =
        await storage.read(key: AppConstants.keyRefreshToken);

    if (accessBefore == null || accessBefore.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Aucun token en storage — connecte-toi d’abord.'),
        ),
      );
      return;
    }

    final sameToken = accessBefore == refreshBefore;
    debugPrint(
      '🧪 RefreshTest: access.len=${accessBefore.length}, '
      'refresh.len=${refreshBefore?.length}, refresh==access: $sameToken',
    );

    setState(() => _testingRefresh = true);

    // Corrompt l'access token : le prochain appel protégé renverra un vrai 401.
    final corrupted = 'invalid.$accessBefore';
    await storage.write(key: AppConstants.keyAuthToken, value: corrupted);
    debugPrint('🧪 RefreshTest: access token corrompu → appel /me/alerts');

    String result;
    Color color;
    try {
      await DioClient.instance.get<dynamic>('/me/alerts');
      final accessAfter = await storage.read(key: AppConstants.keyAuthToken);
      final rotated = accessAfter != null && accessAfter != corrupted;
      if (rotated) {
        result = '✅ Refresh OK : nouveau token obtenu, requête rejouée.';
        color = Colors.green.shade700;
      } else {
        result = '⚠️ Requête passée mais token inchangé — à vérifier.';
        color = Colors.orange.shade800;
      }
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      result = '❌ Refresh échoué (HTTP $code). '
          '${sameToken ? "refresh_token == access_token (cause C1). " : ""}'
          'Déconnexion forcée déclenchée.';
      color = Colors.red.shade700;
    } catch (e) {
      result = '❌ Erreur inattendue : $e';
      color = Colors.red.shade700;
    }

    debugPrint('🧪 RefreshTest: $result');
    if (!mounted) return;
    setState(() => _testingRefresh = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(result),
        backgroundColor: color,
        duration: const Duration(seconds: 6),
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

  Future<void> _openAccountDeletionPage(BuildContext context) async {
    final l10n = context.l10n;
    final uri = _accountDeletionUri(context);

    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (ok) return;
    if (!context.mounted) return;

    final fallbackOk =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (fallbackOk) return;
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsAccountDeletionOpenFailed)),
    );
  }

  void _showAccountDeletionConfirmation(BuildContext context) {
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
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
              dialogContext.pop();
              _openAccountDeletionPage(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );
  }
}
