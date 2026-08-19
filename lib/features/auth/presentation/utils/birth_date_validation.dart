const int customerMinimumRegistrationAgeYears = 16;
const int vendorMinimumRegistrationAgeYears = 18;

DateTime latestAllowedBirthDate({
  int minimumAgeYears = vendorMinimumRegistrationAgeYears,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final latest = DateTime(
    today.year - minimumAgeYears,
    today.month,
    today.day,
  );
  if (latest.month != today.month) {
    return DateTime(
      today.year - minimumAgeYears,
      today.month + 1,
      0,
    );
  }
  return latest;
}

bool meetsMinimumRegistrationAge(
  DateTime birthDate, {
  int minimumAgeYears = vendorMinimumRegistrationAgeYears,
  DateTime? now,
}) {
  final normalizedBirthDate = DateTime(
    birthDate.year,
    birthDate.month,
    birthDate.day,
  );
  final latestAllowedDate = latestAllowedBirthDate(
    minimumAgeYears: minimumAgeYears,
    now: now,
  );
  return !normalizedBirthDate.isAfter(latestAllowedDate);
}

String formatBirthDateForApi(DateTime birthDate) {
  return '${birthDate.year}-'
      '${birthDate.month.toString().padLeft(2, '0')}-'
      '${birthDate.day.toString().padLeft(2, '0')}';
}
