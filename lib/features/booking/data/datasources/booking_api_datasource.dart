import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
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
        if (couponCode != null) 'coupon_code': couponCode,
      },
    );

    final data = response.data;
    // L'API retourne { "message": "...", "data": {...} }
    if (data['data'] != null) {
      return CreateBookingResponseDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to create booking');
  }

  /// Récupère le PaymentIntent Stripe pour un booking payant
  ///
  /// À appeler après createBooking si total_amount > 0
  Future<PaymentIntentResponseDto> getPaymentIntent({
    required String bookingUuid,
  }) async {
    final response = await _dio.post('/bookings/$bookingUuid/payment-intent');

    final data = response.data;
    if (data['data'] != null) {
      return PaymentIntentResponseDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to get payment intent');
  }

  /// Confirme un booking après paiement Stripe réussi
  Future<void> confirmBooking({
    required String bookingUuid,
    required String paymentIntentId,
  }) async {
    final response = await _dio.post(
      '/bookings/$bookingUuid/confirm',
      data: {
        'payment_intent_id': paymentIntentId,
      },
    );

    final data = response.data;
    if (data['message']?.toString().toLowerCase().contains('error') == true) {
      throw Exception(data['message'] ?? 'Failed to confirm booking');
    }
  }

  /// Confirme un booking gratuit (sans paiement)
  Future<void> confirmFreeBooking({
    required String bookingUuid,
  }) async {
    final response = await _dio.post('/bookings/$bookingUuid/confirm-free');

    final data = response.data;
    if (data['message']?.toString().toLowerCase().contains('error') == true) {
      throw Exception(data['message'] ?? 'Failed to confirm free booking');
    }
  }

  /// Récupère les tickets d'un booking (avec polling si nécessaire)
  Future<List<TicketDetailDto>> getBookingTickets({
    required String bookingUuid,
  }) async {
    debugPrint('🎫 getBookingTickets: GET /bookings/$bookingUuid/tickets');
    final response = await _dio.get('/bookings/$bookingUuid/tickets');

    final data = response.data;
    debugPrint('🎫 getBookingTickets response: $data');

    if (data['data'] != null && data['data'] is List) {
      final ticketsList = data['data'] as List;
      debugPrint('🎫 getBookingTickets: ${ticketsList.length} tickets trouvés');
      return ticketsList
          .map((t) => TicketDetailDto.fromJson(t))
          .toList();
    }
    debugPrint('🎫 getBookingTickets: Pas de data ou pas une liste');
    return [];
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
    // L'API Laravel retourne directement { "data": [...], "meta": {...} }
    // Pas de wrapper "success"
    if (data is Map<String, dynamic> && data['data'] != null) {
      return BookingsListResponseDto.fromJson(data);
    }
    throw Exception('Failed to load bookings');
  }

  Future<BookingListItemDto> getBookingById(int bookingId) async {
    final response = await _dio.get('/me/bookings/$bookingId');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return BookingListItemDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load booking');
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

    // Vérifier les différents formats de réponse
    if (data is Map<String, dynamic>) {
      // Format avec success boolean
      if (data['success'] == false) {
        throw Exception(data['data']?['message'] ?? data['message'] ?? 'Failed to cancel booking');
      }
      // Format avec message d'erreur explicite
      if (data['message']?.toString().toLowerCase().contains('error') == true) {
        throw Exception(data['message']);
      }
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

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return TicketsListResponseDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load tickets');
  }

  Future<TicketDetailDto> getTicketById(int ticketId) async {
    final response = await _dio.get('/me/tickets/$ticketId');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return TicketDetailDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load ticket');
  }

  Future<String> downloadTicketPdf(int ticketId) async {
    final response = await _dio.get('/me/tickets/$ticketId/download');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return data['data']['pdf_url'] as String;
    }
    throw Exception(data['data']?['message'] ?? 'Failed to download ticket');
  }
}
