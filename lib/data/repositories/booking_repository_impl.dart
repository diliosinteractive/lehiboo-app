import 'package:dio/dio.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/domain/repositories/booking_repository.dart';
import 'package:lehiboo/data/models/booking_dto.dart';
import 'package:lehiboo/data/mappers/booking_mapper.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Booking> createBooking(Booking bookingDraft) async {
    final response = await _dio.post(
      '/lehiboo/v1/bookings',
      data: {
        'slot_id': bookingDraft.slotId,
        'quantity': bookingDraft.quantity,
        // Add other fields as needed by backend
      },
    );
    final data = response.data as Map<String, dynamic>;
    return BookingDto.fromJson(data).toDomain();
  }

  @override
  Future<Booking> confirmBooking(String bookingId, {String? paymentIntentId}) async {
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
    final response = await _dio.get('/lehiboo/v1/my-bookings');
    final list = response.data as List;
    return list
        .map((e) => BookingDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<List<Ticket>> getMyTickets() async {
    final response = await _dio.get('/lehiboo/v1/my-tickets');
    final list = response.data as List;
    return list
        .map((e) => TicketDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }
}
