const int minimumBookingAgeYears = 18;

bool meetsMinimumBookingAge(DateTime? birthDate, {DateTime? now}) {
  if (birthDate == null) return false;

  final today = now ?? DateTime.now();
  var cutoff = DateTime(
    today.year - minimumBookingAgeYears,
    today.month,
    today.day,
  );

  if (cutoff.month != today.month) {
    cutoff = DateTime(
      today.year - minimumBookingAgeYears,
      today.month + 1,
      0,
    );
  }

  final normalizedBirthDate = DateTime(
    birthDate.year,
    birthDate.month,
    birthDate.day,
  );

  return !normalizedBirthDate.isAfter(cutoff);
}
