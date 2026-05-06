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
    required List<TicketSelection> ticketSelections,
    required BuyerInfo buyer,
    bool acceptTerms = false,
    bool acceptNewsletter = false,
    String? promoCode,
  }) async {
    final items = ticketSelections
        .map((ts) => BookingTicketRequestDto(
              ticketTypeId: ts.ticketTypeId,
              quantity: ts.quantity,
              attendees: ts.attendees
                  .map((a) => AttendeeRequestDto(
                        firstName: a.firstName ?? '',
                        lastName: a.lastName ?? '',
                        email: a.email,
                        phone: a.phone,
                        relationship: a.relationship,
                        birthDate: a.birthDate,
                        age: a.age,
                        city: a.city,
                        membershipCity: a.membershipCity,
                      ))
                  .toList(),
            ))
        .toList();

    final totalQuantity =
        ticketSelections.fold<int>(0, (sum, ts) => sum + ts.quantity);

    final response = await _apiDataSource.createBooking(
      eventId: activityId,
      slotId: slotId,
      items: items,
      customerEmail: buyer.email ?? '',
      customerFirstName: buyer.firstName ?? '',
      customerLastName: buyer.lastName ?? '',
      customerPhone: buyer.phone,
      customerBirthDate: buyer.birthDate,
      customerTown: buyer.town,
      promoCode: promoCode,
      acceptTerms: acceptTerms,
      acceptNewsletter: acceptNewsletter,
    );

    return Booking(
      id: response.uuid,
      userId: '',
      slotId: slotId,
      activityId: activityId,
      quantity: totalQuantity,
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
  Future<Booking> cancelBooking(String bookingId, {String? reason}) async {
    final dto = await _apiDataSource.cancelBooking(
      bookingUuid: bookingId,
      reason: reason,
    );
    return _mapBookingDto(dto);
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    final response = await _apiDataSource.getMyBookings();
    return response.data.map(_mapBookingDto).toList();
  }

  /// Maps a [BookingListItemDto] to the domain [Booking] entity. Used by
  /// both list and cancel responses (they share the same shape).
  Booking _mapBookingDto(BookingListItemDto b) {
    // Parser la date du slot depuis les différentes sources possibles
    DateTime? slotDateTime;

    // 1. Essayer depuis le slot chargé
    if (b.slot != null) {
      // Priorité: startDatetime ou startDate (ISO string complet)
      if (b.slot!.startDatetime != null) {
        slotDateTime = _parseLocal(b.slot!.startDatetime!);
      } else if (b.slot!.startDate != null) {
        slotDateTime = _parseLocal(b.slot!.startDate!);
      } else if (b.slot!.slotDate != null && b.slot!.startTime != null) {
        // Combiner slot_date + start_time (déjà en heure locale, pas d'offset)
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
      slotDateTime = _parseLocal(b.slotDate!);
    }

    // Mapper l'activity depuis l'event chargé ou les convenience fields
    // Mobile format: `id` and `internal_id` are removed, use `uuid`
    Activity? activity;
    if (b.event != null) {
      activity = Activity(
        id: b.event!.uuid ?? b.event!.id ?? b.eventId?.toString() ?? '',
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

    // Flatten items[].attendee_details[] into a single attendee list,
    // preserving order so the index lines up with the per-ticket UI.
    final attendees = <Attendee>[];
    if (b.items != null) {
      for (final item in b.items!) {
        final details = item.attendeeDetails;
        if (details == null) continue;
        for (final a in details) {
          attendees.add(Attendee(
            firstName: a.firstName,
            lastName: a.lastName,
            email: a.email,
            phone: a.phone,
            age: a.age,
            city: a.city,
            ticketTypeName: item.ticketTypeName,
          ));
        }
      }
    }

    // Build real Ticket entities backed by attendee data when available.
    // Falls back to leaving tickets null so the UI can mock them as before.
    final bookingUuid = b.uuid ?? b.id.toString();
    List<Ticket>? tickets;
    if (attendees.isNotEmpty) {
      tickets = List<Ticket>.generate(attendees.length, (index) {
        final a = attendees[index];
        return Ticket(
          id: '${bookingUuid}_ticket_$index',
          bookingId: bookingUuid,
          userId: b.userId?.toString() ?? '',
          slotId: b.slotId?.toString() ?? '',
          ticketType: a.ticketTypeName ?? 'Standard',
          status: 'active',
          attendeeFirstName: a.firstName,
          attendeeLastName: a.lastName,
          attendeeEmail: a.email,
        );
      });
    }

    // Prefer real attendee count, then API's ticketCount, then 1 as last
    // resort. Items[].quantity is the ground truth when items are present.
    final itemsQuantity =
        b.items?.fold<int>(0, (sum, it) => sum + (it.quantity ?? 0));
    final quantity = (attendees.isNotEmpty)
        ? attendees.length
        : (itemsQuantity != null && itemsQuantity > 0)
            ? itemsQuantity
            : (b.ticketCount ?? 1);

    // Map cancellation block.
    BookingCancellationInfo? cancellation;
    if (b.cancellation != null) {
      final c = b.cancellation!;
      cancellation = BookingCancellationInfo(
        allowed: c.allowed ?? false,
        canCancel: c.canCancel ?? false,
        hoursBeforeEvent: c.hoursBeforeEvent,
        deadline: c.deadline != null ? _parseLocal(c.deadline!) : null,
        deadlineFormatted: c.deadlineFormatted,
        reason: c.reason,
        cancelledAt: c.cancelledAt != null ? _parseLocal(c.cancelledAt!) : null,
      );
    }

    return Booking(
      id: bookingUuid,
      numericId: b.id, // ID numérique pour les appels API
      userId: b.userId?.toString() ?? '',
      slotId: b.slotId?.toString() ?? '',
      activityId: b.eventId?.toString() ?? '',
      quantity: quantity,
      totalPrice: b.grandTotal ?? b.totalAmount ?? 0.0,
      currency: 'EUR',
      status: b.status,
      createdAt: b.createdAt != null ? _parseLocal(b.createdAt!) : null,
      activity: activity,
      slot: slot,
      tickets: tickets,
      attendees: attendees.isNotEmpty ? attendees : null,
      cancellation: cancellation,
      customerBirthDate: b.customerBirthDate,
      customerTown: b.customerTown,
      reference: b.reference ?? b.uuid,
    );
  }

  /// Parse la date de fin du slot. Toujours retournée en heure locale.
  DateTime _parseSlotEndDateTime(BookingSlotDto? slot, DateTime startDateTime) {
    if (slot == null) return startDateTime.add(const Duration(hours: 1));

    if (slot.endDatetime != null) {
      return _parseLocal(slot.endDatetime!) ??
          startDateTime.add(const Duration(hours: 1));
    }
    if (slot.endDate != null) {
      return _parseLocal(slot.endDate!) ??
          startDateTime.add(const Duration(hours: 1));
    }
    if (slot.endTime != null) {
      try {
        // startDateTime est déjà local après _parseLocal — on construit une date locale.
        final d = startDateTime;
        final datePart =
            '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        return DateTime.parse('$datePart ${slot.endTime}');
      } catch (_) {}
    }
    return startDateTime.add(const Duration(hours: 1));
  }

  /// Parse une chaîne ISO en préservant les heures "wall-clock" du backend.
  ///
  /// L'API encode les heures dans le fuseau de l'événement (ex. "+02:00"
  /// pour Europe/Paris). `DateTime.tryParse` normalise vers UTC, et
  /// `.toLocal()` reconvertirait vers le fuseau du device — ce qui peut
  /// différer du fuseau de l'événement (notamment sur émulateur en UTC).
  ///
  /// L'écran de détail (`event_detail_screen`) affiche les `start_time`
  /// bruts ("14:00:00") sans conversion. On reproduit ce comportement ici
  /// en supprimant l'offset avant le parse, ce qui produit un DateTime
  /// "naïf" dont les heures correspondent à celles écrites par le backend.
  DateTime? _parseLocal(String iso) {
    final cleaned = iso.replaceFirst(RegExp(r'(Z|[+-]\d{2}:?\d{2})$'), '');
    return DateTime.tryParse(cleaned);
  }

  @override
  Future<List<Ticket>> getMyTickets() async {
    final response = await _apiDataSource.getMyTickets();

    return response.tickets
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
