import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/hibon_badge.dart';
import '../providers/gamification_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(hibonBadgesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Mes Badges',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: badgesAsync.when(
        data: (result) => _buildContent(context, ref, result),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, e),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    HibonBadgesResult result,
  ) {
    return RefreshIndicator(
      color: HbColors.brandPrimary,
      onRefresh: () => ref.refresh(hibonBadgesProvider.future),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _BadgesHeader(meta: result.meta),
          const SizedBox(height: 20),
          _ProgressSummary(meta: result.meta),
          const SizedBox(height: 24),
          ...result.items.map((badge) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _BadgeCard(
                  badge: badge,
                  onTap: () => _showDetail(context, badge),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Impossible de charger tes badges',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HbColors.textSlate,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(hibonBadgesProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, HibonBadge badge) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: _BadgeDetailDialog(badge: badge),
      ),
    );
  }
}

class _BadgesHeader extends StatelessWidget {
  const _BadgesHeader({required this.meta});

  final HibonBadgesMeta meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A65), HbColors.brandPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HbColors.brandPrimary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _rankIcon(meta.currentRank),
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu es',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta.currentRankLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${meta.lifetimeEarned} HIBONs cumulés',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _rankIcon(String code) {
    switch (code) {
      case 'curieux':
        return '🔍';
      case 'explorateur':
        return '🧭';
      case 'aventurier':
        return '🗺️';
      case 'legende':
        return '👑';
      default:
        return '🦉';
    }
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.meta});

  final HibonBadgesMeta meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HbColors.borderLight),
      ),
      child: Row(
        children: [
          _SummaryItem(
            value: '${meta.unlocked}',
            label: 'Débloqués',
            color: HbColors.success,
            icon: Icons.check_circle_rounded,
          ),
          const _Divider(),
          _SummaryItem(
            value: '${meta.locked}',
            label: 'À débloquer',
            color: HbColors.grey500,
            icon: Icons.lock_outline_rounded,
          ),
          const _Divider(),
          _SummaryItem(
            value: '${meta.total}',
            label: 'Total',
            color: HbColors.brandPrimary,
            icon: Icons.military_tech_rounded,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: HbColors.borderLight,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: HbColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.onTap});

  final HibonBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.isUnlocked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: unlocked
                  ? HbColors.brandPrimary.withOpacity(0.4)
                  : HbColors.borderLight,
              width: unlocked ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: unlocked
                    ? HbColors.brandPrimary.withOpacity(0.10)
                    : Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _BadgeIcon(badge: badge),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                badge.name,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: unlocked
                                      ? HbColors.textSlate
                                      : HbColors.grey500,
                                ),
                              ),
                            ),
                            _StatusPill(unlocked: unlocked),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          badge.petitBooBonus > 0
                              ? '+${badge.petitBooBonus} message${badge.petitBooBonus > 1 ? 's' : ''} Petit Boo / jour'
                              : 'Rang de départ',
                          style: const TextStyle(
                            fontSize: 13,
                            color: HbColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: badge.progressPercent / 100,
                  minHeight: 8,
                  backgroundColor: HbColors.surfaceLight,
                  color: unlocked ? HbColors.success : HbColors.brandPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    unlocked
                        ? '${badge.hibonsThreshold} / ${badge.hibonsThreshold} HIBONs'
                        : '${badge.progress} / ${badge.hibonsThreshold} HIBONs',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textMuted,
                    ),
                  ),
                  Text(
                    '${badge.progressPercent}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          unlocked ? HbColors.success : HbColors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({required this.badge});

  final HibonBadge badge;

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.isUnlocked;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: unlocked
            ? const LinearGradient(
                colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey.shade100, Colors.grey.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        shape: BoxShape.circle,
        border: Border.all(
          color: unlocked
              ? HbColors.brandPrimary.withOpacity(0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: unlocked ? 1 : 0.45,
            child: Text(
              badge.icon,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          if (!unlocked)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.unlocked});

  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? HbColors.success : HbColors.grey500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        unlocked ? 'Débloqué' : 'À débloquer',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _BadgeDetailDialog extends StatelessWidget {
  const _BadgeDetailDialog({required this.badge});

  final HibonBadge badge;

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.isUnlocked;
    final remaining = (badge.hibonsThreshold - badge.progress)
        .clamp(0, badge.hibonsThreshold);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? const LinearGradient(
                      colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade100, Colors.grey.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Opacity(
              opacity: unlocked ? 1 : 0.5,
              child: Text(
                badge.icon,
                style: const TextStyle(fontSize: 44),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            badge.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
            ),
          ),
          const SizedBox(height: 6),
          _StatusPill(unlocked: unlocked),
          const SizedBox(height: 20),
          if (badge.petitBooBonus > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: HbColors.brandPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${badge.petitBooBonus} message${badge.petitBooBonus > 1 ? 's' : ''} Petit Boo / jour',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HbColors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progression',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HbColors.textMuted,
                ),
              ),
              Text(
                unlocked
                    ? '${badge.hibonsThreshold} HIBONs'
                    : '${badge.progress} / ${badge.hibonsThreshold}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: badge.progressPercent / 100,
              minHeight: 10,
              backgroundColor: HbColors.surfaceLight,
              color: unlocked ? HbColors.success : HbColors.brandPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (!unlocked)
            Text(
              'Encore $remaining HIBONs pour débloquer ce badge',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.textMuted,
              ),
            )
          else
            const Text(
              'Bravo, tu as débloqué ce badge !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: HbColors.success,
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Top !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
