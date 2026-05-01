import 'package:flutter/material.dart';

/// Liste statique des 15 actions Hibons v1 (cf. spec 02-mobile-update-spec).
/// À remplacer par un endpoint catalog dans le plan 05.
class HowToEarnHibonsScreen extends StatelessWidget {
  const HowToEarnHibonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Comment gagner des Hibons'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final pillar in _Pillar.values) ...[
            _PillarHeader(pillar: pillar),
            const SizedBox(height: 8),
            ..._actions
                .where((a) => a.pillar == pillar)
                .map((a) => _ActionTile(action: a)),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

enum _Pillar {
  onboarding('Onboarding', Color(0xFF3B82F6), Icons.rocket_launch),
  engagement('Engagement', Color(0xFFF59E0B), Icons.local_fire_department),
  discovery('Découverte', Color(0xFF8B5CF6), Icons.explore),
  participation('Participation', Color(0xFF10B981), Icons.event_available),
  community('Communauté', Color(0xFFEC4899), Icons.groups);

  final String label;
  final Color color;
  final IconData icon;
  const _Pillar(this.label, this.color, this.icon);
}

class _Action {
  final String title;
  final String reward;
  final String cap;
  final IconData icon;
  final _Pillar pillar;

  const _Action({
    required this.title,
    required this.reward,
    required this.cap,
    required this.icon,
    required this.pillar,
  });
}

const _actions = <_Action>[
  // Onboarding
  _Action(
    title: 'Créer son compte',
    reward: '100 H',
    cap: '1× à vie',
    icon: Icons.person_add,
    pillar: _Pillar.onboarding,
  ),
  _Action(
    title: 'Compléter son profil (5/5)',
    reward: '50 H',
    cap: '1× à vie',
    icon: Icons.assignment_turned_in,
    pillar: _Pillar.onboarding,
  ),
  _Action(
    title: 'Activer les notifications',
    reward: '30 H',
    cap: '1× à vie',
    icon: Icons.notifications_active,
    pillar: _Pillar.onboarding,
  ),
  // Engagement
  _Action(
    title: 'Connexion + 3 min sur l\'app',
    reward: '10 H',
    cap: '1×/jour',
    icon: Icons.login,
    pillar: _Pillar.engagement,
  ),
  _Action(
    title: 'Roue de la fortune',
    reward: '0–100 H',
    cap: '1×/jour',
    icon: Icons.casino,
    pillar: _Pillar.engagement,
  ),
  _Action(
    title: 'Récompense quotidienne (streak)',
    reward: '10 → 50 H',
    cap: '1×/jour',
    icon: Icons.local_fire_department,
    pillar: _Pillar.engagement,
  ),
  // Découverte
  _Action(
    title: 'Explorer une nouvelle catégorie',
    reward: '20 H',
    cap: '1× par catégorie',
    icon: Icons.category,
    pillar: _Pillar.discovery,
  ),
  _Action(
    title: 'Ajouter un événement aux favoris',
    reward: '5 H',
    cap: '3/sem',
    icon: Icons.favorite,
    pillar: _Pillar.discovery,
  ),
  _Action(
    title: 'Suivre un organisateur',
    reward: '5 H',
    cap: '3/sem',
    icon: Icons.person_add_alt_1,
    pillar: _Pillar.discovery,
  ),
  // Participation
  _Action(
    title: 'Créer un planning de sortie',
    reward: '20 H',
    cap: '3/sem',
    icon: Icons.route,
    pillar: _Pillar.participation,
  ),
  _Action(
    title: 'Activer un rappel sur un créneau',
    reward: '5 H',
    cap: '5/sem',
    icon: Icons.alarm,
    pillar: _Pillar.participation,
  ),
  _Action(
    title: 'Réserver un événement',
    reward: '50 H',
    cap: 'À chaque réservation',
    icon: Icons.confirmation_number,
    pillar: _Pillar.participation,
  ),
  // Communauté
  _Action(
    title: 'Partager un événement',
    reward: '10 H',
    cap: '2/sem',
    icon: Icons.share,
    pillar: _Pillar.community,
  ),
  _Action(
    title: 'Laisser un avis sur un événement',
    reward: '40 H',
    cap: '1× par événement',
    icon: Icons.star,
    pillar: _Pillar.community,
  ),
  _Action(
    title: 'Poser une question sur un événement',
    reward: '40 H',
    cap: '1× par événement',
    icon: Icons.help_outline,
    pillar: _Pillar.community,
  ),
  _Action(
    title: 'Contacter un organisateur',
    reward: '10 H',
    cap: '1× par événement',
    icon: Icons.email,
    pillar: _Pillar.community,
  ),
];

class _PillarHeader extends StatelessWidget {
  final _Pillar pillar;
  const _PillarHeader({required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: pillar.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(pillar.icon, color: pillar.color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            pillar.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: pillar.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final _Action action;
  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: action.pillar.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(action.icon, color: action.pillar.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  action.cap,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 14,
                  color: Color(0xFFFFB300),
                ),
                const SizedBox(width: 4),
                Text(
                  action.reward,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B6914),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
