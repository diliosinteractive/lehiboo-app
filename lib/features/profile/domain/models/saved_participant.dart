import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

class SavedParticipant {
  final String uuid;
  final String? label;
  final String? relationship;
  final String displayName;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? birthDate;
  final String? membershipCity;

  const SavedParticipant({
    required this.uuid,
    this.label,
    this.relationship,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.birthDate,
    this.membershipCity,
  });

  factory SavedParticipant.fromJson(Map<String, dynamic> json) {
    final firstName =
        (json['firstName'] ?? json['first_name'] ?? '').toString();
    final lastName = (json['lastName'] ?? json['last_name'] ?? '').toString();
    final fallbackName =
        [firstName, lastName].where((v) => v.isNotEmpty).join(' ');

    return SavedParticipant(
      uuid: (json['uuid'] ?? json['id']).toString(),
      label: json['label']?.toString(),
      relationship: json['relationship']?.toString(),
      displayName: (json['displayName'] ??
              json['display_name'] ??
              json['label'] ??
              fallbackName)
          .toString(),
      firstName: firstName,
      lastName: lastName,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      birthDate:
          json['birthDate']?.toString() ?? json['birth_date']?.toString(),
      membershipCity: json['membershipCity']?.toString() ??
          json['membership_city']?.toString(),
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      if (label != null && label!.isNotEmpty) 'label': label,
      if (relationship != null && relationship!.isNotEmpty)
        'relationship': relationship,
      'first_name': firstName,
      'last_name': lastName,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (birthDate != null && birthDate!.isNotEmpty) 'birth_date': birthDate,
      if (membershipCity != null && membershipCity!.isNotEmpty)
        'membership_city': membershipCity,
    };
  }

  ParticipantInfo toParticipantInfo() {
    return ParticipantInfo(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      relationship: relationship,
      birthDate: birthDate,
      age: computeAge(birthDate),
      city: membershipCity,
      membershipCity: membershipCity,
    );
  }
}
