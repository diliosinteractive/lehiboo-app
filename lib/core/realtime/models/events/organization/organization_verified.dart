import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_verified.freezed.dart';
part 'organization_verified.g.dart';

/// Payload of the `organization.verified` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §11
@Freezed(toJson: false)
class OrganizationVerifiedData with _$OrganizationVerifiedData {
  const factory OrganizationVerifiedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'organization_name') String? organizationName,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  }) = _OrganizationVerifiedData;

  factory OrganizationVerifiedData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationVerifiedDataFromJson(json);
}

@Freezed(toJson: false)
class OrganizationVerifiedNotification with _$OrganizationVerifiedNotification {
  const factory OrganizationVerifiedNotification({
    required String event,
    String? channel,
    required OrganizationVerifiedData data,
    DateTime? receivedAt,
  }) = _OrganizationVerifiedNotification;
}
