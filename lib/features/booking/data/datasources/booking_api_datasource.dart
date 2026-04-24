import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/booking_api_dto.dart';

final bookingApiDataSourceProvider = Provider<BookingApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return BookingApiDataSource(dio);
});

class BookingApiDataSource {
  final Dio _dio;

  BookingApiDataSource(this._dio);

  /// Crée une réservation
  ///
  /// [eventId] - L'UUID de l'événement
  /// [slotId] - L'UUID du créneau/date sélectionné
  /// [items] - Liste des billets avec quantités
  /// [customerEmail/FirstName/LastName/Phone] - Informations de l'acheteur
  ///
  /// Format API: POST /bookings avec event_id, slot_id, items[], customer_*
  Future<CreateBookingResponseDto> createBooking({
    required String eventId,
    required String slotId,
    required List<BookingTicketRequestDto> items,
    required String customerEmail,
    required String customerFirstName,
    required String customerLastName,
    String? customerPhone,
    String? customerBirthDate,
    String? customerTown,
    String? couponCode,
  }) async {
    final response = await _dio.post(
      '/bookings',
      data: {
        'event_id': eventId,
        'slot_id': slotId,
        'items': items.map((t) => {
          'ticket_type_id': t.ticketTypeId,
          'quantity': t.quantity,
        }).toList(),
        'customer_email': customerEmail,
        'customer_first_name': customerFirstName,
        'customer_last_name': customerLastName,
        if (customerPhone != null && customerPhone.isNotEmpty)
          'customer_phone': customerPhone,
        if (customerBirthDate != null && customerBirthDate.isNotEmpty)
          'customer_birth_date': customerBirthDate,
        if (customerTown != null && customerTown.isNotEmpty)
          'customer_town': customerTown,
        if (couponCode != null) 'coupon_code': couponCode,
      },
    );

    final payload = ApiResponseHandler.extractObject(response.data);
    return CreateBookingResponseDto.fromJson(payload);
  }

  /// Récupère le PaymentIntent Stripe pour un booking payant
  ///
  /// À appeler après createBooking si total_amount > 0
  Future<PaymentIntentResponseDto> getPaymentIntent({
    required String bookingUuid,
  }) async {
    final response = await _dio.post('/bookings/$bookingUuid/payment-intent');

    final payload = ApiResponseHandler.extractObject(response.data);
    return PaymentIntentResponseDto.fromJson(payload);
  }

  /// Confirme un booking après paiement Stripe réussi
  Future<void> confirmBooking({
    required String bookingUuid,
    required String paymentIntentId,
  }) async {
    await _dio.post(
      '/bookings/$bookingUuid/confirm',
      data: {
        'payment_intent_id': paymentIntentId,
      },
    );
  }

  /// Confirme un booking gratuit (sans paiement)
  Future<void> confirmFreeBooking({
    required String bookingUuid,
  }) async {
    await _dio.post('/bookings/$bookingUuid/confirm-free');
  }

  /// Récupère les tickets d'un booking (avec polling si nécessaire)
  Future<List<TicketDetailDto>> getBookingTickets({
    required String bookingUuid,
  }) async {
    debugPrint('🎫 getBookingTickets: GET /bookings/$bookingUuid/tickets');
    final response = await _dio.get('/bookings/$bookingUuid/tickets');

    final data = response.data;
    debugPrint('🎫 getBookingTickets response: $data');

    try {
      final ticketsList = ApiResponseHandler.extractList(data);
      debugPrint('🎫 getBookingTickets: ${ticketsList.length} tickets trouvés');
      return ticketsList
          .map((t) => TicketDetailDto.fromJson(t as Map<String, dynamic>))
          .toList();
    } on ApiFormatException {
      debugPrint('🎫 getBookingTickets: Pas de data ou pas une liste');
      return [];
    }
  }

  Future<BookingsListResponseDto> getMyBookings({
    int page = 1,
    int perPage = 20,
    String? status, // pending, confirmed, cancelled, completed, refunded
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null && status != 'all') queryParams['status'] = status;

    final response = await _dio.get('/me/bookings', queryParameters: queryParams);

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return BookingsListResponseDto.fromJson(data);
    }
    throw ApiFormatException('Expected Map response for bookings list', data);
  }

  Future<BookingListItemDto> getBookingById(int bookingId) async {
    final response = await _dio.get('/me/bookings/$bookingId');

    final payload = ApiResponseHandler.extractObject(response.data);
    return BookingListItemDto.fromJson(payload);
  }

  /// Annule une réservation
  ///
  /// [bookingId] peut être l'ID numérique ou l'UUID selon l'API
  Future<void> cancelBooking({
    required String bookingId,
    String? reason,
  }) async {
    debugPrint('🚫 API cancelBooking: POST /me/bookings/$bookingId/cancel');
    final response = await _dio.post(
      '/me/bookings/$bookingId/cancel',
      data: {
        if (reason != null) 'reason': reason,
      },
    );

    final data = response.data;
    debugPrint('🚫 API cancelBooking response: $data');

    if (data is Map<String, dynamic> && data['success'] == false) {
      final message = ApiResponseHandler.extractError(
        Exception(data['message']),
        fallback: 'Impossible d\'annuler la réservation.',
      );
      throw Exception(message);
    }
  }

  Future<TicketsListResponseDto> getMyTickets({
    String? status, // all, valid, used, cancelled
    bool? upcoming,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (upcoming != null) queryParams['upcoming'] = upcoming;

    final response = await _dio.get('/me/tickets', queryParameters: queryParams);

    final payload = ApiResponseHandler.extractObject(response.data);
    return TicketsListResponseDto.fromJson(payload);
  }

  Future<TicketDetailDto> getTicketById(int ticketId) async {
    final response = await _dio.get('/me/tickets/$ticketId');

    final payload = ApiResponseHandler.extractObject(response.data);
    return TicketDetailDto.fromJson(payload);
  }

  Future<String> downloadTicketPdf(int ticketId) async {
    final response = await _dio.get('/me/tickets/$ticketId/download');

    final payload = ApiResponseHandler.extractObject(response.data);
    return payload['pdf_url'] as String;
  }
}
