import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

void main() {
  group('Ticket availability parsing', () {
    test('parses the mobile API availability flags without stock data', () {
      final ticket = Ticket.fromJson(const {
        'uuid': 'sold-out-ticket',
        'name': 'Standard',
        'price': '5.5',
        'is_available': false,
        'is_sold_out': true,
      });

      expect(ticket.price, 5.5);
      expect(ticket.isAvailable, isFalse);
      expect(ticket.isSoldOut, isTrue);
      expect(ticket.remainingPlaces, isNull);
      expect(ticket.isBookable, isFalse);
    });

    for (final alias in const [
      'places',
      'remaining_places',
      'remainingPlaces',
      'quantity_remaining',
      'quantityRemaining',
      'quota_remaining',
      'quotaRemaining',
      'available_quantity',
      'availableQuantity',
    ]) {
      test('parses remaining stock from $alias', () {
        final ticket = Ticket.fromJson({
          'uuid': 'ticket-$alias',
          'name': 'Standard',
          'price': 5.5,
          'max_per_order': 10,
          alias: '2',
        });

        expect(ticket.remainingPlaces, 2);
        expect(ticket.effectiveMaxPerBooking, 2);
        expect(ticket.isBookable, isTrue);
      });
    }

    test('parses camel-case and string availability flags', () {
      final ticket = Ticket.fromJson(const {
        'uuid': 'unavailable-ticket',
        'name': 'Standard',
        'price': 5.5,
        'isAvailable': '0',
        'isSoldOut': 'false',
      });

      expect(ticket.isAvailable, isFalse);
      expect(ticket.isSoldOut, isFalse);
      expect(ticket.isBookable, isFalse);
    });

    test('derives sold-out state when remaining stock is zero', () {
      final ticket = Ticket.fromJson(const {
        'uuid': 'no-stock-ticket',
        'name': 'Standard',
        'price': 5.5,
        'remaining_places': 0,
      });

      expect(ticket.isAvailable, isFalse);
      expect(ticket.isSoldOut, isTrue);
      expect(ticket.effectiveMaxPerBooking, 0);
      expect(ticket.isBookable, isFalse);
    });
  });

  group('Ticket booking limits', () {
    test('caps the maximum by both the order limit and remaining stock', () {
      const ticket = Ticket(
        id: 'limited-ticket',
        name: 'Standard',
        price: 5.5,
        minPerBooking: 2,
        maxPerBooking: 8,
        remainingPlaces: 5,
      );

      expect(ticket.effectiveMinPerBooking, 2);
      expect(ticket.effectiveMaxPerBooking, 5);
      expect(ticket.hasValidBookingLimits, isTrue);
      expect(ticket.isBookable, isTrue);
    });

    test('rejects contradictory minimum and effective maximum limits', () {
      const ticket = Ticket(
        id: 'contradictory-ticket',
        name: 'Standard',
        price: 5.5,
        minPerBooking: 5,
        maxPerBooking: 1,
        isAvailable: true,
        isSoldOut: false,
      );

      expect(ticket.effectiveMinPerBooking, 5);
      expect(ticket.effectiveMaxPerBooking, 1);
      expect(ticket.hasValidBookingLimits, isFalse);
      expect(ticket.isBookable, isFalse);
    });

    test('rejects a minimum above the remaining-stock cap', () {
      const ticket = Ticket(
        id: 'insufficient-stock-ticket',
        name: 'Standard',
        price: 5.5,
        minPerBooking: 3,
        maxPerBooking: 10,
        remainingPlaces: 2,
      );

      expect(ticket.effectiveMinPerBooking, 3);
      expect(ticket.effectiveMaxPerBooking, 2);
      expect(ticket.hasValidBookingLimits, isFalse);
      expect(ticket.isBookable, isFalse);
    });
  });
}
