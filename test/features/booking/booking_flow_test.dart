import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';


// Generate Mocks manually for simplicity in this example to avoid build_runner deps in test file overrides
// In real project use @GenerateMocks([BookingRepository])

class MockBookingRepository implements BookingRepository {
  @override
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required int quantity,
    required BuyerInfo buyer,
    required List<ParticipantInfo> participants,
  }) async {
    return Booking(
       id: 'booking_123', 
       userId: 'user_1', 
       slotId: slotId, 
       activityId: activityId, 
       status: 'pending',
       totalPrice: 100,
    );
  }

  @override
  Future<List<Ticket>> getTicketsByBooking(String bookingId) async {
    return [];
  }
  
  @override
  Future<Booking> confirmBooking({required String bookingId, String? paymentIntentId}) async {
    return Booking(
       id: bookingId,
       userId: 'user_1',
       slotId: 'slot_1',
       activityId: 'act_1',
       status: 'confirmed',
       totalPrice: 100,
    );
  }
  
  @override
  Future<void> cancelBooking(String bookingId) async {}

  @override
  Future<List<Booking>> getMyBookings() async => [];

  @override
  Future<List<Ticket>> getMyTickets() async => [];
}

void main() {
  late BookingFlowController controller;
  late MockBookingRepository mockRepository;
  
  final mockSlot = Slot(
     id: 'slot_1', 
     activityId: 'act_1', 
     startDateTime: DateTime.now(), 
     endDateTime: DateTime.now().add(const Duration(hours: 1)),
     priceMin: 10,
  );
  
  final mockActivity = Activity(
    id: 'act_1', 
    title: 'Test Activity', 
    slug: 'test', 
    description: 'desc',
    isFree: false,
    priceMin: 10,
    nextSlot: mockSlot,
  );

  setUp(() {
    mockRepository = MockBookingRepository();
    controller = BookingFlowController(
      bookingRepository: mockRepository,
      activity: mockActivity,
    );
  });

  test('Initial state is correct', () {
    expect(controller.state.activity, mockActivity);
    expect(controller.state.step, const BookingStep.selectSlot());
    expect(controller.state.quantity, 1);
  });

  test('Select Slot updates state and calculates total', () {
    controller.selectSlot(mockSlot);
    expect(controller.state.selectedSlot, mockSlot);
    expect(controller.state.totalPrice, 10.0);
    
    controller.updateQuantity(2);
    expect(controller.state.quantity, 2);
    expect(controller.state.totalPrice, 20.0);
  });

  test('Go to participants fails if no slot selected', () async {
    await controller.goToParticipantsStep();
    expect(controller.state.errorMessage, isNotNull);
    expect(controller.state.step, const BookingStep.selectSlot());
  });

  test('Go to participants succeeds with slot', () async {
    controller.selectSlot(mockSlot);
    await controller.goToParticipantsStep();
    expect(controller.state.errorMessage, isNull);
    expect(controller.state.step, const BookingStep.participants());
  });
}
