// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_dto.freezed.dart';
part 'donation_dto.g.dart';

/// Représentation d'un don renvoyée par l'API (bloc `data`).
@freezed
class DonationDto with _$DonationDto {
  const factory DonationDto({
    required String uuid,
    String? source,
    double? amount,
    String? currency,
    String? status,
    @JsonKey(name: 'refunded_amount') double? refundedAmount,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'refunded_at') String? refundedAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _DonationDto;

  factory DonationDto.fromJson(Map<String, dynamic> json) =>
      _$DonationDtoFromJson(json);
}

/// Bloc `payment_sheet` prêt pour Stripe PaymentSheet (cf. §7.1).
@freezed
class DonationPaymentSheetDto with _$DonationPaymentSheetDto {
  const factory DonationPaymentSheetDto({
    @JsonKey(name: 'payment_intent_id') String? paymentIntentId,
    @JsonKey(name: 'client_secret') required String clientSecret,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'ephemeral_key') String? ephemeralKey,
    @JsonKey(name: 'publishable_key') String? publishableKey,
    @JsonKey(name: 'merchant_display_name') String? merchantDisplayName,
    double? amount,
    String? currency,
  }) = _DonationPaymentSheetDto;

  factory DonationPaymentSheetDto.fromJson(Map<String, dynamic> json) =>
      _$DonationPaymentSheetDtoFromJson(json);
}

/// Réponse `201` de `POST /v1/mobile/donations`.
///
/// L'enveloppe contient plusieurs clés de premier niveau (`data`,
/// `payment_intent`, `payment_sheet`) — on ne déballe donc pas via
/// `ApiResponseHandler.extractObject`, on mappe l'enveloppe entière.
@freezed
class CreateDonationResponseDto with _$CreateDonationResponseDto {
  const factory CreateDonationResponseDto({
    String? message,
    required DonationDto data,
    @JsonKey(name: 'payment_sheet') DonationPaymentSheetDto? paymentSheet,
  }) = _CreateDonationResponseDto;

  factory CreateDonationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateDonationResponseDtoFromJson(json);
}
