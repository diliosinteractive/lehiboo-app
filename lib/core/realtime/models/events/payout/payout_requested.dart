import 'package:freezed_annotation/freezed_annotation.dart';

part 'payout_requested.freezed.dart';
part 'payout_requested.g.dart';

/// Payload of the `payout.requested` event (défini, pas encore émis).
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §12
@Freezed(toJson: false)
class PayoutRequestedData with _$PayoutRequestedData {
  const factory PayoutRequestedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    required int amount,
    @JsonKey(name: 'payout_reference') String? payoutReference,
    @JsonKey(name: 'requested_at') DateTime? requestedAt,
  }) = _PayoutRequestedData;

  factory PayoutRequestedData.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestedDataFromJson(json);
}

@Freezed(toJson: false)
class PayoutRequestedNotification with _$PayoutRequestedNotification {
  const factory PayoutRequestedNotification({
    required String event,
    String? channel,
    required PayoutRequestedData data,
    DateTime? receivedAt,
  }) = _PayoutRequestedNotification;
}
