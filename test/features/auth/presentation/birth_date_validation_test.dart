import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/utils/birth_date_validation.dart';

void main() {
  group('registration birth date validation', () {
    final today = DateTime(2026, 8, 17);

    test('uses 16 for customers and 18 for vendors', () {
      expect(customerMinimumRegistrationAgeYears, 16);
      expect(vendorMinimumRegistrationAgeYears, 18);
      expect(
        latestAllowedBirthDate(
          minimumAgeYears: customerMinimumRegistrationAgeYears,
          now: today,
        ),
        DateTime(2010, 8, 17),
      );
      expect(
        latestAllowedBirthDate(
          minimumAgeYears: vendorMinimumRegistrationAgeYears,
          now: today,
        ),
        DateTime(2008, 8, 17),
      );
    });

    test('accepts a customer on their sixteenth birthday', () {
      expect(
        meetsMinimumRegistrationAge(
          DateTime(2010, 8, 17),
          minimumAgeYears: customerMinimumRegistrationAgeYears,
          now: today,
        ),
        isTrue,
      );
    });

    test('rejects a customer who turns sixteen the next day', () {
      expect(
        meetsMinimumRegistrationAge(
          DateTime(2010, 8, 18),
          minimumAgeYears: customerMinimumRegistrationAgeYears,
          now: today,
        ),
        isFalse,
      );
    });

    test('accepts a vendor on their eighteenth birthday', () {
      expect(
        meetsMinimumRegistrationAge(
          DateTime(2008, 8, 17),
          minimumAgeYears: vendorMinimumRegistrationAgeYears,
          now: today,
        ),
        isTrue,
      );
    });

    test('rejects a vendor who turns eighteen the next day', () {
      expect(
        meetsMinimumRegistrationAge(
          DateTime(2008, 8, 18),
          minimumAgeYears: vendorMinimumRegistrationAgeYears,
          now: today,
        ),
        isFalse,
      );
    });

    test('uses February 28 as the cutoff on a leap day', () {
      expect(
        latestAllowedBirthDate(
          minimumAgeYears: vendorMinimumRegistrationAgeYears,
          now: DateTime(2024, 2, 29),
        ),
        DateTime(2006, 2, 28),
      );
    });
  });
}
