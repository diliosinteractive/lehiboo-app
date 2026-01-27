import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/activity.dart';
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
    // Note: Cette méthode est utilisée par le flow legacy (BookingFlowController)
    // Le nouveau flow (CheckoutScreen) utilise directement le datasource
    final items = [
      BookingTicketRequestDto(
        ticketTypeId: slotId,
        quantity: quantity,
      ),
    ];

    final response = await _apiDataSource.createBooking(
      eventId: activityId,
      slotId: slotId,
      items: items,
      customerEmail: buyer.email ?? '',
      customerFirstName: buyer.firstName ?? '',
      customerLastName: buyer.lastName ?? '',
      customerPhone: buyer.phone,
    );

    return Booking(
      id: response.uuid,
      userId: '',
      slotId: slotId,
      activityId: activityId,
      quantity: quantity,
      totalPrice: response.totalAmount,
      currency: 'EUR',
      status: response.status,
    );
  }

  @override
  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  }) async {
    if (paymentIntentId != null) {
      await _apiDataSource.confirmBooking(
        bookingUuid: bookingId,
        paymentIntentId: paymentIntentId,
      );
    } else {
      // Confirmation gratuite
      await _apiDataSource.confirmFreeBooking(bookingUuid: bookingId);
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
    await _apiDataSource.cancelBooking(bookingId: bookingId);
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    final response = await _apiDataSource.getMyBookings();

    return response.data.map((b) {
      // Parser la date du slot depuis les différentes sources possibles
      DateTime? slotDateTime;

      // 1. Essayer depuis le slot chargé
      if (b.slot != null) {
        // Priorité: startDatetime ou startDate (ISO string complet)
        if (b.slot!.startDatetime != null) {
          slotDateTime = DateTime.tryParse(b.slot!.startDatetime!);
        } else if (b.slot!.startDate != null) {
          slotDateTime = DateTime.tryParse(b.slot!.startDate!);
        } else if (b.slot!.slotDate != null && b.slot!.startTime != null) {
          // Combiner slot_date + start_time
          try {
            final datePart = b.slot!.slotDate!.split('T').first;
            slotDateTime = DateTime.parse('$datePart ${b.slot!.startTime}');
          } catch (_) {}
        } else if (b.slot!.date != null && b.slot!.startTime != null) {
          try {
            slotDateTime = DateTime.parse('${b.slot!.date} ${b.slot!.startTime}');
          } catch (_) {}
        }
      }

      // 2. Fallback: utiliser slotDate au niveau du booking (convenience field)
      if (slotDateTime == null && b.slotDate != null) {
        slotDateTime = DateTime.tryParse(b.slotDate!);
      }

      // Mapper l'activity depuis l'event chargé ou les convenience fields
      Activity? activity;
      if (b.event != null) {
        activity = Activity(
          id: b.event!.internalId?.toString() ?? b.event!.id ?? b.eventId?.toString() ?? '',
          title: b.event!.title,
          slug: b.event!.slug ?? '',
          description: '',
          imageUrl: b.event!.featuredImage ?? b.event!.coverImage,
        );
      } else if (b.eventTitle != null) {
        // Utiliser les convenience fields si l'event n'est pas chargé
        activity = Activity(
          id: b.eventId?.toString() ?? '',
          title: b.eventTitle!,
          slug: b.eventSlug ?? '',
          description: '',
          imageUrl: b.eventImage,
        );
      }

      // Mapper le slot
      Slot? slot;
      if (slotDateTime != null) {
        slot = Slot(
          id: b.slot?.id ?? b.slotId?.toString() ?? '',
          activityId: b.eventId?.toString() ?? '',
          startDateTime: slotDateTime,
          endDateTime: _parseSlotEndDateTime(b.slot, slotDateTime),
        );
      }

      return Booking(
        id: b.uuid ?? b.id.toString(),
        numericId: b.id, // ID numérique pour les appels API
        userId: b.userId?.toString() ?? '',
        slotId: b.slotId?.toString() ?? '',
        activityId: b.eventId?.toString() ?? '',
        quantity: b.ticketCount ?? 1,
        totalPrice: b.grandTotal ?? b.totalAmount ?? 0.0,
        currency: 'EUR',
        status: b.status,
        createdAt: b.createdAt != null ? DateTime.tryParse(b.createdAt!) : null,
        activity: activity,
        slot: slot,
      );
    }).toList();
  }

  /// Parse la date de fin du slot
  DateTime _parseSlotEndDateTime(BookingSlotDto? slot, DateTime startDateTime) {
    if (slot == null) return startDateTime.add(const Duration(hours: 1));

    if (slot.endDatetime != null) {
      return DateTime.tryParse(slot.endDatetime!) ?? startDateTime.add(const Duration(hours: 1));
    }
    if (slot.endDate != null) {
      return DateTime.tryParse(slot.endDate!) ?? startDateTime.add(const Duration(hours: 1));
    }
    if (slot.endTime != null) {
      try {
        final datePart = startDateTime.toIso8601String().split('T').first;
        return DateTime.parse('$datePart ${slot.endTime}');
      } catch (_) {}
    }
    return startDateTime.add(const Duration(hours: 1));
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
