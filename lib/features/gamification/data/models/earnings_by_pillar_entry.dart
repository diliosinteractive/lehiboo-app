/// Entrée du breakdown des gains par pilier (donut profil).
class EarningsByPillarEntry {
  final String pillar;
  final String label;
  final String color; // hex string, ex: "#8B5CF6"
  final int amount;

  const EarningsByPillarEntry({
    required this.pillar,
    required this.label,
    required this.color,
    required this.amount,
  });
}
