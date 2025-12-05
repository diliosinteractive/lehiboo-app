import 'package:lehiboo/features/booking/data/models/booking_dto.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/data/mappers/activity_mapper.dart';

extension BookingDtoX on BookingDto {
  Booking toDomain() {
    return Booking(
      id: id.toString(),
      userId: userId.toString(),
      slotId: slotId.toString(),
      activityId: activityId.toString(),
      quantity: quantity,
      totalPrice: totalPrice,
      currency: currency,
      status: status,
      paymentProvider: paymentProvider,
      paymentReference: paymentReference,
      createdAt: createdAt,
      activity: activity?.toDomain(),
      slot: slot?.toDomain(),
    );
  }
}

extension TicketDtoX on TicketDto {
  Ticket toDomain() {
    return Ticket(
      id: id.toString(),
      bookingId: bookingId.toString(),
      userId: userId.toString(),
      slotId: slotId.toString(),
      ticketType: ticketType,
      qrCodeData: qrCodeData,
      status: status,
    );
  }
}
