import 'package:freezed_annotation/freezed_annotation.dart';

part 'payout_completed.freezed.dart';
part 'payout_completed.g.dart';

/// Payload of the `payout.completed` event (défini, pas encore émis).
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §12
@Freezed(toJson: false)
class PayoutCompletedData with _$PayoutCompletedData {
  const factory PayoutCompletedData({
    @JsonKey(name: 'organization_id') required int organizationId,
    required int amount,
    @JsonKey(name: 'payout_reference') String? payoutReference,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _PayoutCompletedData;

  factory PayoutCompletedData.fromJson(Map<String, dynamic> json) =>
      _$PayoutCompletedDataFromJson(json);
}

@Freezed(toJson: false)
class PayoutCompletedNotification with _$PayoutCompletedNotification {
  const factory PayoutCompletedNotification({
    required String event,
    String? channel,
    required PayoutCompletedData data,
    DateTime? receivedAt,
  }) = _PayoutCompletedNotification;
}
