/// Entité domaine d'un badge de rang HIBONs.
///
/// 4 paliers fixes : Curieux (0), Explorateur (400), Aventurier (1000),
/// Légende (5000). `progress` est capé à `hibonsThreshold` côté API.
class HibonBadge {
  final String code;
  final String name;
  final String icon;
  final int hibonsThreshold;
  final int petitBooBonus;
  final int progress;
  final int progressPercent;
  final bool isUnlocked;

  const HibonBadge({
    required this.code,
    required this.name,
    required this.icon,
    required this.hibonsThreshold,
    required this.petitBooBonus,
    required this.progress,
    required this.progressPercent,
    required this.isUnlocked,
  });
}

class HibonBadgesMeta {
  final int lifetimeEarned;
  final String currentRank;
  final String currentRankLabel;
  final int total;
  final int unlocked;
  final int locked;

  const HibonBadgesMeta({
    required this.lifetimeEarned,
    required this.currentRank,
    required this.currentRankLabel,
    required this.total,
    required this.unlocked,
    required this.locked,
  });
}

class HibonBadgesResult {
  final List<HibonBadge> items;
  final HibonBadgesMeta meta;

  const HibonBadgesResult({required this.items, required this.meta});

  static const empty = HibonBadgesResult(
    items: [],
    meta: HibonBadgesMeta(
      lifetimeEarned: 0,
      currentRank: 'curieux',
      currentRankLabel: 'Curieux',
      total: 0,
      unlocked: 0,
      locked: 0,
    ),
  );
}
