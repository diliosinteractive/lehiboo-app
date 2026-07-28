import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_reactivated.freezed.dart';
part 'organization_reactivated.g.dart';

/// Payload of the `organization.reactivated` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §11
@Freezed(toJson: false)
class OrganizationReactivatedData with _$OrganizationReactivatedData {
  const factory OrganizationReactivatedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'reactivated_at') DateTime? reactivatedAt,
  }) = _OrganizationReactivatedData;

  factory OrganizationReactivatedData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationReactivatedDataFromJson(json);
}

@Freezed(toJson: false)
class OrganizationReactivatedNotification
    with _$OrganizationReactivatedNotification {
  const factory OrganizationReactivatedNotification({
    required String event,
    String? channel,
    required OrganizationReactivatedData data,
    DateTime? receivedAt,
  }) = _OrganizationReactivatedNotification;
}
