import 'package:freezed_annotation/freezed_annotation.dart';

part 'payout_cancelled.freezed.dart';
part 'payout_cancelled.g.dart';

/// Payload of the `payout.cancelled` event (défini, pas encore émis).
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §12
@Freezed(toJson: false)
class PayoutCancelledData with _$PayoutCancelledData {
  const factory PayoutCancelledData({
    @JsonKey(name: 'organization_id') required int organizationId,
    required int amount,
    @JsonKey(name: 'payout_reference') String? payoutReference,
    String? reason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
  }) = _PayoutCancelledData;

  factory PayoutCancelledData.fromJson(Map<String, dynamic> json) =>
      _$PayoutCancelledDataFromJson(json);
}

@Freezed(toJson: false)
class PayoutCancelledNotification with _$PayoutCancelledNotification {
  const factory PayoutCancelledNotification({
    required String event,
    String? channel,
    required PayoutCancelledData data,
    DateTime? receivedAt,
  }) = _PayoutCancelledNotification;
}
