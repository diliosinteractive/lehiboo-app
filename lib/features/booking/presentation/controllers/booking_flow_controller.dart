import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/analytics/analytics_event.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/analytics_service.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';
import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';

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
    ref: ref,
  );
});

class BookingFlowController extends StateNotifier<BookingFlowState> {
  BookingFlowController({
    required this.bookingRepository,
    required Activity activity,
    Ref? ref,
  })  : _ref = ref,
        super(
          BookingFlowState(
            step: const BookingStep.selectSlot(),
            activity: activity,
            quantity: 1,
            isFree: activity.isFree ?? false,
            isSubmitting: false,
            currency: activity.currency ?? 'EUR',
          ),
        ) {
    // begin_checkout — signal d'entrée dans le funnel de réservation. Loggué
    // dès la construction du controller (= ouverture du BookingScreen) pour
    // mesurer les bounces immédiats (begin_checkout sans purchase).
    _analytics?.logEvent(
      AnalyticsEvent.beginCheckout,
      params: {
        AnalyticsParam.eventUuid: activity.id,
        AnalyticsParam.value: activity.priceMin ?? 0,
        AnalyticsParam.currency: activity.currency ?? 'EUR',
        AnalyticsParam.isFree: activity.isFree ?? false,
      },
    );
  }

  final BookingRepository bookingRepository;
  final Ref? _ref;

  AnalyticsService? get _analytics =>
      _ref == null ? null : _ref.read(analyticsServiceProvider);

  void selectSlot(Slot slot) {
    state = state.copyWith(selectedSlot: slot, errorMessage: null);
    _calculateTotal();
    _analytics?.logEvent(
      AnalyticsEvent.bookingSlotSelected,
      params: {
        AnalyticsParam.eventUuid: state.activity.id,
        AnalyticsParam.slotId: slot.id,
      },
    );
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
      state = state.copyWith(
        errorMessage: bookingCachedL10n().bookingLegacySelectSlotRequired,
      );
      return;
    }
    state = state.copyWith(
        step: const BookingStep.participants(), errorMessage: null);
  }

  Future<void> goToPaymentStep() async {
    if (!_validateBuyerInfo()) return;

    // Ensure participants list size matches quantity (or fill with empty/default)
    final currentParticipants = state.participants ?? [];
    if (currentParticipants.length != state.quantity) {
      // Logic to auto-fill or validate could go here.
      // For now, assume if quantity > 1 and list is empty, we might need logic.
    }

    _analytics?.logEvent(
      AnalyticsEvent.bookingCustomerFormCompleted,
      params: {AnalyticsParam.eventUuid: state.activity.id},
    );

    if (state.isFree) {
      // Skip payment step for free events
      await submitFreeBooking();
    } else {
      state =
          state.copyWith(step: const BookingStep.payment(), errorMessage: null);
    }
  }

  bool _validateBuyerInfo() {
    final buyer = state.buyerInfo;
    if (buyer == null ||
        (buyer.email?.isEmpty ?? true) ||
        (buyer.firstName?.isEmpty ?? true) ||
        (buyer.lastName?.isEmpty ?? true)) {
      state = state.copyWith(
        errorMessage: bookingCachedL10n().bookingLegacyRequiredInfo,
      );
      return false;
    }
    // Basic email regex
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(buyer.email!)) {
      state =
          state.copyWith(errorMessage: bookingCachedL10n().bookingEmailInvalid);
      return false;
    }
    return true;
  }

  Future<void> submitFreeBooking() async {
    await _submitBooking(paymentIntentId: null);
  }

  Future<void> submitPaidBooking({required String paymentIntentId}) async {
    _analytics?.logEvent(
      AnalyticsEvent.addPaymentInfo,
      params: {
        AnalyticsParam.eventUuid: state.activity.id,
        AnalyticsParam.value: state.totalPrice ?? 0,
        AnalyticsParam.currency: state.currency,
      },
    );
    await _submitBooking(paymentIntentId: paymentIntentId);
  }

  Future<void> _submitBooking({String? paymentIntentId}) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    String failureStep = AnalyticsBookingStep.create;
    try {
      // 1. Create Booking
      // Build ticket selections from legacy single-quantity state
      final legacySelections = state.ticketSelections.isNotEmpty
          ? state.ticketSelections
          : [
              TicketSelection(
                ticketTypeId: state.selectedSlot!.id,
                ticketName: '',
                quantity: state.quantity,
                attendees: state.participants ??
                    [
                      ParticipantInfo(
                        firstName: state.buyerInfo!.firstName,
                        lastName: state.buyerInfo!.lastName,
                      ),
                    ],
              ),
            ];

      final booking = await bookingRepository.createBooking(
        activityId: state.activity.id,
        slotId: state.selectedSlot!.id,
        ticketSelections: legacySelections,
        buyer: state.buyerInfo!,
      );

      // 2. Confirm Booking (if needed immediately or strictly for paid flow after stripe)
      // For free booking, backend might auto-confirm. For paid, we send Intent ID.
      failureStep = AnalyticsBookingStep.confirm;
      final confirmedBooking = await bookingRepository.confirmBooking(
        bookingId: booking.id,
        paymentIntentId: paymentIntentId,
      );

      // 3. Get Tickets
      final tickets =
          await bookingRepository.getTicketsByBooking(confirmedBooking.id);

      state = state.copyWith(
        isSubmitting: false,
        confirmedBooking: confirmedBooking,
        tickets: tickets,
        step: const BookingStep.confirmation(),
      );

      // purchase (standard GA4) — funnel completion. Avec `transaction_id`,
      // `value`, `currency` GA4 alimente les rapports Monetization.
      _analytics?.logEvent(
        AnalyticsEvent.purchase,
        params: {
          AnalyticsParam.transactionId: confirmedBooking.id,
          AnalyticsParam.value: state.totalPrice ?? 0,
          AnalyticsParam.currency: state.currency,
          AnalyticsParam.eventUuid: state.activity.id,
          AnalyticsParam.isFree: state.isFree,
        },
      );

      if (tickets.isNotEmpty) {
        _analytics?.logEvent(
          AnalyticsEvent.ticketsDisplayed,
          params: {
            AnalyticsParam.bookingUuid: confirmedBooking.id,
            AnalyticsParam.quantity: tickets.length,
          },
        );
      }

      // Booking signal changed — drop the personalized feed (spec §7).
      _ref?.invalidate(personalizedFeedProvider);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      _analytics?.logEvent(
        AnalyticsEvent.bookingFailed,
        params: {
          AnalyticsParam.eventUuid: state.activity.id,
          AnalyticsParam.step: failureStep,
          AnalyticsParam.reason: e.runtimeType.toString(),
        },
      );
    }
  }
}
