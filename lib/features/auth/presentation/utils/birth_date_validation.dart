import '../../../../domain/entities/user.dart';

const int customerMinimumRegistrationAgeYears = 16;
const int vendorMinimumRegistrationAgeYears = 18;

/// Same rule as the API: customers may register from 16, every other role
/// from 18.
int minimumRegistrationAgeFor(UserRole role) => role == UserRole.subscriber
    ? customerMinimumRegistrationAgeYears
    : vendorMinimumRegistrationAgeYears;

/// The API checks the age against today in Europe/Paris. The UTC date is never
/// later than that, so the device never offers a date the API would refuse,
/// whatever its own time zone (Réunion or New Caledonia are ahead of Paris).
DateTime latestAllowedBirthDate({
  int minimumAgeYears = vendorMinimumRegistrationAgeYears,
  DateTime? now,
}) {
  final today = now ?? DateTime.now().toUtc();
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
