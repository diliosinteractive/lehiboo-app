import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_suspended.freezed.dart';
part 'organization_suspended.g.dart';

/// Payload of the `organization.suspended` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §11
@Freezed(toJson: false)
class OrganizationSuspendedData with _$OrganizationSuspendedData {
  const factory OrganizationSuspendedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    String? reason,
    @JsonKey(name: 'suspended_at') DateTime? suspendedAt,
  }) = _OrganizationSuspendedData;

  factory OrganizationSuspendedData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationSuspendedDataFromJson(json);
}

@Freezed(toJson: false)
class OrganizationSuspendedNotification
    with _$OrganizationSuspendedNotification {
  const factory OrganizationSuspendedNotification({
    required String event,
    String? channel,
    required OrganizationSuspendedData data,
    DateTime? receivedAt,
  }) = _OrganizationSuspendedNotification;
}
