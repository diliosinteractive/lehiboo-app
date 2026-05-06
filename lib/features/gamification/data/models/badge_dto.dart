/// DTO pour `GET /v1/mobile/badges`.
///
/// Liste des 4 paliers de rang HIBONs (Curieux, Explorateur, Aventurier,
/// Légende) avec, pour chacun, le seuil, l'icône, le bonus Petit Boo et
/// l'état de progression de l'utilisateur courant.
class BadgeDto {
  final String code;
  final String name;
  final String icon;
  final int hibonsThreshold;
  final int petitBooBonus;
  final int progress;
  final int progressPercent;
  final bool isUnlocked;

  const BadgeDto({
    required this.code,
    required this.name,
    required this.icon,
    required this.hibonsThreshold,
    required this.petitBooBonus,
    required this.progress,
    required this.progressPercent,
    required this.isUnlocked,
  });

  factory BadgeDto.fromJson(Map<String, dynamic> json) {
    return BadgeDto(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      hibonsThreshold: (json['hibons_threshold'] as num?)?.toInt() ?? 0,
      petitBooBonus: (json['petit_boo_bonus'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
    );
  }
}

class BadgesMetaDto {
  final int lifetimeEarned;
  final String currentRank;
  final String currentRankLabel;
  final int total;
  final int unlocked;
  final int locked;

  const BadgesMetaDto({
    required this.lifetimeEarned,
    required this.currentRank,
    required this.currentRankLabel,
    required this.total,
    required this.unlocked,
    required this.locked,
  });

  factory BadgesMetaDto.fromJson(Map<String, dynamic> json) {
    return BadgesMetaDto(
      lifetimeEarned: (json['lifetime_earned'] as num?)?.toInt() ?? 0,
      currentRank: json['current_rank'] as String? ?? 'curieux',
      currentRankLabel: json['current_rank_label'] as String? ?? 'Curieux',
      total: (json['total'] as num?)?.toInt() ?? 0,
      unlocked: (json['unlocked'] as num?)?.toInt() ?? 0,
      locked: (json['locked'] as num?)?.toInt() ?? 0,
    );
  }
}

class BadgesResponseDto {
  final List<BadgeDto> items;
  final BadgesMetaDto meta;

  const BadgesResponseDto({required this.items, required this.meta});
}
