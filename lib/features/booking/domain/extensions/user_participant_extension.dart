import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

extension UserParticipantInfo on HbUser {
  /// Map the authenticated user to a ParticipantInfo so the cart can prefill
  /// a slot with "Moi" — same shape the form fields would produce.
  ParticipantInfo toParticipantInfo() {
    final dob = birthDate?.toIso8601String().substring(0, 10);
    return ParticipantInfo(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      relationship: 'self',
      birthDate: dob,
      age: computeAge(dob),
      city: city ?? membershipCity,
      membershipCity: membershipCity ?? city,
    );
  }
}
