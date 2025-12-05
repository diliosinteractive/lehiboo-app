import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required int quantity,
    required BuyerInfo buyer,
    required List<ParticipantInfo> participants,
  });

  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  });

  Future<void> cancelBooking(String bookingId);

  Future<List<Booking>> getMyBookings();

  Future<List<Ticket>> getMyTickets();

  Future<List<Ticket>> getTicketsByBooking(String bookingId);
}
