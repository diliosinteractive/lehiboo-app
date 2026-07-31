import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/env_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../auth/presentation/widgets/account_bound_route_guard.dart';
import '../../../checkin/presentation/providers/vendor_eligibility_provider.dart';
import '../../../messages/presentation/providers/unread_count_provider.dart';
import '../../../reviews/presentation/providers/pending_count_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import '../../data/datasources/profile_api_datasource.dart';
import '../providers/profile_provider.dart';
import '../utils/profile_image_picker_error.dart';

typedef ProfileAvatarImagePicker = Future<XFile?> Function();

/// Indirection kept at the UI boundary so an account switch while the native
/// gallery is open can be covered deterministically in widget tests.
final profileAvatarImagePickerProvider = Provider<ProfileAvatarImagePicker>(
  (ref) {
    final picker = ImagePicker();
    return () => picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 85,
        );
  },
);

class _ProfileField {
  final String label;
  final bool filled;
  const _ProfileField(this.label, this.filled);
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isAuthenticated = authState.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profileTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: isAuthenticated && user != null
          ? _buildAuthenticatedContent(context, ref, user)
          : _buildUnauthenticatedContent(context),
    );
  }

  Widget _buildAuthenticatedContent(BuildContext context, WidgetRef ref, user) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    final accountId = ownerSession.accountId;
    final displayName = user.displayName.isNotEmpty
        ? user.displayName
        : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
    final avatarUrl = user.avatarUrl;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // User Info Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar (tap to change — same flow as Mon Compte)
              _EditableAvatar(
                key: ValueKey('profile-avatar-$accountId'),
                ownerAccountId: accountId,
                avatarUrl: avatarUrl,
                displayName: displayName,
                size: 80,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.isNotEmpty
                          ? displayName
                          : context.l10n.profileDefaultUser,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HbColors.textSlate,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (user.city != null && user.city!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            user.city!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Badge rang HIBONs
                    _buildRankBadge(ref),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Profile completion (5 fields → reward 50 H lifetime)
        _buildProfileCompletionCard(context, user),
        const SizedBox(height: 24),

        // Statistics Section
        _buildStatisticsSection(context, ref),
        const SizedBox(height: 24),

        // Menu Items
        _buildMenuItem(
          context,
          icon: Icons.confirmation_number_outlined,
          title: context.l10n.profileBookingsTitle,
          subtitle: context.l10n.profileBookingsSubtitle,
          onTap: () => context.push('/my-bookings'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.person_add_alt_1_outlined,
          title: context.l10n.profileParticipantsTitle,
          subtitle: context.l10n.profileParticipantsSubtitle,
          onTap: () => context.push('/participants'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.favorite_outline,
          title: context.l10n.profileFavoritesTitle,
          subtitle: context.l10n.profileFavoritesSubtitle,
          onTap: () => context.push('/favorites'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.storefront_outlined,
          title: context.l10n.profileOrganizersDirectoryTitle,
          subtitle: context.l10n.profileOrganizersDirectorySubtitle,
          onTap: () => context.push('/organizers'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.groups_outlined,
          title: context.l10n.profileFollowedOrganizersTitle,
          subtitle: context.l10n.profileFollowedOrganizersSubtitle,
          onTap: () => context.push('/me/followed-organizers'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.workspaces_outline,
          title: context.l10n.profileMembershipsTitle,
          subtitle: context.l10n.profileMembershipsSubtitle,
          onTap: () => context.push('/me/memberships'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.mail_outline,
          title: context.l10n.profileMessagesTitle,
          subtitle: context.l10n.profileMessagesSubtitle,
          badge: ref.watch(unreadCountProvider),
          onTap: () => context.push('/messages'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.route,
          title: context.l10n.profileTripsTitle,
          subtitle: context.l10n.profileTripsSubtitle,
          onTap: () => context.push('/trip-plans'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.notifications_active_outlined,
          title: context.l10n.profileRemindersTitle,
          subtitle: context.l10n.profileRemindersSubtitle,
          onTap: () => context.push('/my-reminders'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.question_answer_outlined,
          title: context.l10n.profileQuestionsTitle,
          subtitle: context.l10n.profileQuestionsSubtitle,
          onTap: () => context.push('/my-questions'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.rate_review_outlined,
          title: context.l10n.profileReviewsTitle,
          subtitle: context.l10n.profileReviewsSubtitle,
          badge:
              ref.watch(pendingReviewCountProvider(ownerSession)).valueOrNull,
          onTap: () => context.push('/my-reviews'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.person_outline,
          title: context.l10n.profileAccountTitle,
          subtitle: context.l10n.profileAccountSubtitle,
          onTap: () => context.push('/account'),
        ),
        _buildMenuItem(
          context,
          icon: Icons
              .notifications_none_rounded, // Slightly more modern icon if possible
          title: context.l10n.profileAlertsTitle,
          subtitle: context.l10n.profileAlertsSubtitle,
          onTap: () => context.push('/alerts'),
        ),
        if (ref.watch(vendorEligibilityProvider))
          _buildMenuItem(
            context,
            icon: Icons.qr_code_scanner_outlined,
            title: context.l10n.profileVendorScanTitle,
            subtitle: context.l10n.profileVendorScanSubtitle,
            onTap: () => context.push('/vendor/scan'),
          ),
        _buildMenuItem(
          context,
          icon: Icons.volunteer_activism_outlined,
          title: context.l10n.profileSupportTitle,
          subtitle: context.l10n.profileSupportSubtitle,
          onTap: () => context.push('/donations'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.settings_outlined,
          title: context.l10n.settingsTitle,
          subtitle: context.l10n.profileSettingsSubtitle,
          onTap: () => context.push('/settings'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: context.l10n.profileHelpTitle,
          subtitle: context.l10n.profileHelpSubtitle,
          onTap: () => _openFaq(context),
        ),
        const SizedBox(height: 24),

        // Logout Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 20),
            ),
            title: Text(
              context.l10n.profileLogout,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            key: const ValueKey('profile-logout'),
            onTap: () => _handleLogout(context, ref),
          ),
        ),
        const SizedBox(height: 32),

        // App version
        Center(
          child: Text(
            '${AppConstants.appName} v${AppConstants.appVersion}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 60,
                color: HbColors.brandPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.profileSignInPromptTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: HbColors.textSlate,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.profileSignInPromptSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.push('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  context.l10n.authLoginSubmit,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => context.push('/register'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HbColors.brandPrimary,
                  side: const BorderSide(color: HbColors.brandPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.l10n.authCreateAccount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Continue without account
            TextButton(
              onPressed: () => context.go('/'),
              child: Text(
                context.l10n.authContinueAsGuest,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche la progression du profil (N/5 champs comptés par le serveur :
  /// firstName, lastName, avatarUrl, birthDate, membershipCity).
  /// Récompense de 50 Hibons (1×/lifetime) au passage à 5/5.
  Widget _buildProfileCompletionCard(BuildContext context, user) {
    final fields = <_ProfileField>[
      _ProfileField(
          context.l10n.profileCompletionFirstName, _isFilled(user.firstName)),
      _ProfileField(
          context.l10n.profileCompletionLastName, _isFilled(user.lastName)),
      _ProfileField(
          context.l10n.profileCompletionPhoto, _isFilled(user.avatarUrl)),
      _ProfileField(
          context.l10n.profileCompletionBirthDate, user.birthDate != null),
      _ProfileField(context.l10n.profileCompletionMembershipCity,
          _isFilled(user.membershipCity)),
    ];
    final completed = fields.where((f) => f.filled).length;
    final isComplete = completed == fields.length;
    final missing = fields.where((f) => !f.filled).map((f) => f.label).toList();

    return GestureDetector(
      onTap: isComplete ? null : () => context.push('/profile/edit'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete
                ? Colors.green.withValues(alpha: 0.3)
                : const Color(0xFFFFB300).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete ? Icons.verified : Icons.monetization_on,
                  size: 20,
                  color: isComplete ? Colors.green : const Color(0xFFFFB300),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isComplete
                        ? context.l10n.profileCompletionComplete
                        : context.l10n.profileCompletionProgress(
                            completed,
                            fields.length,
                          ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textSlate,
                    ),
                  ),
                ),
                if (!isComplete)
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completed / fields.length,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete ? Colors.green : const Color(0xFFFFB300),
                ),
              ),
            ),
            if (!isComplete) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: missing
                    .map((label) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFFB300).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8B6914),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isFilled(String? value) => value != null && value.trim().isNotEmpty;

  Widget _buildStatisticsSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);
    final bookingsLabel = context.l10n.profileStatsBookings;
    final favoritesLabel = context.l10n.profileStatsFavorites;
    final reviewsLabel = context.l10n.profileStatsReviews;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: statsAsync.when(
        data: (stats) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.confirmation_number,
              value: stats.bookingsCount.toString(),
              label: bookingsLabel,
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.favorite,
              value: stats.favoritesCount.toString(),
              label: favoritesLabel,
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.star,
              value: stats.reviewsCount.toString(),
              label: reviewsLabel,
            ),
          ],
        ),
        loading: () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItemLoading(label: bookingsLabel),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItemLoading(label: favoritesLabel),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItemLoading(label: reviewsLabel),
          ],
        ),
        error: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.confirmation_number,
              value: '-',
              label: bookingsLabel,
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.favorite,
              value: '-',
              label: favoritesLabel,
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.star,
              value: '-',
              label: reviewsLabel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItemLoading({required String label}) {
    return Column(
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HbColors.brandPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: HbColors.brandPrimary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: HbColors.textSlate,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    int? badge,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: HbColors.brandPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: HbColors.brandPrimary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: HbColors.textSlate,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null && badge > 0)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  /// Pill displaying the user's HIBONs rank (e.g. "🔍 Curieux").
  ///
  /// Prefers the full `gamificationNotifierProvider` wallet; falls back to
  /// the lightweight `hibonsBalanceProvider` during cold-start (same trick
  /// as `HibonCounterWidget`). Hidden entirely if neither source has data
  /// yet — better than briefly flashing a stale "Membre"-style label.
  Widget _buildRankBadge(WidgetRef ref) {
    final viewSession = ref.watch(gamificationSessionProvider);
    final wallet =
        ref.watch(gamificationNotifierProvider(viewSession)).valueOrNull;
    final balance = ref.watch(hibonsBalanceProvider(viewSession)).valueOrNull;

    final rankLabel = wallet?.rankLabel ?? balance?.rankLabel;
    final rankIcon = wallet?.rankIcon ?? balance?.rankIcon;

    if (rankLabel == null || rankLabel.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rankIcon != null && rankIcon.isNotEmpty) ...[
            Text(rankIcon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
          ],
          Text(
            rankLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: HbColors.brandPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final ownerAccountId = ref.read(authSessionUserIdProvider);
    if (ownerAccountId == null) return;
    final ownerAuthNotifier = ref.read(authProvider.notifier);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (routeContext) => AccountBoundRouteGuard<bool>(
        ownerAccountId: ownerAccountId,
        invalidResult: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.profileLogout),
          content: Text(dialogContext.l10n.profileLogoutDialogBody),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                dialogContext.l10n.commonCancel,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(dialogContext.l10n.profileLogout),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;
    if (ref.read(authSessionUserIdProvider) != ownerAccountId ||
        !identical(ref.read(authProvider.notifier), ownerAuthNotifier)) {
      return;
    }

    await ownerAuthNotifier.logout();
    if (!context.mounted ||
        !identical(ref.read(authProvider.notifier), ownerAuthNotifier)) {
      return;
    }
    if (ref.read(authSessionUserIdProvider) == null) {
      context.go('/');
    }
  }

  Future<void> _openFaq(BuildContext context) async {
    final uri = Uri.parse('${EnvConfig.websiteUrl}/faq');
    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (ok) return;
    if (!context.mounted) return;

    final fallbackOk =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (fallbackOk) return;
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.profileHelpOpenFailed)),
    );
  }
}

class _EditableAvatar extends ConsumerStatefulWidget {
  final String? ownerAccountId;
  final String? avatarUrl;
  final String displayName;
  final double size;

  const _EditableAvatar({
    super.key,
    required this.ownerAccountId,
    required this.avatarUrl,
    required this.displayName,
    this.size = 80,
  });

  @override
  ConsumerState<_EditableAvatar> createState() => _EditableAvatarState();
}

class _EditableAvatarState extends ConsumerState<_EditableAvatar> {
  File? _selectedImage;
  bool _isUploading = false;
  CancelToken? _uploadCancelToken;
  late final AuthNotifier _ownerAuthNotifier;
  late final ProviderSubscription<String?> _sessionSubscription;
  int _sessionGeneration = 0;
  bool _sessionInvalidated = false;

  @override
  void initState() {
    super.initState();
    _ownerAuthNotifier = ref.read(authProvider.notifier);
    _sessionSubscription = ref.listenManual<String?>(
      authSessionUserIdProvider,
      (_, next) {
        if (next != widget.ownerAccountId) _invalidateSession();
      },
    );
  }

  @override
  void didUpdateWidget(covariant _EditableAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ownerAccountId != widget.ownerAccountId) {
      _invalidateSession();
    }
  }

  @override
  void dispose() {
    _sessionGeneration++;
    _uploadCancelToken?.cancel('Authentication session changed');
    _uploadCancelToken = null;
    _sessionSubscription.close();
    super.dispose();
  }

  bool _ownsSession(int generation) {
    final ownerAccountId = widget.ownerAccountId;
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
    _uploadCancelToken?.cancel('Authentication session changed');
    _uploadCancelToken = null;
    _selectedImage = null;
    _isUploading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final badgeSize = (size * 0.32).clamp(24.0, 36.0);
    final badgeIconSize = badgeSize * 0.55;

    return Stack(
      children: [
        GestureDetector(
          key: const ValueKey('profile-avatar-edit'),
          onTap: _isUploading ? null : _pickImage,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
            ),
            child: _isUploading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: HbColors.brandPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.avatarUrl!,
                              width: size,
                              height: size,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: HbColors.brandPrimary,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildDefaultAvatar(),
                            ),
                          )
                        : _buildDefaultAvatar(),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _isUploading ? null : _pickImage,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: badgeIconSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    final initials = widget.displayName.isNotEmpty
        ? widget.displayName
            .split(' ')
            .take(2)
            .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
            .join()
        : 'U';
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: widget.size * 0.35,
          fontWeight: FontWeight.bold,
          color: HbColors.brandPrimary,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final generation = _sessionGeneration;
    if (!_ownsSession(generation)) return;
    final pickImage = ref.read(profileAvatarImagePickerProvider);
    try {
      final pickedFile = await pickImage();

      if (!_ownsSession(generation) || pickedFile == null) return;
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadAvatar(generation);
    } on PlatformException catch (error) {
      if (!_ownsSession(generation)) return;
      final failure = classifyProfileImagePickerFailure(error);
      _showImagePickerError(failure);
    } catch (_) {
      if (!_ownsSession(generation)) return;
      _showImagePickerError(ProfileImagePickerFailure.pickerUnavailable);
    }
  }

  void _showImagePickerError(ProfileImagePickerFailure failure) {
    final message = switch (failure) {
      ProfileImagePickerFailure.permissionDenied =>
        context.l10n.profilePhotoPermissionDenied,
      ProfileImagePickerFailure.pickerUnavailable =>
        context.l10n.profilePhotoPickerFailed,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _uploadAvatar(int generation) async {
    final selectedImage = _selectedImage;
    if (selectedImage == null || !_ownsSession(generation)) return;

    final cancelToken = CancelToken();
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    _uploadCancelToken?.cancel('Superseded avatar upload');
    _uploadCancelToken = cancelToken;

    setState(() => _isUploading = true);

    try {
      final previousAvatarUrl = ref.read(authProvider).user?.avatarUrl;
      final profileDataSource = ref.read(profileApiDataSourceProvider);
      final updatedUser = await profileDataSource.uploadAvatar(
        selectedImage,
        cancelToken: cancelToken,
      );
      if (!_ownsSession(generation) ||
          !identical(_uploadCancelToken, cancelToken)) {
        return;
      }

      if (previousAvatarUrl != null && previousAvatarUrl.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(previousAvatarUrl);
        if (!_ownsSession(generation)) return;
      }
      if (updatedUser.avatarUrl != null && updatedUser.avatarUrl!.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(updatedUser.avatarUrl!);
        if (!_ownsSession(generation)) return;
      }

      _ownerAuthNotifier.updateUser(updatedUser);

      if (_ownsSession(generation)) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.profileAvatarUpdated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (_ownsSession(generation) &&
          !(e is DioException && CancelToken.isCancel(e))) {
        setState(() => _selectedImage = null);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              ApiResponseHandler.extractError(
                e,
                fallback: l10n.profileAvatarUploadFailed,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (identical(_uploadCancelToken, cancelToken)) {
        _uploadCancelToken = null;
      }
      if (_ownsSession(generation)) {
        setState(() => _isUploading = false);
      }
    }
  }
}
