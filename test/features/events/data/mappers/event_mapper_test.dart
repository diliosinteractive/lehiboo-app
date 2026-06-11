import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';

void main() {
  group('EventMapper', () {
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
              'price': 5,
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
      expect(event.indicativePrices.last.formattedPrice, '5.00 €');
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
