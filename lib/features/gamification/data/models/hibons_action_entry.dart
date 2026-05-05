/// Entrée du catalogue d'actions retourné par GET /mobile/hibons/actions-catalog.
/// Les compteurs de cap dépendent du scope : seuls les champs pertinents pour
/// l'action sont renseignés (cf. spec Plan 05 §6).
class HibonsActionEntry {
  final String action;
  final String title;
  final String description;
  final int amount;
  final String pillar;
  final String pillarLabel;
  final String pillarColor;
  final String icon;
  final String capText;
  final bool reachable;
  final int? completedThisWeek;
  final int? remainingThisWeek;
  final int? completedToday;
  final int? remainingToday;
  final int? completedLifetime;
  final int? remainingLifetime;

  const HibonsActionEntry({
    required this.action,
    required this.title,
    required this.description,
    required this.amount,
    required this.pillar,
    required this.pillarLabel,
    required this.pillarColor,
    required this.icon,
    required this.capText,
    required this.reachable,
    this.completedThisWeek,
    this.remainingThisWeek,
    this.completedToday,
    this.remainingToday,
    this.completedLifetime,
    this.remainingLifetime,
  });
}
