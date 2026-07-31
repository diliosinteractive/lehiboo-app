import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';

void main() {
  group('BookingApiDataSource.getBookingTickets', () {
    test('returns an empty list only for a valid empty ticket payload',
        () async {
      final dataSource = BookingApiDataSource(
        _dioResolving(<String, dynamic>{'data': <dynamic>[]}),
      );

      expect(
        await dataSource.getBookingTickets(bookingUuid: 'booking-1'),
        isEmpty,
      );
    });

    test('propagates ApiFormatException for a malformed ticket payload',
        () async {
      final dataSource = BookingApiDataSource(
        _dioResolving(<String, dynamic>{
          'data': <String, dynamic>{'tickets': <dynamic>[]},
        }),
      );

      await expectLater(
        dataSource.getBookingTickets(bookingUuid: 'booking-1'),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });
}

Dio _dioResolving(dynamic data) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: data,
          ),
        );
      },
    ),
  );
  return dio;
}
