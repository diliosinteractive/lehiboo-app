import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';

// Generate Mocks manually for simplicity in this example to avoid build_runner deps in test file overrides
// In real project use @GenerateMocks([BookingRepository])

class MockBookingRepository implements BookingRepository {
  Object? confirmationFailure;
  final List<Object> ticketOutcomes = [];
  Completer<Booking>? createBookingGate;
  int createBookingCalls = 0;

  @override
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required List<TicketSelection> ticketSelections,
    required BuyerInfo buyer,
    bool acceptTerms = false,
    bool acceptRefundPolicy = false,
    bool acceptNewsletter = false,
    String? promoCode,
  }) async {
    createBookingCalls++;
    final gate = createBookingGate;
    if (gate != null) return gate.future;

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
    if (ticketOutcomes.isNotEmpty) {
      final outcome = ticketOutcomes.removeAt(0);
      if (outcome is List<Ticket>) return outcome;
      throw outcome;
    }
    return [];
  }

  @override
  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  }) async {
    final failure = confirmationFailure;
    if (failure != null) throw failure;

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
  Future<Booking> cancelBooking(String bookingId, {String? reason}) async {
    return Booking(
      id: bookingId,
      userId: 'user_1',
      slotId: 'slot_1',
      activityId: 'act_1',
      status: 'cancelled',
      totalPrice: 100,
    );
  }

  @override
  Future<List<Booking>> getMyBookings() async => [];

  @override
  Future<Booking?> getBookingById(String bookingId) async => null;

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

  test(
    'ticket fetch failure keeps the confirmed booking and retry succeeds',
    () async {
      final ticketFailure = Exception('Tickets are temporarily unavailable.');
      const ticket = Ticket(
        id: 'ticket_123',
        bookingId: 'booking_123',
        userId: 'user_1',
        slotId: 'slot_1',
        status: 'active',
      );
      mockRepository.ticketOutcomes.addAll([
        ticketFailure,
        <Ticket>[ticket],
      ]);

      await _preparePaidBooking(controller, mockSlot);
      await controller.submitPaidBooking(paymentIntentId: 'pi_succeeded');

      expect(controller.state.step, const BookingStep.confirmation());
      expect(controller.state.confirmedBooking?.id, 'booking_123');
      expect(controller.state.tickets, isEmpty);
      expect(
        controller.state.errorMessage,
        'Tickets are temporarily unavailable.',
      );
      expect(controller.paymentOutcomeUncertain, isFalse);

      await controller.retryTickets();

      expect(controller.state.step, const BookingStep.confirmation());
      expect(controller.state.confirmedBooking?.id, 'booking_123');
      expect(controller.state.tickets, <Ticket>[ticket]);
      expect(controller.state.errorMessage, isNull);
      expect(controller.state.isSubmitting, isFalse);
    },
  );

  test(
    'paid confirmation failure marks the payment outcome uncertain',
    () async {
      mockRepository.confirmationFailure = Exception(
        'Confirmation response unavailable.',
      );

      await _preparePaidBooking(controller, mockSlot);
      await controller.submitPaidBooking(paymentIntentId: 'pi_succeeded');

      expect(controller.paymentOutcomeUncertain, isTrue);
      expect(controller.state.confirmedBooking, isNull);
      expect(controller.state.step, const BookingStep.payment());
      expect(
        controller.state.errorMessage,
        bookingCachedL10n().bookingPaymentConfirmationUncertain,
      );
      expect(controller.state.isSubmitting, isFalse);
    },
  );

  test('rapid repeated submit creates and confirms only one booking', () async {
    final createGate = Completer<Booking>();
    mockRepository.createBookingGate = createGate;

    await _preparePaidBooking(controller, mockSlot);
    final firstSubmit = controller.submitPaidBooking(
      paymentIntentId: 'pi_succeeded',
    );
    final repeatedSubmit = controller.submitPaidBooking(
      paymentIntentId: 'pi_succeeded',
    );

    expect(mockRepository.createBookingCalls, 1);
    expect(controller.state.isSubmitting, isTrue);

    createGate.complete(
      const Booking(
        id: 'booking_123',
        userId: 'user_1',
        slotId: 'slot_1',
        activityId: 'act_1',
        status: 'pending',
        totalPrice: 10,
      ),
    );
    await Future.wait([firstSubmit, repeatedSubmit]);

    expect(controller.state.step, const BookingStep.confirmation());
    expect(controller.state.confirmedBooking?.id, 'booking_123');
    expect(controller.state.isSubmitting, isFalse);
  });
}

Future<void> _preparePaidBooking(
  BookingFlowController controller,
  Slot slot,
) async {
  controller.selectSlot(slot);
  await controller.goToParticipantsStep();
  controller.updateBuyerInfo(
    const BuyerInfo(
      firstName: 'Ada',
      lastName: 'Lovelace',
      email: 'ada@example.test',
    ),
  );
  await controller.goToPaymentStep();
  expect(controller.state.step, const BookingStep.payment());
}
