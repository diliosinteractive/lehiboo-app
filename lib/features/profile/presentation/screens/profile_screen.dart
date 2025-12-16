import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

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
                color: Colors.black.withOpacity(0.05),
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
                  color: const Color(0xFFFF601F).withOpacity(0.1),
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
                              color: Color(0xFFFF601F),
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
                        color: Color(0xFF2D3748),
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
                        color: _getRoleColor(user.role).withOpacity(0.1),
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
        const SizedBox(height: 24),

        // Statistics Section (if user has capabilities)
        if (user.capabilities != null) ...[
          _buildStatisticsSection(user),
          const SizedBox(height: 24),
        ],

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
          icon: Icons.person_outline,
          title: 'Mon Compte',
          subtitle: 'Modifier vos informations',
          onTap: () {}, // TODO: Implement edit profile
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
                color: Colors.red.withOpacity(0.1),
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
                color: const Color(0xFFFF601F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 60,
                color: Color(0xFFFF601F),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connectez-vous',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
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
                  backgroundColor: const Color(0xFFFF601F),
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
                  foregroundColor: const Color(0xFFFF601F),
                  side: const BorderSide(color: Color(0xFFFF601F)),
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

  Widget _buildStatisticsSection(user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.confirmation_number,
            value: '0',
            label: 'Réservations',
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildStatItem(
            icon: Icons.favorite,
            value: '0',
            label: 'Favoris',
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildStatItem(
            icon: Icons.star,
            value: '0',
            label: 'Avis',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFF601F), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
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
            color: const Color(0xFFFF601F).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFFF601F), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
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
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
          color: Color(0xFFFF601F),
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
        return const Color(0xFFFF601F);
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
