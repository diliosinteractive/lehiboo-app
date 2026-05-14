import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_rejected.freezed.dart';
part 'organization_rejected.g.dart';

/// Payload of the `organization.rejected` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §11
@Freezed(toJson: false)
class OrganizationRejectedData with _$OrganizationRejectedData {
  const factory OrganizationRejectedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'organization_uuid') String? organizationUuid,
    @JsonKey(name: 'organization_name') String? organizationName,
    String? reason,
    @JsonKey(name: 'rejected_at') DateTime? rejectedAt,
  }) = _OrganizationRejectedData;

  factory OrganizationRejectedData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationRejectedDataFromJson(json);
}

@Freezed(toJson: false)
class OrganizationRejectedNotification with _$OrganizationRejectedNotification {
  const factory OrganizationRejectedNotification({
    required String event,
    String? channel,
    required OrganizationRejectedData data,
    DateTime? receivedAt,
  }) = _OrganizationRejectedNotification;
}
