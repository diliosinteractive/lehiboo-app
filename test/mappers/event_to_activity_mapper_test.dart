import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';

void main() {
  group('EventMapper discovery tariff', () {
    test('preserves pricing.display for a paid discovery event', () {
      final dto = EventDto.fromJson({
        'id': 10,
        'uuid': 'paid-discovery',
        'title': 'Paid discovery',
        'slug': 'paid-discovery',
        'booking_mode': 'discovery',
        'discovery_pricing_type': 'paid',
        'price_from': 22,
        'pricing': {
          'is_free': false,
          'min': 22,
          'max': 0,
          'currency': 'EUR',
          'display': '22,00€',
        },
        'indicative_prices': [],
      });

      final event = EventMapper.toEvent(dto);

      expect(event.hasDirectBooking, isFalse);
      expect(event.discoveryPricingType, 'paid');
      expect(event.priceDetails, '22,00€');
      expect(event.minPrice, 22);
      expect(event.indicativePrices, isEmpty);
      expect(event.discoveryPaidPriceLabel, '22,00€');
      expect(event.formattedPrice, '22,00€');
    });

    test('falls back to price_from when nested pricing is absent', () {
      final dto = EventDto.fromJson({
        'id': 11,
        'uuid': 'price-from-discovery',
        'title': 'Price-from discovery',
        'slug': 'price-from-discovery',
        'booking_mode': 'discovery',
        'discovery_pricing_type': 'paid',
        'price_from': 18.5,
      });

      final event = EventMapper.toEvent(dto);

      expect(event.price, 18.5);
      expect(event.minPrice, 18.5);
    });

    test('uses price_from for a paid discovery zero-price payload', () {
      final dto = EventDto.fromJson({
        'id': 12,
        'uuid': 'zero-nested-discovery',
        'title': 'Zero nested discovery',
        'slug': 'zero-nested-discovery',
        'booking_mode': 'discovery',
        'discovery_pricing_type': 'paid',
        'price_from': 24,
        'pricing': {
          'is_free': false,
          'min': 0,
          'max': 0,
          'currency': 'EUR',
          'display': '24,00€',
        },
      });

      final event = EventMapper.toEvent(dto);

      expect(event.price, 24);
      expect(event.minPrice, 24);
      expect(event.priceDetails, '24,00€');
      expect(event.formattedPrice, '24,00€');
    });

    test('does not apply the discovery fallback to booking events', () {
      final dto = EventDto.fromJson({
        'id': 13,
        'uuid': 'free-booking-inconsistent-price-from',
        'title': 'Free booking',
        'slug': 'free-booking',
        'booking_mode': 'booking',
        'price_from': 24,
        'pricing': {
          'is_free': true,
          'min': 0,
          'max': 0,
          'currency': 'EUR',
          'display': 'Gratuit',
        },
      });

      final event = EventMapper.toEvent(dto);

      expect(event.price, 0);
      expect(event.minPrice, 0);
      expect(event.isAuthoritativelyFree, isTrue);
    });

    test('keeps price_from fallback scoped away from booking events', () {
      final dto = EventDto.fromJson({
        'id': 14,
        'uuid': 'booking-without-nested-pricing',
        'title': 'Booking without nested pricing',
        'slug': 'booking-without-nested-pricing',
        'booking_mode': 'booking',
        'price_from': 24,
      });

      final event = EventMapper.toEvent(dto);

      expect(event.hasDirectBooking, isTrue);
      expect(event.price, isNull);
      expect(event.minPrice, isNull);
      expect(event.priceDetails, isNull);
    });
  });

  group('EventToActivityMapper discovery pricing', () {
    test('preserves the API value through DTO, Event, and Activity', () {
      final dto = EventDto.fromJson({
        'id': 1,
        'uuid': 'api-free-discovery',
        'title': 'API free discovery',
        'slug': 'api-free-discovery',
        'discovery_pricing_type': 'free',
        'pricing': {
          'is_free': false,
          'min': 25,
          'max': 25,
        },
      });

      final event = EventMapper.toEvent(dto);
      final activity = EventToActivityMapper.toActivity(event);

      expect(event.discoveryPricingType, 'free');
      expect(event.isAuthoritativelyFree, isTrue);
      expect(activity.discoveryPricingType, DiscoveryPricingType.free);
      expect(activity.isFree, isTrue);
      expect(activity.isAuthoritativelyFree, isTrue);
    });

    test('maps the API free value to the typed Activity value', () {
      final event = Event.minimal(
        id: 'free-discovery',
        slug: 'free-discovery',
        title: 'Free discovery event',
      ).copyWith(
        hasDirectBooking: false,
        isDiscovery: true,
        discoveryPricingType: 'free',
        priceType: PriceType.paid,
        minPrice: 25,
        maxPrice: 50,
      );

      final activity = EventToActivityMapper.toActivity(event);

      expect(event.isAuthoritativelyFree, isTrue);
      expect(event.formattedPrice, 'Gratuit');
      expect(activity.discoveryPricingType, DiscoveryPricingType.free);
      expect(activity.isFreeDiscovery, isTrue);
      expect(activity.isAuthoritativelyFree, isTrue);
    });

    test('maps paid without falling back to the generic free flag', () {
      final baseEvent = Event.minimal(
        id: 'discovery',
        slug: 'discovery',
        title: 'Discovery event',
      ).copyWith(
        hasDirectBooking: false,
        isDiscovery: true,
      );

      final paidEvent = baseEvent.copyWith(
        discoveryPricingType: 'paid',
        priceType: PriceType.free,
      );
      final paidActivity = EventToActivityMapper.toActivity(paidEvent);
      final unknownActivity = EventToActivityMapper.toActivity(
        baseEvent.copyWith(discoveryPricingType: 'donation'),
      );

      expect(paidEvent.isAuthoritativelyFree, isFalse);
      expect(paidEvent.formattedPrice, isNot('Gratuit'));
      expect(paidActivity.discoveryPricingType, DiscoveryPricingType.paid);
      expect(paidActivity.isFree, isFalse);
      expect(paidActivity.isFreeDiscovery, isFalse);
      expect(paidActivity.isAuthoritativelyFree, isFalse);
      expect(unknownActivity.discoveryPricingType, isNull);
      expect(unknownActivity.isFreeDiscovery, isFalse);
    });

    test('keeps the existing booking free classification', () {
      final event = Event.minimal(
        id: 'free-booking',
        slug: 'free-booking',
        title: 'Free booking event',
      ).copyWith(
        hasDirectBooking: true,
        priceType: PriceType.free,
        discoveryPricingType: null,
      );

      final activity = EventToActivityMapper.toActivity(event);

      expect(event.isAuthoritativelyFree, isTrue);
      expect(activity.reservationMode, ReservationMode.lehibooFree);
      expect(activity.isFree, isTrue);
      expect(activity.isAuthoritativelyFree, isTrue);
    });

    test('does not infer a price for an unclassified discovery event', () {
      final event = Event.minimal(
        id: 'unclassified-discovery',
        slug: 'unclassified-discovery',
        title: 'Unclassified discovery event',
      ).copyWith(
        hasDirectBooking: false,
        isDiscovery: true,
        minPrice: 22,
        maxPrice: 0,
      );

      expect(event.isAuthoritativelyFree, isFalse);
      expect(event.formattedPrice, 'Prix non défini');
    });
  });
}
