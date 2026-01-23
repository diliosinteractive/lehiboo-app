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
      tickets: tickets?.map((t) => t.toDomain()).toList(),
      customerEmail: customerEmail,
      customerFirstName: customerFirstName,
      customerLastName: customerLastName,
      customerPhone: customerPhone,
      reference: reference,
    );
  }
}

extension TicketDtoX on TicketDto {
  Ticket toDomain() {
    return Ticket(
      id: uuid ?? id.toString(),
      bookingId: bookingId.toString(),
      userId: '', // Not provided in new DTO structure
      slotId: slotId.toString(),
      ticketType: ticketType,
      qrCodeData: qrCode ?? qrCodeData,
      qrSecret: qrSecret,
      status: status,
      attendeeFirstName: attendeeFirstName,
      attendeeLastName: attendeeLastName,
      attendeeEmail: attendeeEmail,
      price: price,
      currency: currency,
      usedAt: usedAt,
      createdAt: createdAt,
    );
  }
}

extension BookingItemDtoX on BookingItemDto {
  BookingItem toDomain() {
    return BookingItem(
      id: id.toString(),
      bookingId: bookingId.toString(),
      ticketTypeId: ticketTypeId.toString(),
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      ticketTypeName: ticketTypeName,
      currency: currency,
    );
  }
}
