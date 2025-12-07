import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/booking.dart';
import '../../domain/models/booking_flow_state.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_api_datasource.dart';
import '../models/booking_api_dto.dart';

final apiBookingRepositoryImplProvider = Provider<BookingRepository>((ref) {
  final apiDataSource = ref.read(bookingApiDataSourceProvider);
  return ApiBookingRepositoryImpl(apiDataSource);
});

class ApiBookingRepositoryImpl implements BookingRepository {
  final BookingApiDataSource _apiDataSource;

  ApiBookingRepositoryImpl(this._apiDataSource);

  @override
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required int quantity,
    required BuyerInfo buyer,
    required List<ParticipantInfo> participants,
  }) async {
    final ticketsRequest = [
      BookingTicketRequestDto(
        ticketTypeId: slotId,
        quantity: quantity,
        attendees: participants.map((p) => AttendeeInfoDto(
          firstName: p.firstName ?? '',
          lastName: p.lastName ?? '',
        )).toList(),
      ),
    ];

    final buyerInfoDto = BuyerInfoDto(
      firstName: buyer.firstName ?? '',
      lastName: buyer.lastName ?? '',
      email: buyer.email ?? '',
      phone: buyer.phone,
    );

    final response = await _apiDataSource.createBooking(
      eventId: int.parse(activityId),
      tickets: ticketsRequest,
      buyerInfo: buyerInfoDto,
    );

    return Booking(
      id: response.booking.id.toString(),
      userId: '', // Will be filled by backend
      slotId: slotId,
      activityId: activityId,
      quantity: quantity,
      totalPrice: response.pricing.total,
      currency: response.pricing.currency,
      status: response.booking.status,
    );
  }

  @override
  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  }) async {
    if (paymentIntentId != null) {
      await _apiDataSource.confirmBooking(
        bookingId: int.parse(bookingId),
        paymentIntentId: paymentIntentId,
      );
    }

    return Booking(
      id: bookingId,
      userId: '',
      slotId: '',
      activityId: '',
      status: 'confirmed',
      paymentReference: paymentIntentId,
    );
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _apiDataSource.cancelBooking(bookingId: int.parse(bookingId));
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    final response = await _apiDataSource.getMyBookings();

    return response.bookings.map((b) => Booking(
      id: b.id.toString(),
      userId: '',
      slotId: '',
      activityId: b.event.id.toString(),
      quantity: b.ticketsCount,
      totalPrice: b.totalPaid,
      currency: b.currency,
      status: b.status,
      createdAt: DateTime.tryParse(b.bookedAt),
    )).toList();
  }

  @override
  Future<List<Ticket>> getMyTickets() async {
    final response = await _apiDataSource.getMyTickets();

    return response.tickets.map((t) => Ticket(
      id: t.id.toString(),
      bookingId: t.bookingId?.toString() ?? '',
      userId: '',
      slotId: '',
      ticketType: t.ticketType,
      qrCodeData: t.qrCode,
      status: t.status,
    )).toList();
  }

  @override
  Future<List<Ticket>> getTicketsByBooking(String bookingId) async {
    // Get all tickets and filter by booking
    final response = await _apiDataSource.getMyTickets();

    return response.tickets
        .where((t) => t.bookingId?.toString() == bookingId)
        .map((t) => Ticket(
          id: t.id.toString(),
          bookingId: t.bookingId?.toString() ?? '',
          userId: '',
          slotId: '',
          ticketType: t.ticketType,
          qrCodeData: t.qrCode,
          status: t.status,
        ))
        .toList();
  }
}
