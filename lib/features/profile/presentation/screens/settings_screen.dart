import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
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
        final registered = await ref
            .read(pushNotificationProvider.notifier)
            .syncTokenWithBackend();
        if (!registered && mounted) {
          PetitBooToast.error(
            context,
            'Autorisation notifications requise',
          );
        }
      }

      // Plan 05 : la mise à jour wallet et le toast `+30 H NotificationsOptIn`
      // sont gérés globalement par HibonsUpdateInterceptor.
    } catch (e) {
      if (mounted) {
        PetitBooToast.error(context, 'Mise à jour impossible');
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
    final user = ref.watch(authProvider).user;
    final newsletter = user?.newsletter ?? false;
    final pushEnabled = user?.pushNotificationsEnabled ?? false;
    final neitherEverActivated = !newsletter && !pushEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
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
          _buildSectionHeader('Préférences'),
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
                      'Active les notifications pour gagner 30 Hibons',
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
            title: const Text('Notifications push'),
            subtitle: const Text('Recevoir les alertes sur ton téléphone'),
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
            title: const Text('Newsletter'),
            subtitle: const Text(
              'Recommandations événements et bons plans par email',
            ),
            value: newsletter,
            onChanged: _busyNewsletter
                ? null
                : (_) => _togglePref(current: newsletter, isPush: false),
          ),
          const Divider(),
          _buildSectionHeader('Application'),
          ListTile(
            leading: const Icon(Icons.restart_alt, color: Color(0xFFFF601F)),
            title: const Text('Revoir l\'introduction'),
            subtitle: const Text('Redémarrer le tutoriel d\'accueil'),
            onTap: () => _showResetConfirmation(context),
          ),
          const Divider(),
          _buildSectionHeader('Informations'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text(AppConstants.appVersion),
          ),
        ],
      ),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redémarrer l\'onboarding ?'),
        content: const Text(
          'Voulez-vous vraiment revoir les écrans de bienvenue ? Cela vous déconnectera temporairement de l\'accueil.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _resetOnboarding(context);
            },
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFFFF601F)),
            child: const Text('Redémarrer'),
          ),
        ],
      ),
    );
  }
}
