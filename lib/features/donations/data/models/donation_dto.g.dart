// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DonationDtoImpl _$$DonationDtoImplFromJson(Map<String, dynamic> json) =>
    _$DonationDtoImpl(
      uuid: json['uuid'] as String,
      source: json['source'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      refundedAmount: (json['refunded_amount'] as num?)?.toDouble(),
      paidAt: json['paid_at'] as String?,
      refundedAt: json['refunded_at'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$DonationDtoImplToJson(_$DonationDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'source': instance.source,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'refunded_amount': instance.refundedAmount,
      'paid_at': instance.paidAt,
      'refunded_at': instance.refundedAt,
      'created_at': instance.createdAt,
    };

_$DonationPaymentSheetDtoImpl _$$DonationPaymentSheetDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DonationPaymentSheetDtoImpl(
      paymentIntentId: json['payment_intent_id'] as String?,
      clientSecret: json['client_secret'] as String,
      customerId: json['customer_id'] as String?,
      ephemeralKey: json['ephemeral_key'] as String?,
      publishableKey: json['publishable_key'] as String?,
      merchantDisplayName: json['merchant_display_name'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$$DonationPaymentSheetDtoImplToJson(
        _$DonationPaymentSheetDtoImpl instance) =>
    <String, dynamic>{
      'payment_intent_id': instance.paymentIntentId,
      'client_secret': instance.clientSecret,
      'customer_id': instance.customerId,
      'ephemeral_key': instance.ephemeralKey,
      'publishable_key': instance.publishableKey,
      'merchant_display_name': instance.merchantDisplayName,
      'amount': instance.amount,
      'currency': instance.currency,
    };

_$CreateDonationResponseDtoImpl _$$CreateDonationResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateDonationResponseDtoImpl(
      message: json['message'] as String?,
      data: DonationDto.fromJson(json['data'] as Map<String, dynamic>),
      paymentSheet: json['payment_sheet'] == null
          ? null
          : DonationPaymentSheetDto.fromJson(
              json['payment_sheet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreateDonationResponseDtoImplToJson(
        _$CreateDonationResponseDtoImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'payment_sheet': instance.paymentSheet,
    };
