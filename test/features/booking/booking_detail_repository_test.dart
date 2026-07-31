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

    test('keeps attendee metadata without fabricating ticket entities',
        () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'id': 42,
                    'uuid': 'booking-uuid',
                    'status': 'confirmed',
                    'items': [
                      {
                        'quantity': 1,
                        'ticketTypeName': 'VIP',
                        'attendee_details': [
                          {
                            'first_name': 'Ada',
                            'last_name': 'Lovelace',
                            'email': 'ada@example.test',
                          },
                        ],
                      },
                    ],
                  },
                },
              ),
            );
          },
        ),
      );
      final repository = ApiBookingRepositoryImpl(BookingApiDataSource(dio));

      final booking = await repository.getBookingById('booking-uuid');

      expect(booking, isNotNull);
      expect(booking!.attendees, hasLength(1));
      expect(booking.attendees!.single.firstName, 'Ada');
      expect(booking.attendees!.single.ticketTypeName, 'VIP');
      expect(booking.tickets, isNull);
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

  test('loads booking tickets from the authoritative booking UUID endpoint',
      () async {
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
                'data': [
                  {
                    'id': 'ticket-id-from-endpoint',
                    'uuid': 'ticket-uuid',
                    'booking_id': 42,
                    'slot_id': 7,
                    'qr_code': 'signed-api-qr',
                    'status': 'active',
                    'attendee_first_name': 'Ada',
                    'attendee_last_name': 'Lovelace',
                    'attendee_email': 'ada@example.test',
                    'price': 5.5,
                    'created_at': '2026-07-31T10:00:00Z',
                  },
                ],
              },
            ),
          );
        },
      ),
    );
    final repository = ApiBookingRepositoryImpl(BookingApiDataSource(dio));

    final tickets = await repository.getTicketsByBooking('booking-uuid');

    expect(requestedPath, '/bookings/booking-uuid/tickets');
    expect(tickets, hasLength(1));
    expect(tickets.single.id, 'ticket-uuid');
    expect(tickets.single.bookingId, 'booking-uuid');
    expect(tickets.single.slotId, '7');
    expect(tickets.single.qrCodeData, 'signed-api-qr');
    expect(tickets.single.status, 'active');
    expect(tickets.single.attendeeFirstName, 'Ada');
    expect(tickets.single.attendeeLastName, 'Lovelace');
    expect(tickets.single.attendeeEmail, 'ada@example.test');
    expect(tickets.single.price, 5.5);
    expect(tickets.single.createdAt, DateTime(2026, 7, 31, 10));
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
