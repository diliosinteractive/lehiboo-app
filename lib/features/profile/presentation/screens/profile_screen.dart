import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../messages/presentation/providers/unread_count_provider.dart';
import '../../../reviews/presentation/providers/pending_count_provider.dart';
import '../providers/profile_provider.dart';

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
        title: const Text('Profil'),
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
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                ),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: avatarUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: HbColors.brandPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => _buildDefaultAvatar(displayName),
                        ),
                      )
                    : _buildDefaultAvatar(displayName),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.isNotEmpty ? displayName : 'Utilisateur',
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
                          Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
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
                    // Badge role
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRoleLabel(user.role),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getRoleColor(user.role),
                        ),
                      ),
                    ),
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
        _buildStatisticsSection(ref),
        const SizedBox(height: 24),

        // Menu Items
        _buildMenuItem(
          context,
          icon: Icons.confirmation_number_outlined,
          title: 'Mes Réservations',
          subtitle: 'Voir vos billets et réservations',
          onTap: () => context.push('/my-bookings'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.favorite_outline,
          title: 'Mes Favoris',
          subtitle: 'Activités sauvegardées',
          onTap: () => context.push('/favorites'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.groups_outlined,
          title: 'Organisateurs suivis',
          subtitle: 'Gérer les organisateurs que vous suivez',
          onTap: () => context.push('/me/followed-organizers'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.workspaces_outline,
          title: 'Mes adhésions',
          subtitle: 'Adhésions, invitations, événements privés',
          onTap: () => context.push('/me/memberships'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.mail_outline,
          title: 'Mes Messages',
          subtitle: 'Conversations avec les organisateurs',
          badge: ref.watch(unreadCountProvider),
          onTap: () => context.push('/messages'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.route,
          title: 'Mes Sorties',
          subtitle: 'Plans et itinéraires',
          onTap: () => context.push('/trip-plans'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.notifications_active_outlined,
          title: 'Mes Rappels',
          subtitle: 'Rappels d\'activités à venir',
          onTap: () => context.push('/my-reminders'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.question_answer_outlined,
          title: 'Mes Questions',
          subtitle: 'Vos questions sur les événements',
          onTap: () => context.push('/my-questions'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.rate_review_outlined,
          title: 'Mes Avis',
          subtitle: 'Vos avis et réponses des organisateurs',
          badge: ref.watch(pendingReviewCountProvider).valueOrNull,
          onTap: () => context.push('/my-reviews'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.person_outline,
          title: 'Mon Compte',
          subtitle: 'Modifier vos informations',
          onTap: () => context.push('/account'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.notifications_none_rounded, // Slightly more modern icon if possible
          title: 'Mes Alertes & Recherches',
          subtitle: 'Gérer vos recherches enregistrées',
          onTap: () => context.push('/notifications'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.settings_outlined,
          title: 'Paramètres',
          subtitle: 'Langue, thème, confidentialité',
          onTap: () => context.push('/settings'),
        ),
        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: 'Aide & Support',
          subtitle: 'FAQ et contact',
          onTap: () {}, // TODO: Implement help
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
            title: const Text(
              'Déconnexion',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            onTap: () => _handleLogout(context, ref),
          ),
        ),
        const SizedBox(height: 32),

        // App version
        Center(
          child: Text(
            'Le Hiboo v1.0.0',
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
            const Text(
              'Connectez-vous',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: HbColors.textSlate,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Accédez à vos réservations, favoris et bien plus encore',
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
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
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
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(
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
                'Continuer sans compte',
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
      _ProfileField('Prénom', _isFilled(user.firstName)),
      _ProfileField('Nom', _isFilled(user.lastName)),
      _ProfileField('Photo', _isFilled(user.avatarUrl)),
      _ProfileField('Date de naissance', user.birthDate != null),
      _ProfileField('Ville d\'adhésion', _isFilled(user.membershipCity)),
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
                        ? 'Profil complet'
                        : 'Profil $completed/${fields.length} — gagne 50 Hibons',
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
                            color: const Color(0xFFFFB300).withValues(alpha: 0.1),
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

  Widget _buildStatisticsSection(WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

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
              label: 'Réservations',
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.favorite,
              value: stats.favoritesCount.toString(),
              label: 'Favoris',
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.star,
              value: stats.reviewsCount.toString(),
              label: 'Avis',
            ),
          ],
        ),
        loading: () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItemLoading(label: 'Réservations'),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItemLoading(label: 'Favoris'),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItemLoading(label: 'Avis'),
          ],
        ),
        error: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.confirmation_number,
              value: '-',
              label: 'Réservations',
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.favorite,
              value: '-',
              label: 'Favoris',
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            _buildStatItem(
              icon: Icons.star,
              value: '-',
              label: 'Avis',
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

  Widget _buildDefaultAvatar(String displayName) {
    final initials = displayName.isNotEmpty
        ? displayName.split(' ').take(2).map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join()
        : 'U';
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: HbColors.brandPrimary,
        ),
      ),
    );
  }

  Color _getRoleColor(role) {
    switch (role.toString()) {
      case 'UserRole.partner':
        return Colors.purple;
      case 'UserRole.admin':
        return Colors.red;
      default:
        return HbColors.brandPrimary;
    }
  }

  String _getRoleLabel(role) {
    switch (role.toString()) {
      case 'UserRole.partner':
        return 'Partenaire';
      case 'UserRole.admin':
        return 'Administrateur';
      default:
        return 'Membre';
    }
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go('/');
      }
    }
  }
}
