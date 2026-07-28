import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/favorites/data/datasources/favorites_api_datasource.dart';
import 'package:lehiboo/features/favorites/data/repositories/favorites_repository_impl.dart';

class _FakeFavoritesApiDataSource extends FavoritesApiDataSource {
  _FakeFavoritesApiDataSource(this.items) : super(Dio());

  final List<FavoriteEventDto> items;

  @override
  Future<List<FavoriteEventDto>> getFavorites({String? listId}) async => items;
}

void main() {
  test(
    'propagates discovery pricing aliases while preserving the booking default',
    () async {
      final dataSource = _FakeFavoritesApiDataSource([
        FavoriteEventDto.fromJson({
          'id': 1,
          'uuid': 'snake-discovery',
          'title': 'Snake discovery',
          'slug': 'snake-discovery',
          'date': '2026-08-01',
          'booking_mode': 'discovery',
          'discovery_pricing_type': 'free',
        }),
        FavoriteEventDto.fromJson({
          'id': 2,
          'uuid': 'camel-discovery',
          'title': 'Camel discovery',
          'slug': 'camel-discovery',
          'date': '2026-08-02',
          'bookingMode': 'discovery',
          'discoveryPricingType': 'paid',
          'price': {
            'is_free': true,
            'min': 0,
            'max': 0,
          },
        }),
        FavoriteEventDto.fromJson({
          'id': 3,
          'uuid': 'pricing-only-discovery',
          'title': 'Pricing-only discovery',
          'slug': 'pricing-only-discovery',
          'date': '2026-08-03',
          'discovery_pricing_type': 'free',
        }),
        FavoriteEventDto.fromJson({
          'id': 4,
          'uuid': 'legacy-favorite',
          'title': 'Legacy favorite',
          'slug': 'legacy-favorite',
          'date': '2026-08-04',
        }),
      ]);
      final repository = FavoritesRepositoryImpl(dataSource);

      final events = await repository.getFavorites();

      expect(events[0].hasDirectBooking, isFalse);
      expect(events[0].discoveryPricingType, 'free');
      expect(events[0].isAuthoritativelyFree, isTrue);
      expect(events[1].hasDirectBooking, isFalse);
      expect(events[1].discoveryPricingType, 'paid');
      expect(events[1].isAuthoritativelyFree, isFalse);
      expect(events[2].hasDirectBooking, isFalse);
      expect(events[2].discoveryPricingType, 'free');
      expect(events[2].isAuthoritativelyFree, isTrue);
      expect(events[3].hasDirectBooking, isTrue);
      expect(events[3].discoveryPricingType, isNull);
    },
  );
}
