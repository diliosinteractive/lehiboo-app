import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/realtime/models/events/booking/booking_confirmed.dart';
import 'package:lehiboo/core/realtime/models/events/booking/booking_created.dart';
import 'package:lehiboo/core/realtime/models/events/booking/booking_refunded.dart';

void main() {
  group('booking realtime total_amount parsing', () {
    test('BookingCreatedData preserves a numeric decimal', () {
      final booking = BookingCreatedData.fromJson({
        'booking_id': 1,
        'booking_uuid': 'booking-created-number',
        'event_id': 10,
        'total_amount': 5.5,
      });

      expect(booking.totalAmount, 5.5);
    });

    test('BookingCreatedData parses a decimal string without truncating it',
        () {
      final booking = BookingCreatedData.fromJson({
        'booking_id': 2,
        'booking_uuid': 'booking-created-string',
        'event_id': 20,
        'total_amount': '14.30',
      });

      expect(booking.totalAmount, 14.3);
    });

    test('BookingConfirmedData preserves a numeric decimal', () {
      final booking = BookingConfirmedData.fromJson({
        'booking_id': 3,
        'booking_uuid': 'booking-confirmed-number',
        'event_id': 30,
        'total_amount': 14.3,
      });

      expect(booking.totalAmount, 14.3);
    });

    test(
      'BookingConfirmedData parses a decimal string without truncating it',
      () {
        final booking = BookingConfirmedData.fromJson({
          'booking_id': 4,
          'booking_uuid': 'booking-confirmed-string',
          'event_id': 40,
          'total_amount': '5.50',
        });

        expect(booking.totalAmount, 5.5);
      },
    );

    test('whole-number payloads are accepted as doubles', () {
      final booking = BookingCreatedData.fromJson({
        'booking_id': 5,
        'booking_uuid': 'booking-created-whole-number',
        'event_id': 50,
        'total_amount': 5,
      });

      expect(booking.totalAmount, 5.0);
    });

    test('refund_amount remains integer cents', () {
      final refund = BookingRefundedData.fromJson({
        'booking_id': 6,
        'booking_uuid': 'booking-refunded',
        'refund_amount': 550,
      });

      expect(refund.refundAmount, 550);
      expect(refund.refundAmount, isA<int>());
    });
  });
}
