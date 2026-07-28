import 'package:freezed_annotation/freezed_annotation.dart';

part 'partnership_invited.freezed.dart';
part 'partnership_invited.g.dart';

/// Payload of the `partnership.invited` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §10
@Freezed(toJson: false)
class PartnershipInvitedData with _$PartnershipInvitedData {
  const factory PartnershipInvitedData({
    @JsonKey(name: 'partnership_id') required String partnershipId,
    @JsonKey(name: 'inviter_name') String? inviterName,
    @JsonKey(name: 'invited_at') DateTime? invitedAt,
  }) = _PartnershipInvitedData;

  factory PartnershipInvitedData.fromJson(Map<String, dynamic> json) =>
      _$PartnershipInvitedDataFromJson(json);
}

@Freezed(toJson: false)
class PartnershipInvitedNotification with _$PartnershipInvitedNotification {
  const factory PartnershipInvitedNotification({
    required String event,
    String? channel,
    required PartnershipInvitedData data,
    DateTime? receivedAt,
  }) = _PartnershipInvitedNotification;
}
