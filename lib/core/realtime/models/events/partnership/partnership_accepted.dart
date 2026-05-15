import 'package:freezed_annotation/freezed_annotation.dart';

part 'partnership_accepted.freezed.dart';
part 'partnership_accepted.g.dart';

/// Payload of the `partnership.accepted` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §10
@Freezed(toJson: false)
class PartnershipAcceptedData with _$PartnershipAcceptedData {
  const factory PartnershipAcceptedData({
    @JsonKey(name: 'partnership_id') required String partnershipId,
    @JsonKey(name: 'partner_name') String? partnerName,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
  }) = _PartnershipAcceptedData;

  factory PartnershipAcceptedData.fromJson(Map<String, dynamic> json) =>
      _$PartnershipAcceptedDataFromJson(json);
}

@Freezed(toJson: false)
class PartnershipAcceptedNotification with _$PartnershipAcceptedNotification {
  const factory PartnershipAcceptedNotification({
    required String event,
    String? channel,
    required PartnershipAcceptedData data,
    DateTime? receivedAt,
  }) = _PartnershipAcceptedNotification;
}
