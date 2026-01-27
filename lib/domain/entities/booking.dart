import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lehiboo/domain/entities/activity.dart';

part 'booking.freezed.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id, // UUID
    int? numericId, // ID numérique pour les appels API (cancel, etc.)
    required String userId,
    required String slotId,
    required String activityId,
    int? quantity,
    double? totalPrice,
    String? currency,
    String? status, // pending, confirmed, cancelled, refunded, completed
    String? paymentProvider,
    String? paymentReference,
    DateTime? createdAt,
    // Expanded fields for UI
    Activity? activity,
    Slot? slot,
    // Tickets associated with this booking
    List<Ticket>? tickets,
    // Customer info
    String? customerEmail,
    String? customerFirstName,
    String? customerLastName,
    String? customerPhone,
    // Reference (short code for display)
    String? reference,
  }) = _Booking;
}

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    required String bookingId,
    required String userId,
    required String slotId,
    String? ticketType,
    String? qrCodeData,
    String? qrSecret,
    String? status, // active, used, cancelled, expired
    // Attendee info
    String? attendeeFirstName,
    String? attendeeLastName,
    String? attendeeEmail,
    // Pricing
    double? price,
    String? currency,
    // Timestamps
    DateTime? usedAt,
    DateTime? createdAt,
  }) = _Ticket;
}

@freezed
class BookingItem with _$BookingItem {
  const factory BookingItem({
    required String id,
    required String bookingId,
    required String ticketTypeId,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? ticketTypeName,
    String? currency,
  }) = _BookingItem;
}
