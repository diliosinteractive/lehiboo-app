import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/booking.dart';

part 'booking_flow_state.freezed.dart';

@freezed
class BookingStep with _$BookingStep {
  const factory BookingStep.selectSlot() = _SelectSlot;
  const factory BookingStep.participants() = _Participants;
  const factory BookingStep.payment() = _Payment;
  const factory BookingStep.confirmation() = _Confirmation;
}

@freezed
class ParticipantInfo with _$ParticipantInfo {
  const ParticipantInfo._();

  const factory ParticipantInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? relationship,
    String? birthDate, // "YYYY-MM-DD"
    int? age,
    String? city,
    String? membershipCity,
    @Default(false) bool saveForLater,
  }) = _ParticipantInfo;

  /// True when the four required fields are present and the birth date is in
  /// the past — same rules used by `_validateParticipants` server-side.
  bool get isComplete {
    final fn = firstName?.trim() ?? '';
    final rel = relationship?.trim() ?? '';
    final dob = birthDate?.trim() ?? '';
    final town = (membershipCity?.trim().isNotEmpty ?? false)
        ? membershipCity!.trim()
        : (city?.trim() ?? '');
    if (fn.isEmpty || rel.isEmpty || dob.isEmpty || town.isEmpty) return false;
    final parsed = DateTime.tryParse(dob);
    if (parsed == null) return false;
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    return parsed.isBefore(todayMidnight);
  }

  /// True when no required field is filled — used to know whether a slot is
  /// still "empty" so prefill actions can target it without overwriting data.
  bool get isBlank {
    return (firstName?.trim().isEmpty ?? true) &&
        (lastName?.trim().isEmpty ?? true) &&
        (email?.trim().isEmpty ?? true) &&
        (phone?.trim().isEmpty ?? true) &&
        (relationship?.trim().isEmpty ?? true) &&
        (birthDate?.trim().isEmpty ?? true) &&
        (city?.trim().isEmpty ?? true) &&
        (membershipCity?.trim().isEmpty ?? true);
  }
}

@freezed
class BuyerInfo with _$BuyerInfo {
  const factory BuyerInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? birthDate, // "YYYY-MM-DD"
    String? town,
  }) = _BuyerInfo;
}

@freezed
class TicketSelection with _$TicketSelection {
  const factory TicketSelection({
    required String ticketTypeId,
    required String ticketName,
    required int quantity,
    @Default([]) List<ParticipantInfo> attendees,
  }) = _TicketSelection;
}

@freezed
class BookingFlowState with _$BookingFlowState {
  const factory BookingFlowState({
    required BookingStep step,
    required Activity activity,
    Slot? selectedSlot,
    @Default(1) int quantity,
    BuyerInfo? buyerInfo,
    List<ParticipantInfo>? participants,
    @Default([]) List<TicketSelection> ticketSelections,
    double? totalPrice,
    String? currency,
    @Default(false) bool isFree,
    @Default(false) bool isSubmitting,
    String? errorMessage,
    Booking? confirmedBooking,
    List<Ticket>? tickets,
  }) = _BookingFlowState;
}
