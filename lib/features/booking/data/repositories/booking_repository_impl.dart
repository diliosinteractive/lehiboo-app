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
    required int quantity,
    required BuyerInfo buyer,
    required List<ParticipantInfo> participants,
  }) async {
    final response = await _dio.post(
      '/lehiboo/v1/bookings',
      data: {
        'activity_id': activityId,
        'slot_id': slotId,
        'quantity': quantity,
        'buyer': {
          'first_name': buyer.firstName,
          'last_name': buyer.lastName,
          'email': buyer.email,
          'phone': buyer.phone,
        },
        'participants': participants.map((p) => {
          'first_name': p.firstName,
          'last_name': p.lastName,
        }).toList(),
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
  Future<void> cancelBooking(String bookingId) async {
    await _dio.post('/lehiboo/v1/bookings/$bookingId/cancel');
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
