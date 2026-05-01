import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required List<TicketSelection> ticketSelections,
    required BuyerInfo buyer,
    bool acceptTerms = false,
    bool acceptNewsletter = false,
    String? promoCode,
  });

  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  });

  /// Cancel a booking on behalf of the customer. Returns the updated
  /// [Booking] from the API so callers can replace local state.
  Future<Booking> cancelBooking(String bookingId, {String? reason});

  Future<List<Booking>> getMyBookings();

  Future<List<Ticket>> getMyTickets();

  Future<List<Ticket>> getTicketsByBooking(String bookingId);
}
