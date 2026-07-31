import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required List<TicketSelection> ticketSelections,
    required BuyerInfo buyer,
    bool acceptTerms = false,
    bool acceptRefundPolicy = false,
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

  /// Loads one of the current user's bookings by its API route identifier
  /// (normally the booking UUID). Returns `null` only when the API confirms
  /// that the booking does not exist or is not accessible (HTTP 404).
  Future<Booking?> getBookingById(String bookingId);

  Future<List<Ticket>> getMyTickets();

  Future<List<Ticket>> getTicketsByBooking(String bookingId);
}
