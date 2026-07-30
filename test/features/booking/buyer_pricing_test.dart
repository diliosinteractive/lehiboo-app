import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/booking/data/models/booking_api_dto.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

void main() {
  group('Ticket buyer pricing', () {
    test('uses the all-inclusive price when present', () {
      const ticket = Ticket(
        id: 'ticket-1',
        name: 'Standard',
        price: 50,
        allInclusivePrice: 55,
        platformFee: 5,
      );

      expect(ticket.buyerPrice, 55);
    });

    test('falls back to the organizer price when absent', () {
      final ticket = Ticket.fromJson({
        'uuid': 'ticket-1',
        'name': 'Standard',
        'price': 50,
      });

      expect(ticket.allInclusivePrice, isNull);
      expect(ticket.platformFee, isNull);
      expect(ticket.buyerPrice, 50);
    });

    test('parses buyer pricing from the event detail payload', () {
      final ticket = Ticket.fromJson({
        'uuid': 'ticket-1',
        'name': 'Standard',
        'price': 50,
        'all_inclusive_price': 55,
        'buyer_pricing': {
          'organizer_price': 50,
          'platform_fee': 5,
          'all_inclusive_price': 55,
          'currency': 'EUR',
        },
      });

      expect(ticket.price, 50);
      expect(ticket.allInclusivePrice, 55);
      expect(ticket.platformFee, 5);
      expect(ticket.buyerPrice, 55);
    });
  });

  group('OrderCartItem buyer totals', () {
    test('computes organizer, fee, and buyer line totals', () {
      final item = _cartItem(
        const Ticket(
          id: 'ticket-1',
          name: 'Standard',
          price: 19.99,
          allInclusivePrice: 21.66,
        ),
        quantity: 3,
      );

      expect(item.organizerLineTotal, closeTo(59.97, 0.000001));
      expect(item.feeLineTotal, closeTo(5.01, 0.000001));
      expect(item.lineTotal, closeTo(64.98, 0.000001));
    });

    test('keeps existing totals when buyer pricing is absent', () {
      final item = _cartItem(
        const Ticket(id: 'ticket-1', name: 'Standard', price: 19.99),
        quantity: 3,
      );

      expect(item.organizerLineTotal, closeTo(59.97, 0.000001));
      expect(item.feeLineTotal, closeTo(0, 0.000001));
      expect(item.lineTotal, closeTo(59.97, 0.000001));
    });

    test('sums prices rounded per ticket before multiplying quantities', () {
      final items = [
        _cartItem(
          const Ticket(
            id: 'ticket-1',
            name: 'Standard',
            price: 10.01,
            allInclusivePrice: 11.01,
          ),
          quantity: 3,
        ),
        _cartItem(
          const Ticket(
            id: 'ticket-2',
            name: 'Reduced',
            price: 7.03,
            allInclusivePrice: 7.73,
          ),
          quantity: 2,
        ),
      ];

      final buyerTotal =
          items.fold<double>(0, (sum, item) => sum + item.lineTotal);
      final organizerTotal = items.fold<double>(
        0,
        (sum, item) => sum + item.organizerLineTotal,
      );
      final feeTotal =
          items.fold<double>(0, (sum, item) => sum + item.feeLineTotal);

      expect(buyerTotal, closeTo(48.49, 0.000001));
      expect(organizerTotal, closeTo(44.09, 0.000001));
      expect(feeTotal, closeTo(4.40, 0.000001));
      expect(organizerTotal + feeTotal, closeTo(buyerTotal, 0.000001));
    });
  });

  group('Buyer pricing DTO parsing', () {
    test('parses event list all-inclusive fields', () {
      final dto = EventDto.fromJson({
        'id': 1,
        'title': 'Concert',
        'slug': 'concert',
        'price_from': 50,
        'all_inclusive_price_from': 55,
        'booking_mode': 'booking',
        'pricing': {
          'min': 50,
          'max': 100,
          'display': '50,00€',
          'all_inclusive_min': 55,
          'all_inclusive_max': 110,
          'all_inclusive_display': '55,00€',
        },
      });
      final event = EventMapper.toEvent(dto);
      final activity = EventToActivityMapper.toActivity(event);

      expect(dto.priceFrom, 50);
      expect(dto.allInclusivePriceFrom, 55);
      expect(dto.pricing?.allInclusiveMin, 55);
      expect(dto.pricing?.allInclusiveMax, 110);
      expect(dto.pricing?.allInclusiveDisplay, '55,00€');
      expect(event.buyerPriceFrom, 55);
      expect(event.buyerMaxPrice, 110);
      expect(activity.priceMin, 55);
      expect(activity.priceMax, 110);
    });

    test('accepts the current production event payload without new fields', () {
      final dto = EventDto.fromJson({
        'id': 1,
        'title': 'Concert',
        'slug': 'concert',
        'price_from': 50,
        'booking_mode': 'booking',
        'pricing': {
          'min': 50,
          'max': 100,
          'display': '50,00€',
        },
      });
      final event = EventMapper.toEvent(dto);

      expect(dto.allInclusivePriceFrom, isNull);
      expect(dto.pricing?.allInclusiveMin, isNull);
      expect(event.buyerPriceFrom, 50);
      expect(event.buyerMaxPrice, 100);
    });

    test('parses booking totals with buyer fees', () {
      final dto = CreateBookingResponseDto.fromJson({
        'uuid': 'booking-1',
        'status': 'confirmed',
        'total_amount': 100,
        'platform_fee_amount': 10,
        'buyer_total': 110,
      });

      expect(dto.totalAmount, 100);
      expect(dto.platformFeeAmount, 10);
      expect(dto.buyerTotal, 110);
      expect(dto.paidTotal, 110);
    });

    test('accepts the current production booking payload', () {
      final dto = CreateBookingResponseDto.fromJson({
        'uuid': 'booking-1',
        'status': 'confirmed',
        'total_amount': 100,
      });

      expect(dto.platformFeeAmount, isNull);
      expect(dto.buyerTotal, isNull);
      expect(dto.paidTotal, 100);
    });

    test('parses buyer totals from a booking detail payload', () {
      final dto = BookingListItemDto.fromJson({
        'id': 42,
        'uuid': 'booking-1',
        'status': 'confirmed',
        'total_amount': 100,
        'platform_fee_amount': 10,
        'buyer_total': 110,
      });

      expect(dto.totalAmount, 100);
      expect(dto.platformFeeAmount, 10);
      expect(dto.buyerTotal, 110);
    });
  });
}

OrderCartItem _cartItem(Ticket ticket, {required int quantity}) {
  return OrderCartItem(
    event: Event.minimal(
      id: 'event-1',
      slug: 'event-1',
      title: 'Concert',
    ),
    slotId: 'slot-1',
    ticket: ticket,
    quantity: quantity,
  );
}
