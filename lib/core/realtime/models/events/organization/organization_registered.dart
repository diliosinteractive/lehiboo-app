import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_registered.freezed.dart';
part 'organization_registered.g.dart';

/// Payload of the `organization.registered` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §11
@Freezed(toJson: false)
class OrganizationRegisteredData with _$OrganizationRegisteredData {
  const factory OrganizationRegisteredData({
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'organization_name') String? organizationName,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'registered_at') DateTime? registeredAt,
  }) = _OrganizationRegisteredData;

  factory OrganizationRegisteredData.fromJson(Map<String, dynamic> json) =>
      _$OrganizationRegisteredDataFromJson(json);
}

@Freezed(toJson: false)
class OrganizationRegisteredNotification
    with _$OrganizationRegisteredNotification {
  const factory OrganizationRegisteredNotification({
    required String event,
    String? channel,
    required OrganizationRegisteredData data,
    DateTime? receivedAt,
  }) = _OrganizationRegisteredNotification;
}
