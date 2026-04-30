import 'package:dio/dio.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/data/models/booking_dto.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/data/mappers/booking_mapper.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required List<TicketSelection> ticketSelections,
    required BuyerInfo buyer,
    bool acceptTerms = false,
    bool acceptNewsletter = false,
    String? promoCode,
  }) async {
    final response = await _dio.post(
      '/lehiboo/v1/bookings',
      data: {
        'activity_id': activityId,
        'slot_id': slotId,
        'items': ticketSelections.map((ts) => {
          'ticket_type_id': ts.ticketTypeId,
          'quantity': ts.quantity,
          'attendees': ts.attendees.map((a) => {
            'first_name': a.firstName ?? '',
            'last_name': a.lastName ?? '',
            if (a.email != null) 'email': a.email,
            if (a.phone != null) 'phone': a.phone,
            if (a.birthDate != null) 'birth_date': a.birthDate,
            if (a.age != null) 'age': a.age,
          }).toList(),
        }).toList(),
        'customer_email': buyer.email,
        'customer_first_name': buyer.firstName,
        'customer_last_name': buyer.lastName,
        if (buyer.phone != null) 'customer_phone': buyer.phone,
        if (buyer.birthDate != null) 'customer_birth_date': buyer.birthDate,
        if (buyer.town != null) 'customer_town': buyer.town,
        if (promoCode != null) 'promo_code': promoCode,
        'accept_terms': acceptTerms,
        'accept_newsletter': acceptNewsletter,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return BookingDto.fromJson(data).toDomain();
  }

  @override
  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  }) async {
    final response = await _dio.post(
      '/lehiboo/v1/bookings/$bookingId/confirm',
      data: {
        'payment_intent_id': paymentIntentId,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return BookingDto.fromJson(data).toDomain();
  }

  @override
  Future<Booking> cancelBooking(String bookingId, {String? reason}) async {
    final response = await _dio.post(
      '/lehiboo/v1/bookings/$bookingId/cancel',
      data: {
        if (reason != null && reason.isNotEmpty) 'reason': reason,
        'notify_customer': true,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return BookingDto.fromJson(
        (data['data'] as Map<String, dynamic>?) ?? data,
      ).toDomain();
    }
    throw Exception('Unexpected cancel response');
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    final response = await _dio.get('/lehiboo/v1/me/bookings');
    final list = response.data as List;
    return list
        .map((e) => BookingDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<List<Ticket>> getMyTickets() async {
    final response = await _dio.get('/lehiboo/v1/me/tickets');
    final list = response.data as List;
    return list
        .map((e) => TicketDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<List<Ticket>> getTicketsByBooking(String bookingId) async {
    final response = await _dio.get('/lehiboo/v1/bookings/$bookingId/tickets');
    final list = response.data as List;
    return list
        .map((e) => TicketDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }
}
