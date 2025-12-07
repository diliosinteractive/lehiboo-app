import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/booking_api_dto.dart';

final bookingApiDataSourceProvider = Provider<BookingApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return BookingApiDataSource(dio);
});

class BookingApiDataSource {
  final Dio _dio;

  BookingApiDataSource(this._dio);

  Future<CreateBookingResponseDto> createBooking({
    required int eventId,
    required List<BookingTicketRequestDto> tickets,
    required BuyerInfoDto buyerInfo,
    String? couponCode,
    String? notes,
  }) async {
    final response = await _dio.post(
      '/bookings',
      data: {
        'event_id': eventId,
        'tickets': tickets.map((t) => {
          'ticket_type_id': t.ticketTypeId,
          'quantity': t.quantity,
          if (t.attendees != null)
            'attendees': t.attendees!.map((a) => {
              'first_name': a.firstName,
              'last_name': a.lastName,
              if (a.age != null) 'age': a.age,
            }).toList(),
        }).toList(),
        'buyer_info': {
          'first_name': buyerInfo.firstName,
          'last_name': buyerInfo.lastName,
          'email': buyerInfo.email,
          if (buyerInfo.phone != null) 'phone': buyerInfo.phone,
        },
        if (couponCode != null) 'coupon_code': couponCode,
        if (notes != null) 'notes': notes,
      },
    );

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return CreateBookingResponseDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to create booking');
  }

  Future<void> confirmBooking({
    required int bookingId,
    required String paymentIntentId,
  }) async {
    final response = await _dio.post(
      '/bookings/$bookingId/confirm',
      data: {
        'payment_intent_id': paymentIntentId,
      },
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to confirm booking');
    }
  }

  Future<BookingsListResponseDto> getMyBookings({
    int page = 1,
    int perPage = 20,
    String? status, // all, upcoming, cancelled
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null) queryParams['status'] = status;

    final response = await _dio.get('/me/bookings', queryParameters: queryParams);

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return BookingsListResponseDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load bookings');
  }

  Future<BookingListItemDto> getBookingById(int bookingId) async {
    final response = await _dio.get('/me/bookings/$bookingId');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return BookingListItemDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load booking');
  }

  Future<void> cancelBooking({
    required int bookingId,
    String? reason,
  }) async {
    final response = await _dio.post(
      '/me/bookings/$bookingId/cancel',
      data: {
        if (reason != null) 'reason': reason,
      },
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to cancel booking');
    }
  }

  Future<TicketsListResponseDto> getMyTickets({
    String? status, // all, valid, used, cancelled
    bool? upcoming,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (upcoming != null) queryParams['upcoming'] = upcoming;

    final response = await _dio.get('/me/tickets', queryParameters: queryParams);

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return TicketsListResponseDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load tickets');
  }

  Future<TicketDetailDto> getTicketById(int ticketId) async {
    final response = await _dio.get('/me/tickets/$ticketId');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return TicketDetailDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load ticket');
  }

  Future<String> downloadTicketPdf(int ticketId) async {
    final response = await _dio.get('/me/tickets/$ticketId/download');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return data['data']['pdf_url'] as String;
    }
    throw Exception(data['data']?['message'] ?? 'Failed to download ticket');
  }
}
