import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/hibons_action_entry.dart';
import '../providers/gamification_provider.dart';

/// Catalogue dynamique des actions Hibons (Plan 05).
/// Liste fournie par GET /v1/mobile/hibons/actions-catalog avec montants live
/// et compteurs de cap par utilisateur. La liste statique des 15 actions v1
/// a été remplacée par cet écran.
class HowToEarnHibonsScreen extends ConsumerWidget {
  const HowToEarnHibonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(actionsCatalogProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Comment gagner des Hibons'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'Impossible de charger le catalogue',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(actionsCatalogProvider),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text('Aucune action disponible pour le moment'),
            );
          }

          // Grouper par pilier en conservant l'ordre du backend
          final byPillar = <String, List<HibonsActionEntry>>{};
          for (final e in entries) {
            byPillar.putIfAbsent(e.pillar, () => []).add(e);
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(actionsCatalogProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final entry in byPillar.entries) ...[
                  _PillarHeader(
                    label: entry.value.first.pillarLabel,
                    color: _parseHexColor(entry.value.first.pillarColor),
                  ),
                  const SizedBox(height: 8),
                  ...entry.value.map((a) => _ActionTile(action: a)),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

Color _parseHexColor(String hex) {
  final cleaned = hex.replaceAll('#', '');
  final value = int.tryParse(cleaned, radix: 16);
  if (value == null) return const Color(0xFF6B7280);
  if (cleaned.length == 6) return Color(0xFF000000 | value);
  return Color(value);
}

IconData _resolveIcon(String slug) {
  // Mapping des slugs Lucide → Material Icons côté Flutter.
  switch (slug) {
    case 'heart':
      return Icons.favorite;
    case 'ticket':
      return Icons.confirmation_number;
    case 'user-plus':
      return Icons.person_add;
    case 'login':
      return Icons.login;
    case 'compass':
    case 'category':
      return Icons.category;
    case 'star':
      return Icons.star;
    case 'help-circle':
      return Icons.help_outline;
    case 'mail':
      return Icons.email_outlined;
    case 'share':
      return Icons.share;
    case 'bell':
      return Icons.notifications_active;
    case 'check-circle':
      return Icons.check_circle_outline;
    case 'clipboard-check':
      return Icons.assignment_turned_in;
    case 'gift':
      return Icons.card_giftcard;
    case 'route':
      return Icons.route;
    case 'alarm':
      return Icons.alarm;
    case 'sparkles':
      return Icons.auto_awesome;
    case 'casino':
      return Icons.casino;
    default:
      return Icons.bolt;
  }
}

class _PillarHeader extends StatelessWidget {
  final String label;
  final Color color;

  const _PillarHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final HibonsActionEntry action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final pillarColor = _parseHexColor(action.pillarColor);
    final reachable = action.reachable;
    final progress = _formatProgress(action);

    return Opacity(
      opacity: reachable ? 1.0 : 0.55,
      child: Container(
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
                color: pillarColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _resolveIcon(action.icon),
                color: pillarColor,
                size: 22,
              ),
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
                    progress != null
                        ? '${action.capText} • $progress'
                        : action.capText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (!reachable)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Atteint',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
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
                      '+${action.amount} H',
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
      ),
    );
  }

  /// Compteurs de cap selon le scope (lifetime / weekly / daily).
  String? _formatProgress(HibonsActionEntry e) {
    if (e.completedThisWeek != null && e.remainingThisWeek != null) {
      return '${e.completedThisWeek}/${e.completedThisWeek! + e.remainingThisWeek!} cette semaine';
    }
    if (e.completedToday != null && e.remainingToday != null) {
      return '${e.completedToday}/${e.completedToday! + e.remainingToday!} aujourd\'hui';
    }
    if (e.completedLifetime != null && e.remainingLifetime != null) {
      return e.remainingLifetime! > 0
          ? '${e.remainingLifetime} restant'
          : 'Effectué';
    }
    if (e.completedLifetime != null) {
      return e.completedLifetime! > 0 ? 'Effectué' : null;
    }
    return null;
  }
}
