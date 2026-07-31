import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/data/repositories/api_booking_repository_impl.dart';

void main() {
  group('ApiBookingRepositoryImpl.getBookingById', () {
    test('loads and maps the dedicated UUID detail endpoint', () async {
      late String requestedPath;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestedPath = options.path;
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'id': 42,
                    'uuid': 'booking-uuid',
                    'status': 'confirmed',
                    'grandTotal': 5.5,
                  },
                },
              ),
            );
          },
        ),
      );
      final repository = ApiBookingRepositoryImpl(BookingApiDataSource(dio));

      final booking = await repository.getBookingById('booking-uuid');

      expect(requestedPath, '/me/bookings/booking-uuid');
      expect(booking, isNotNull);
      expect(booking!.id, 'booking-uuid');
      expect(booking.numericId, 42);
      expect(booking.totalPrice, 5.5);
    });

    test('returns null only for an HTTP 404', () async {
      final repository = ApiBookingRepositoryImpl(
        BookingApiDataSource(_dioRejecting(404)),
      );

      expect(await repository.getBookingById('missing-uuid'), isNull);
    });

    test('propagates non-404 failures', () async {
      final repository = ApiBookingRepositoryImpl(
        BookingApiDataSource(_dioRejecting(503)),
      );

      await expectLater(
        repository.getBookingById('booking-uuid'),
        throwsA(isA<DioException>()),
      );
    });
  });
}

Dio _dioRejecting(int statusCode) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: statusCode,
          data: {'message': 'Request failed'},
        );
        handler.reject(
          DioException.badResponse(
            statusCode: statusCode,
            requestOptions: options,
            response: response,
          ),
        );
      },
    ),
  );
  return dio;
}
