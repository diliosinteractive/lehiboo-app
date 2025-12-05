import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  // This should be overridden in main.dart or via a core provider
  throw UnimplementedError('bookingRepositoryProvider not initialized');
});

final bookingFlowControllerProvider = StateNotifierProvider.autoDispose
    .family<BookingFlowController, BookingFlowState, Activity>((ref, activity) {
  final repo = ref.watch(bookingRepositoryProvider);
  return BookingFlowController(
    bookingRepository: repo,
    activity: activity,
  );
});

class BookingFlowController extends StateNotifier<BookingFlowState> {
  BookingFlowController({
    required this.bookingRepository,
    required Activity activity,
  }) : super(
          BookingFlowState(
            step: const BookingStep.selectSlot(),
            activity: activity,
            quantity: 1,
            isFree: activity.isFree ?? false,
            isSubmitting: false,
            currency: activity.currency ?? 'EUR',
          ),
        );

  final BookingRepository bookingRepository;

  void selectSlot(Slot slot) {
    state = state.copyWith(selectedSlot: slot, errorMessage: null);
    _calculateTotal();
  }

  void updateQuantity(int quantity) {
    if (quantity < 1) return;
    state = state.copyWith(quantity: quantity, errorMessage: null);
    _calculateTotal();
  }

  void _calculateTotal() {
    if (state.selectedSlot == null) return;
    
    // Simple logic: priority to slot price, then activity price
    double? unitPrice = state.selectedSlot!.priceMin ?? state.activity.priceMin;
    if (unitPrice != null) {
      state = state.copyWith(totalPrice: unitPrice * state.quantity);
    }
  }

  void updateBuyerInfo(BuyerInfo info) {
    state = state.copyWith(buyerInfo: info, errorMessage: null);
  }

  void updateParticipants(List<ParticipantInfo> participants) {
    state = state.copyWith(participants: participants, errorMessage: null);
  }

  Future<void> goToParticipantsStep() async {
    if (state.selectedSlot == null) {
      state = state.copyWith(errorMessage: 'Veuillez sélectionner un créneau.');
      return;
    }
    state = state.copyWith(step: const BookingStep.participants(), errorMessage: null);
  }

  Future<void> goToPaymentStep() async {
    if (!_validateBuyerInfo()) return;
    
    // Ensure participants list size matches quantity (or fill with empty/default)
    final currentParticipants = state.participants ?? [];
    if (currentParticipants.length != state.quantity) {
       // Logic to auto-fill or validate could go here. 
       // For now, assume if quantity > 1 and list is empty, we might need logic.
    }

    if (state.isFree) {
        // Skip payment step for free events
        await submitFreeBooking();
    } else {
        state = state.copyWith(step: const BookingStep.payment(), errorMessage: null);
    }
  }

  bool _validateBuyerInfo() {
    final buyer = state.buyerInfo;
    if (buyer == null || 
        (buyer.email?.isEmpty ?? true) || 
        (buyer.firstName?.isEmpty ?? true) || 
        (buyer.lastName?.isEmpty ?? true)) {
      state = state.copyWith(errorMessage: 'Veuillez remplir toutes les informations obligatoires.');
      return false;
    }
    // Basic email regex
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(buyer.email!)) {
      state = state.copyWith(errorMessage: 'Email invalide.');
      return false;
    }
    return true;
  }

  Future<void> submitFreeBooking() async {
    await _submitBooking(paymentIntentId: null);
  }

  Future<void> submitPaidBooking({required String paymentIntentId}) async {
    await _submitBooking(paymentIntentId: paymentIntentId);
  }

  Future<void> _submitBooking({String? paymentIntentId}) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      // 1. Create Booking
      final booking = await bookingRepository.createBooking(
        activityId: state.activity.id,
        slotId: state.selectedSlot!.id,
        quantity: state.quantity,
        buyer: state.buyerInfo!,
        participants: state.participants ?? [
             // Default single participant = buyer if list empty
             ParticipantInfo(firstName: state.buyerInfo!.firstName, lastName: state.buyerInfo!.lastName)
        ],
      );

      // 2. Confirm Booking (if needed immediately or strictly for paid flow after stripe)
      // For free booking, backend might auto-confirm. For paid, we send Intent ID.
      final confirmedBooking = await bookingRepository.confirmBooking(
        bookingId: booking.id,
        paymentIntentId: paymentIntentId,
      );

      // 3. Get Tickets
      final tickets = await bookingRepository.getTicketsByBooking(confirmedBooking.id);

      state = state.copyWith(
        isSubmitting: false,
        confirmedBooking: confirmedBooking,
        tickets: tickets,
        step: const BookingStep.confirmation(),
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
    }
  }
}
