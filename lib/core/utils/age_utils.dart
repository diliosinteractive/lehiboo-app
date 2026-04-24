/// Compute age in whole years from a "YYYY-MM-DD" birth date string.
/// Returns null if [birthDateStr] is null or unparseable.
int? computeAge(String? birthDateStr) {
  if (birthDateStr == null) return null;
  final birthDate = DateTime.tryParse(birthDateStr);
  if (birthDate == null) return null;
  final today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

/// Convert an integer age to an approximate "YYYY-01-01" birth date string.
/// Used when the user edits only the age number field.
String ageToBirthDate(int age) {
  final now = DateTime.now();
  final approx = DateTime(now.year - age, 1, 1);
  return approx.toIso8601String().substring(0, 10);
}
