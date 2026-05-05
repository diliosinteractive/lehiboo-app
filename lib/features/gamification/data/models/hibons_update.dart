/// Représentation domain de l'enveloppe `hibons_update` injectée à la racine
/// des réponses des mutations Hibons-modifying par le backend (Plan 05).
class HibonsUpdate {
  final int delta;
  final int newBalance;
  final int newLifetime;
  final int lifetimeDelta;
  final bool rankChanged;
  final String? newRank;
  final String? newRankLabel;
  final String? animationLabel;
  final String? pillar;

  const HibonsUpdate({
    required this.delta,
    required this.newBalance,
    required this.newLifetime,
    required this.lifetimeDelta,
    required this.rankChanged,
    this.newRank,
    this.newRankLabel,
    this.animationLabel,
    this.pillar,
  });
}
