import '../../data/models/membership_dto.dart';

/// Thrown by event datasources when the API returns `403` with body
/// `{"error": "members_only", "organization": {...}}` — direct-link access
/// to a private event by a non-member.
///
/// Carries the embedded organization payload so the gate screen can render
/// "Rejoindre {Name}" without an extra fetch.
///
/// Spec: MEMBERSHIPS_MOBILE_SPEC.md §20.
class MembersOnlyException implements Exception {
  final OrganizationSummaryDto organization;

  const MembersOnlyException(this.organization);

  @override
  String toString() =>
      'MembersOnlyException(organization=${organization.name})';
}
