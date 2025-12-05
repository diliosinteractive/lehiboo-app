import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lehiboo/domain/entities/activity.dart';

part 'booking.freezed.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String slotId,
    required String activityId,
    int? quantity,
    double? totalPrice,
    String? currency,
    String? status, // pending, confirmed, cancelled, refunded
    String? paymentProvider,
    String? paymentReference,
    DateTime? createdAt,
    // Expanded fields for UI
    Activity? activity,
    Slot? slot,
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
    String? status, // active, used, refunded
  }) = _Ticket;
}
