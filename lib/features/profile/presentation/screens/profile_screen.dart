import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Section
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Mock Avatar
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jean Dupont',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    'jean.dupont@email.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Menu Items
          _buildMenuItem(
            context,
            icon: Icons.confirmation_number_outlined,
            title: 'Mes Réservations',
            onTap: () => context.push('/my-bookings'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'Mon Compte',
            onTap: () {}, // TODO
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () => context.push('/settings'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: 'Aide & Support',
            onTap: () {}, // TODO
          ),
          const SizedBox(height: 32),
          
          // Logout Button
          TextButton(
             onPressed: () => context.go('/login'),
             child: const Text(
               'Déconnexion',
               style: TextStyle(
                 color: Colors.red,
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFFF6B35), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}