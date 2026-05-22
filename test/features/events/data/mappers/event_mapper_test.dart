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
  });
}
