/// Résultat d'un appel POST /me/favorites/{uuid}/toggle.
///
/// `hibonsAwarded` et `newHibonsBalance` sont renseignés uniquement quand le
/// backend crédite une récompense (ajout d'un event jamais récompensé, quota
/// hebdomadaire non atteint). Sinon ils valent `null` — pas `0` — pour
/// distinguer "pas de reward" de "reward égale à zéro".
class ToggleFavoriteResult {
  final bool isFavorite;
  final int? hibonsAwarded;
  final int? newHibonsBalance;

  const ToggleFavoriteResult({
    required this.isFavorite,
    this.hibonsAwarded,
    this.newHibonsBalance,
  });

  factory ToggleFavoriteResult.fromJson(Map<String, dynamic> json) {
    return ToggleFavoriteResult(
      isFavorite: json['is_favorite'] == true,
      hibonsAwarded: _parseNullableInt(json['hibons_awarded']),
      newHibonsBalance: _parseNullableInt(json['new_hibons_balance']),
    );
  }

  bool get hasReward => (hibonsAwarded ?? 0) > 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
