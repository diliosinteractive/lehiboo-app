import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/data/mappers/activity_mapper.dart';
import 'package:lehiboo/data/models/activity_dto.dart';
import 'package:lehiboo/domain/entities/activity.dart';

void main() {
  group('ActivityMapper', () {
    test('should map valid ActivityDto to Activity domain entity', () {
      final dto = ActivityDto(
        id: 1,
        title: 'Yoga Session',
        slug: 'yoga-session',
        description: 'Relaxing yoga',
        price: PriceDto(min: 10.0, max: 20.0, currency: 'EUR'),
        indoorOutdoor: 'indoor',
        reservationMode: 'lehiboo_paid',
      );

      final entity = dto.toDomain();

      expect(entity.id, '1');
      expect(entity.title, 'Yoga Session');
      expect(entity.priceMin, 10.0);
      expect(entity.indoorOutdoor, IndoorOutdoor.indoor);
      expect(entity.reservationMode, ReservationMode.lehibooPaid);
    });

    test('should handle null fields gracefully', () {
      final dto = ActivityDto(
        id: 2,
        title: 'Free Event',
        slug: 'free-event',
      );

      final entity = dto.toDomain();

      expect(entity.id, '2');
      expect(entity.description, ''); // Default empty string
      expect(entity.priceMin, null);
      expect(entity.indoorOutdoor, null);
    });
  });
}
