/// Réponse légère de GET /mobile/hibons/balance — utilisée pour le badge header
/// au cold start et au pull-to-refresh.
class HibonsBalance {
  final int balance;
  final int lifetimeEarned;
  final String rank;
  final String rankLabel;
  final String rankIcon;

  const HibonsBalance({
    required this.balance,
    required this.lifetimeEarned,
    required this.rank,
    required this.rankLabel,
    required this.rankIcon,
  });
}
