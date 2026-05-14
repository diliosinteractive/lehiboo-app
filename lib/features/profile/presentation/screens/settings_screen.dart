import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyOnboardingCompleted);
    if (context.mounted) {
      context.go('/onboarding');
    }
  }

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
          ListTile(
            leading: const Icon(Icons.restart_alt, color: Color(0xFFFF601F)),
            title: Text(l10n.settingsResetOnboardingTitle),
            subtitle: Text(l10n.settingsResetOnboardingSubtitle),
            onTap: () => _showResetConfirmation(context),
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

  void _showResetConfirmation(BuildContext context) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsResetDialogTitle),
        content: Text(l10n.settingsResetDialogContent),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _resetOnboarding(context);
            },
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFFFF601F)),
            child: Text(l10n.commonRestart),
          ),
        ],
      ),
    );
  }
}
