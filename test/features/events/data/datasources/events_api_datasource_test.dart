import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/datasources/events_api_datasource.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';

void main() {
  test(
    'lightweight pins preserve discovery pricing without inferring free from zero',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: <String, dynamic>{
                  'success': true,
                  'data': <String, dynamic>{
                    'pins': <Map<String, dynamic>>[
                      <String, dynamic>{
                        'id': 1,
                        'title': 'Free discovery',
                        'lat': 50.45,
                        'lng': 3.95,
                        'price_min': 25,
                        'price_max': 50,
                        'discovery_pricing_type': 'free',
                      },
                      <String, dynamic>{
                        'id': 2,
                        'title': 'Paid discovery',
                        'lat': 50.46,
                        'lng': 3.96,
                        'price_min': 0,
                        'price_max': 0,
                        'booking_mode': 'discovery',
                        'discovery_pricing_type': 'paid',
                        'is_free': true,
                      },
                      <String, dynamic>{
                        'id': 3,
                        'title': 'Unclassified zero-price pin',
                        'lat': 50.47,
                        'lng': 3.97,
                        'price_min': 0,
                        'price_max': 0,
                      },
                    ],
                  },
                },
              ),
            );
          },
        ),
      );

      final response =
          await EventsApiDataSource(dio).getEvents(lightweight: true);
      final events = response.events.map(EventMapper.toEvent).toList();

      expect(events[0].hasDirectBooking, isFalse);
      expect(events[0].discoveryPricingType, 'free');
      expect(events[0].isAuthoritativelyFree, isTrue);

      expect(events[1].hasDirectBooking, isFalse);
      expect(events[1].discoveryPricingType, 'paid');
      expect(events[1].isAuthoritativelyFree, isFalse);

      expect(events[2].hasDirectBooking, isTrue);
      expect(events[2].isAuthoritativelyFree, isFalse);
    },
  );
}
