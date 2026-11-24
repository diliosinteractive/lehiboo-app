import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

void main() {
  setUp(() {
    AppLocaleCache.setLanguageCode('fr');
  });

  group('EventMapper', () {
    test('maps the end date and time kind of mobile slots', () {
      final event = EventMapper.toEvent(
        EventDto.fromJson({
          'id': 1,
          'title': 'Timed event',
          'slug': 'timed-event',
          'slots': [
            {
              'uuid': 'period',
              'date': '2026-11-20',
              'end_date': '2026-11-29',
              'start_time': '10:00:00',
              'end_time': '17:00:00',
              'time_kind': 'exact',
            },
            {
              'uuid': 'start-only',
              'date': '2026-11-24',
              'end_date': '2026-11-24',
              'start_time': '14:00:00',
              'end_time': null,
              'time_kind': 'start_only',
            },
            {
              'uuid': 'legacy',
              'date': '2026-11-24',
              'start_time': '09:00:00',
              'end_time': '10:00:00',
            },
          ],
        }),
      );

      final slots = event.calendar!.dateSlots;
      final period = slots.singleWhere((slot) => slot.id == 'period');
      final startOnly = slots.singleWhere((slot) => slot.id == 'start-only');
      final legacy = slots.singleWhere((slot) => slot.id == 'legacy');

      expect(period.endDate, DateTime(2026, 11, 29));
      expect(period.timeKind, SlotTimeKind.exact);
      expect(startOnly.timeKind, SlotTimeKind.startOnly);
      expect(startOnly.endTime, isNull);
      expect(legacy.endDate, isNull);
      expect(legacy.timeKind, SlotTimeKind.exact);
    });

    test('maps flat mobile venue fields when location object is absent', () {
      final event = EventMapper.toEvent(
        const EventDto(
          id: 1,
          title: 'Atelier famille',
          slug: 'atelier-famille',
          venueName: 'Maison des Arts',
          venueAddress: '12 rue de Paris',
          city: 'Lille',
          postalCode: '59000',
          country: 'France',
        ),
      );

      expect(event.venue, 'Maison des Arts');
      expect(event.address, '12 rue de Paris');
      expect(event.city, 'Lille');
      expect(event.postalCode, '59000');
      expect(event.country, 'France');
    });

    test('prefers non-empty nested address fields over flat fields', () {
      final event = EventMapper.toEvent(
        const EventDto(
          id: 2,
          title: 'Concert',
          slug: 'concert',
          venueName: 'Flat venue',
          venueAddress: 'Flat address',
          city: 'Flat city',
          postalCode: '00000',
          country: 'Flat country',
          location: EventLocationDto(
            venueName: 'Nested venue',
            address: 'Nested address',
            city: 'Nested city',
            postalCode: '11111',
            country: 'Nested country',
            lat: 50.6292,
            lng: 3.0573,
          ),
        ),
      );

      expect(event.venue, 'Nested venue');
      expect(event.address, 'Nested address');
      expect(event.city, 'Nested city');
      expect(event.postalCode, '11111');
      expect(event.country, 'Flat country');
      expect(event.latitude, 50.6292);
      expect(event.longitude, 3.0573);
    });

    test('maps indicative prices from event detail response', () {
      final event = EventMapper.toEvent(
        const EventDto(
          id: 3,
          title: 'Event test',
          slug: 'event-test',
          bookingMode: 'booking',
          indicativePrices: [
            {
              'uuid': 'price-1',
              'label': 'Cloack room',
              'price': 0,
              'currency': 'EUR',
              'sort_order': 0,
            },
            {
              'uuid': 'price-2',
              'label': 'Massage parlor',
              'price': 5.5,
              'currency': 'EUR',
              'sort_order': 1,
            },
          ],
        ),
      );

      expect(event.hasDirectBooking, isTrue);
      expect(event.indicativePrices, hasLength(2));
      expect(event.indicativePrices.first.label, 'Cloack room');
      expect(event.indicativePrices.first.price, 0);
      expect(event.indicativePrices.last.label, 'Massage parlor');
      expect(event.indicativePrices.last.price, 5.5);
      expect(event.indicativePrices.last.formattedPrice, '5,5€');
    });

    test('maps related events from event detail response', () {
      final event = EventMapper.toEvent(
        EventDto.fromJson({
          'id': 4,
          'uuid': 'current-event',
          'title': 'Current event',
          'slug': 'current-event',
          'venue_name': 'Main venue',
          'city': 'Paris',
          'related_events': [
            {
              'id': 'related-event',
              'uuid': 'related-event',
              'title': 'Related activity',
              'slug': 'related-activity',
              'featured_image': 'https://example.com/related.jpg',
              'excerpt': 'Related activity excerpt.',
            },
            {
              'id': 'current-event',
              'uuid': 'current-event',
              'title': 'Current event',
              'slug': 'current-event',
            },
          ],
        }),
      );

      expect(event.relatedEvents, hasLength(1));

      final related = event.relatedEvents.single;
      expect(related.id, 'related-event');
      expect(related.slug, 'related-activity');
      expect(related.title, 'Related activity');
      expect(related.venue, 'Main venue');
      expect(related.city, 'Paris');
      expect(related.images, ['https://example.com/related.jpg']);
      expect(related.relatedEvents, isEmpty);
    });
  });
}
