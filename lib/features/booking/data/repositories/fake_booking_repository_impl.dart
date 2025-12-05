import 'dart:convert';
import 'package:lehiboo/core/mock/mock_data.dart';
import 'package:lehiboo/data/mappers/booking_mapper.dart';
import 'package:lehiboo/features/booking/data/models/booking_dto.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';

class FakeBookingRepositoryImpl implements BookingRepository {
  final List<Booking> _localBookings = [];

  FakeBookingRepositoryImpl() {
    // Load initial mocks
    final List<dynamic> jsonList = jsonDecode(MockData.myBookings);
    _localBookings.addAll(
      jsonList.map((j) => BookingDto.fromJson(j).toDomain()).toList(),
    );
  }

  @override
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required int quantity,
    required BuyerInfo buyer,
    required List<ParticipantInfo> participants,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newBooking = Booking(
      id: 'fake_booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_1',
      slotId: slotId.toString(), // Ensure String
      activityId: activityId.toString(), // Ensure String
      quantity: quantity,
      status: 'pending',
      // Mock prices/etc would be needed here normally
      totalPrice: 0.0,
    );
    
    // In a real fake repo, we'd store this temporarily to confirm later
    return newBooking;
  }

  @override
  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final confirmed = Booking(
      id: bookingId,
      userId: 'user_1',
      slotId: 'fake_slot', 
      activityId: 'fake_act',
      quantity: 1,
      status: 'confirmed',
      paymentReference: paymentIntentId, // Map to paymentReference instead
    );
    
    _localBookings.insert(0, confirmed);
    return confirmed;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _localBookings.removeWhere((b) => b.id == bookingId);
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _localBookings;
  }

  @override
  Future<List<Ticket>> getMyTickets() async {
    return _generateFakeTickets();
  }

  @override
  Future<List<Ticket>> getTicketsByBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Generate fake tickets for this booking
    return [
      Ticket(
        id: 'ticket_${bookingId}_1',
        bookingId: bookingId,
        userId: 'user_1',
        slotId: 'slot_x',
        qrCodeData: 'LEHIBOO_TICKET_${bookingId}_1',
        status: 'valid',
      )
    ];
  }
  
  List<Ticket> _generateFakeTickets() {
     return _localBookings.map((b) => Ticket(
        id: 'ticket_${b.id}',
        bookingId: b.id,
        userId: b.userId,
        slotId: b.slotId,
        qrCodeData: 'MOCK_QR_${b.id}',
        status: 'valid'
     )).toList();
  }
}
