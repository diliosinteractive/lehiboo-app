const int minimumRegistrationAgeYears = 15;

DateTime latestAllowedBirthDate([DateTime? now]) {
  final today = now ?? DateTime.now();
  final latest = DateTime(
    today.year - minimumRegistrationAgeYears,
    today.month,
    today.day,
  );
  if (latest.month != today.month) {
    return DateTime(
      today.year - minimumRegistrationAgeYears,
      today.month + 1,
      0,
    );
  }
  return latest;
}

bool meetsMinimumRegistrationAge(DateTime birthDate, [DateTime? now]) {
  final normalizedBirthDate = DateTime(
    birthDate.year,
    birthDate.month,
    birthDate.day,
  );
  final latestAllowedDate = latestAllowedBirthDate(now);
  return !normalizedBirthDate.isAfter(latestAllowedDate);
}

String formatBirthDateForApi(DateTime birthDate) {
  return '${birthDate.year}-'
      '${birthDate.month.toString().padLeft(2, '0')}-'
      '${birthDate.day.toString().padLeft(2, '0')}';
}
