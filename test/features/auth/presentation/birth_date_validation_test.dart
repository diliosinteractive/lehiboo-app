import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/utils/birth_date_validation.dart';

void main() {
  group('registration birth date validation', () {
    final today = DateTime(2026, 8, 17);

    test('requires users to be at least 18 years old', () {
      expect(minimumRegistrationAgeYears, 18);
      expect(latestAllowedBirthDate(today), DateTime(2008, 8, 17));
    });

    test('accepts a user on their eighteenth birthday', () {
      expect(meetsMinimumRegistrationAge(DateTime(2008, 8, 17), today), isTrue);
    });

    test('rejects a user who turns eighteen the next day', () {
      expect(
          meetsMinimumRegistrationAge(DateTime(2008, 8, 18), today), isFalse);
    });

    test('uses February 28 as the cutoff on a leap day', () {
      expect(
        latestAllowedBirthDate(DateTime(2024, 2, 29)),
        DateTime(2006, 2, 28),
      );
    });
  });
}
