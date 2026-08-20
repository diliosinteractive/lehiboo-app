import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/booking/domain/utils/booking_age_eligibility.dart';

void main() {
  group('booking age eligibility', () {
    final today = DateTime(2026, 8, 20);

    test('requires bookers to be at least 18 years old', () {
      expect(minimumBookingAgeYears, 18);
      expect(
        meetsMinimumBookingAge(DateTime(2008, 8, 20), now: today),
        isTrue,
      );
    });

    test('rejects a user who turns 18 the next day', () {
      expect(
        meetsMinimumBookingAge(DateTime(2008, 8, 21), now: today),
        isFalse,
      );
    });

    test('rejects a user without a birth date', () {
      expect(meetsMinimumBookingAge(null, now: today), isFalse);
    });

    test('uses February 28 as the cutoff on a leap day', () {
      final leapDay = DateTime(2024, 2, 29);

      expect(
        meetsMinimumBookingAge(DateTime(2006, 2, 28), now: leapDay),
        isTrue,
      );
      expect(
        meetsMinimumBookingAge(DateTime(2006, 3, 1), now: leapDay),
        isFalse,
      );
    });
  });
}
