enum HibonsRank {
  curieux('curieux'),
  explorateur('explorateur'),
  aventurier('aventurier'),
  legende('legende');

  final String value;
  const HibonsRank(this.value);

  static HibonsRank fromString(String? value) =>
      HibonsRank.values.firstWhere(
        (r) => r.value == value,
        orElse: () => HibonsRank.curieux,
      );
}
