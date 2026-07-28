import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_approved.freezed.dart';
part 'organization_approved.g.dart';

/// Payload of the `organization.approved` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §11
@Freezed(toJson: false)
class OrganizationApprovedData with _$OrganizationApprovedData {
  const factory OrganizationApprovedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'organization_uuid') String? organizationUuid,
    @JsonKey(name: 'organization_name') String? organizationName,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
  }) = _OrganizationApprovedData;

  factory OrganizationApprovedData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationApprovedDataFromJson(json);
}

@Freezed(toJson: false)
class OrganizationApprovedNotification with _$OrganizationApprovedNotification {
  const factory OrganizationApprovedNotification({
    required String event,
    String? channel,
    required OrganizationApprovedData data,
    DateTime? receivedAt,
  }) = _OrganizationApprovedNotification;
}
