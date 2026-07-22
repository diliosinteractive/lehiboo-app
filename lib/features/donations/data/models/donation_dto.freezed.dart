// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DonationDto _$DonationDtoFromJson(Map<String, dynamic> json) {
  return _DonationDto.fromJson(json);
}

/// @nodoc
mixin _$DonationDto {
  String get uuid => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'refunded_amount')
  double? get refundedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  String? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'refunded_at')
  String? get refundedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DonationDtoCopyWith<DonationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DonationDtoCopyWith<$Res> {
  factory $DonationDtoCopyWith(
          DonationDto value, $Res Function(DonationDto) then) =
      _$DonationDtoCopyWithImpl<$Res, DonationDto>;
  @useResult
  $Res call(
      {String uuid,
      String? source,
      double? amount,
      String? currency,
      String? status,
      @JsonKey(name: 'refunded_amount') double? refundedAmount,
      @JsonKey(name: 'paid_at') String? paidAt,
      @JsonKey(name: 'refunded_at') String? refundedAt,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$DonationDtoCopyWithImpl<$Res, $Val extends DonationDto>
    implements $DonationDtoCopyWith<$Res> {
  _$DonationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? source = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? status = freezed,
    Object? refundedAmount = freezed,
    Object? paidAt = freezed,
    Object? refundedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      refundedAmount: freezed == refundedAmount
          ? _value.refundedAmount
          : refundedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as String?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DonationDtoImplCopyWith<$Res>
    implements $DonationDtoCopyWith<$Res> {
  factory _$$DonationDtoImplCopyWith(
          _$DonationDtoImpl value, $Res Function(_$DonationDtoImpl) then) =
      __$$DonationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String? source,
      double? amount,
      String? currency,
      String? status,
      @JsonKey(name: 'refunded_amount') double? refundedAmount,
      @JsonKey(name: 'paid_at') String? paidAt,
      @JsonKey(name: 'refunded_at') String? refundedAt,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$DonationDtoImplCopyWithImpl<$Res>
    extends _$DonationDtoCopyWithImpl<$Res, _$DonationDtoImpl>
    implements _$$DonationDtoImplCopyWith<$Res> {
  __$$DonationDtoImplCopyWithImpl(
      _$DonationDtoImpl _value, $Res Function(_$DonationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? source = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? status = freezed,
    Object? refundedAmount = freezed,
    Object? paidAt = freezed,
    Object? refundedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$DonationDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      refundedAmount: freezed == refundedAmount
          ? _value.refundedAmount
          : refundedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as String?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DonationDtoImpl implements _DonationDto {
  const _$DonationDtoImpl(
      {required this.uuid,
      this.source,
      this.amount,
      this.currency,
      this.status,
      @JsonKey(name: 'refunded_amount') this.refundedAmount,
      @JsonKey(name: 'paid_at') this.paidAt,
      @JsonKey(name: 'refunded_at') this.refundedAt,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$DonationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DonationDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  final String? source;
  @override
  final double? amount;
  @override
  final String? currency;
  @override
  final String? status;
  @override
  @JsonKey(name: 'refunded_amount')
  final double? refundedAmount;
  @override
  @JsonKey(name: 'paid_at')
  final String? paidAt;
  @override
  @JsonKey(name: 'refunded_at')
  final String? refundedAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'DonationDto(uuid: $uuid, source: $source, amount: $amount, currency: $currency, status: $status, refundedAmount: $refundedAmount, paidAt: $paidAt, refundedAt: $refundedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DonationDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.refundedAmount, refundedAmount) ||
                other.refundedAmount == refundedAmount) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, source, amount, currency,
      status, refundedAmount, paidAt, refundedAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DonationDtoImplCopyWith<_$DonationDtoImpl> get copyWith =>
      __$$DonationDtoImplCopyWithImpl<_$DonationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DonationDtoImplToJson(
      this,
    );
  }
}

abstract class _DonationDto implements DonationDto {
  const factory _DonationDto(
          {required final String uuid,
          final String? source,
          final double? amount,
          final String? currency,
          final String? status,
          @JsonKey(name: 'refunded_amount') final double? refundedAmount,
          @JsonKey(name: 'paid_at') final String? paidAt,
          @JsonKey(name: 'refunded_at') final String? refundedAt,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$DonationDtoImpl;

  factory _DonationDto.fromJson(Map<String, dynamic> json) =
      _$DonationDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  String? get source;
  @override
  double? get amount;
  @override
  String? get currency;
  @override
  String? get status;
  @override
  @JsonKey(name: 'refunded_amount')
  double? get refundedAmount;
  @override
  @JsonKey(name: 'paid_at')
  String? get paidAt;
  @override
  @JsonKey(name: 'refunded_at')
  String? get refundedAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$DonationDtoImplCopyWith<_$DonationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DonationPaymentSheetDto _$DonationPaymentSheetDtoFromJson(
    Map<String, dynamic> json) {
  return _DonationPaymentSheetDto.fromJson(json);
}

/// @nodoc
mixin _$DonationPaymentSheetDto {
  @JsonKey(name: 'payment_intent_id')
  String? get paymentIntentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_secret')
  String get clientSecret => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ephemeral_key')
  String? get ephemeralKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'publishable_key')
  String? get publishableKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_display_name')
  String? get merchantDisplayName => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DonationPaymentSheetDtoCopyWith<DonationPaymentSheetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DonationPaymentSheetDtoCopyWith<$Res> {
  factory $DonationPaymentSheetDtoCopyWith(DonationPaymentSheetDto value,
          $Res Function(DonationPaymentSheetDto) then) =
      _$DonationPaymentSheetDtoCopyWithImpl<$Res, DonationPaymentSheetDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_intent_id') String? paymentIntentId,
      @JsonKey(name: 'client_secret') String clientSecret,
      @JsonKey(name: 'customer_id') String? customerId,
      @JsonKey(name: 'ephemeral_key') String? ephemeralKey,
      @JsonKey(name: 'publishable_key') String? publishableKey,
      @JsonKey(name: 'merchant_display_name') String? merchantDisplayName,
      double? amount,
      String? currency});
}

/// @nodoc
class _$DonationPaymentSheetDtoCopyWithImpl<$Res,
        $Val extends DonationPaymentSheetDto>
    implements $DonationPaymentSheetDtoCopyWith<$Res> {
  _$DonationPaymentSheetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentIntentId = freezed,
    Object? clientSecret = null,
    Object? customerId = freezed,
    Object? ephemeralKey = freezed,
    Object? publishableKey = freezed,
    Object? merchantDisplayName = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      ephemeralKey: freezed == ephemeralKey
          ? _value.ephemeralKey
          : ephemeralKey // ignore: cast_nullable_to_non_nullable
              as String?,
      publishableKey: freezed == publishableKey
          ? _value.publishableKey
          : publishableKey // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantDisplayName: freezed == merchantDisplayName
          ? _value.merchantDisplayName
          : merchantDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DonationPaymentSheetDtoImplCopyWith<$Res>
    implements $DonationPaymentSheetDtoCopyWith<$Res> {
  factory _$$DonationPaymentSheetDtoImplCopyWith(
          _$DonationPaymentSheetDtoImpl value,
          $Res Function(_$DonationPaymentSheetDtoImpl) then) =
      __$$DonationPaymentSheetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_intent_id') String? paymentIntentId,
      @JsonKey(name: 'client_secret') String clientSecret,
      @JsonKey(name: 'customer_id') String? customerId,
      @JsonKey(name: 'ephemeral_key') String? ephemeralKey,
      @JsonKey(name: 'publishable_key') String? publishableKey,
      @JsonKey(name: 'merchant_display_name') String? merchantDisplayName,
      double? amount,
      String? currency});
}

/// @nodoc
class __$$DonationPaymentSheetDtoImplCopyWithImpl<$Res>
    extends _$DonationPaymentSheetDtoCopyWithImpl<$Res,
        _$DonationPaymentSheetDtoImpl>
    implements _$$DonationPaymentSheetDtoImplCopyWith<$Res> {
  __$$DonationPaymentSheetDtoImplCopyWithImpl(
      _$DonationPaymentSheetDtoImpl _value,
      $Res Function(_$DonationPaymentSheetDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentIntentId = freezed,
    Object? clientSecret = null,
    Object? customerId = freezed,
    Object? ephemeralKey = freezed,
    Object? publishableKey = freezed,
    Object? merchantDisplayName = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$DonationPaymentSheetDtoImpl(
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      ephemeralKey: freezed == ephemeralKey
          ? _value.ephemeralKey
          : ephemeralKey // ignore: cast_nullable_to_non_nullable
              as String?,
      publishableKey: freezed == publishableKey
          ? _value.publishableKey
          : publishableKey // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantDisplayName: freezed == merchantDisplayName
          ? _value.merchantDisplayName
          : merchantDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DonationPaymentSheetDtoImpl implements _DonationPaymentSheetDto {
  const _$DonationPaymentSheetDtoImpl(
      {@JsonKey(name: 'payment_intent_id') this.paymentIntentId,
      @JsonKey(name: 'client_secret') required this.clientSecret,
      @JsonKey(name: 'customer_id') this.customerId,
      @JsonKey(name: 'ephemeral_key') this.ephemeralKey,
      @JsonKey(name: 'publishable_key') this.publishableKey,
      @JsonKey(name: 'merchant_display_name') this.merchantDisplayName,
      this.amount,
      this.currency});

  factory _$DonationPaymentSheetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DonationPaymentSheetDtoImplFromJson(json);

  @override
  @JsonKey(name: 'payment_intent_id')
  final String? paymentIntentId;
  @override
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @override
  @JsonKey(name: 'customer_id')
  final String? customerId;
  @override
  @JsonKey(name: 'ephemeral_key')
  final String? ephemeralKey;
  @override
  @JsonKey(name: 'publishable_key')
  final String? publishableKey;
  @override
  @JsonKey(name: 'merchant_display_name')
  final String? merchantDisplayName;
  @override
  final double? amount;
  @override
  final String? currency;

  @override
  String toString() {
    return 'DonationPaymentSheetDto(paymentIntentId: $paymentIntentId, clientSecret: $clientSecret, customerId: $customerId, ephemeralKey: $ephemeralKey, publishableKey: $publishableKey, merchantDisplayName: $merchantDisplayName, amount: $amount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DonationPaymentSheetDtoImpl &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.ephemeralKey, ephemeralKey) ||
                other.ephemeralKey == ephemeralKey) &&
            (identical(other.publishableKey, publishableKey) ||
                other.publishableKey == publishableKey) &&
            (identical(other.merchantDisplayName, merchantDisplayName) ||
                other.merchantDisplayName == merchantDisplayName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      paymentIntentId,
      clientSecret,
      customerId,
      ephemeralKey,
      publishableKey,
      merchantDisplayName,
      amount,
      currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DonationPaymentSheetDtoImplCopyWith<_$DonationPaymentSheetDtoImpl>
      get copyWith => __$$DonationPaymentSheetDtoImplCopyWithImpl<
          _$DonationPaymentSheetDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DonationPaymentSheetDtoImplToJson(
      this,
    );
  }
}

abstract class _DonationPaymentSheetDto implements DonationPaymentSheetDto {
  const factory _DonationPaymentSheetDto(
      {@JsonKey(name: 'payment_intent_id') final String? paymentIntentId,
      @JsonKey(name: 'client_secret') required final String clientSecret,
      @JsonKey(name: 'customer_id') final String? customerId,
      @JsonKey(name: 'ephemeral_key') final String? ephemeralKey,
      @JsonKey(name: 'publishable_key') final String? publishableKey,
      @JsonKey(name: 'merchant_display_name') final String? merchantDisplayName,
      final double? amount,
      final String? currency}) = _$DonationPaymentSheetDtoImpl;

  factory _DonationPaymentSheetDto.fromJson(Map<String, dynamic> json) =
      _$DonationPaymentSheetDtoImpl.fromJson;

  @override
  @JsonKey(name: 'payment_intent_id')
  String? get paymentIntentId;
  @override
  @JsonKey(name: 'client_secret')
  String get clientSecret;
  @override
  @JsonKey(name: 'customer_id')
  String? get customerId;
  @override
  @JsonKey(name: 'ephemeral_key')
  String? get ephemeralKey;
  @override
  @JsonKey(name: 'publishable_key')
  String? get publishableKey;
  @override
  @JsonKey(name: 'merchant_display_name')
  String? get merchantDisplayName;
  @override
  double? get amount;
  @override
  String? get currency;
  @override
  @JsonKey(ignore: true)
  _$$DonationPaymentSheetDtoImplCopyWith<_$DonationPaymentSheetDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateDonationResponseDto _$CreateDonationResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateDonationResponseDto.fromJson(json);
}

/// @nodoc
mixin _$CreateDonationResponseDto {
  String? get message => throw _privateConstructorUsedError;
  DonationDto get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_sheet')
  DonationPaymentSheetDto? get paymentSheet =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateDonationResponseDtoCopyWith<CreateDonationResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDonationResponseDtoCopyWith<$Res> {
  factory $CreateDonationResponseDtoCopyWith(CreateDonationResponseDto value,
          $Res Function(CreateDonationResponseDto) then) =
      _$CreateDonationResponseDtoCopyWithImpl<$Res, CreateDonationResponseDto>;
  @useResult
  $Res call(
      {String? message,
      DonationDto data,
      @JsonKey(name: 'payment_sheet') DonationPaymentSheetDto? paymentSheet});

  $DonationDtoCopyWith<$Res> get data;
  $DonationPaymentSheetDtoCopyWith<$Res>? get paymentSheet;
}

/// @nodoc
class _$CreateDonationResponseDtoCopyWithImpl<$Res,
        $Val extends CreateDonationResponseDto>
    implements $CreateDonationResponseDtoCopyWith<$Res> {
  _$CreateDonationResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? data = null,
    Object? paymentSheet = freezed,
  }) {
    return _then(_value.copyWith(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DonationDto,
      paymentSheet: freezed == paymentSheet
          ? _value.paymentSheet
          : paymentSheet // ignore: cast_nullable_to_non_nullable
              as DonationPaymentSheetDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DonationDtoCopyWith<$Res> get data {
    return $DonationDtoCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DonationPaymentSheetDtoCopyWith<$Res>? get paymentSheet {
    if (_value.paymentSheet == null) {
      return null;
    }

    return $DonationPaymentSheetDtoCopyWith<$Res>(_value.paymentSheet!,
        (value) {
      return _then(_value.copyWith(paymentSheet: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateDonationResponseDtoImplCopyWith<$Res>
    implements $CreateDonationResponseDtoCopyWith<$Res> {
  factory _$$CreateDonationResponseDtoImplCopyWith(
          _$CreateDonationResponseDtoImpl value,
          $Res Function(_$CreateDonationResponseDtoImpl) then) =
      __$$CreateDonationResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? message,
      DonationDto data,
      @JsonKey(name: 'payment_sheet') DonationPaymentSheetDto? paymentSheet});

  @override
  $DonationDtoCopyWith<$Res> get data;
  @override
  $DonationPaymentSheetDtoCopyWith<$Res>? get paymentSheet;
}

/// @nodoc
class __$$CreateDonationResponseDtoImplCopyWithImpl<$Res>
    extends _$CreateDonationResponseDtoCopyWithImpl<$Res,
        _$CreateDonationResponseDtoImpl>
    implements _$$CreateDonationResponseDtoImplCopyWith<$Res> {
  __$$CreateDonationResponseDtoImplCopyWithImpl(
      _$CreateDonationResponseDtoImpl _value,
      $Res Function(_$CreateDonationResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? data = null,
    Object? paymentSheet = freezed,
  }) {
    return _then(_$CreateDonationResponseDtoImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DonationDto,
      paymentSheet: freezed == paymentSheet
          ? _value.paymentSheet
          : paymentSheet // ignore: cast_nullable_to_non_nullable
              as DonationPaymentSheetDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateDonationResponseDtoImpl implements _CreateDonationResponseDto {
  const _$CreateDonationResponseDtoImpl(
      {this.message,
      required this.data,
      @JsonKey(name: 'payment_sheet') this.paymentSheet});

  factory _$CreateDonationResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateDonationResponseDtoImplFromJson(json);

  @override
  final String? message;
  @override
  final DonationDto data;
  @override
  @JsonKey(name: 'payment_sheet')
  final DonationPaymentSheetDto? paymentSheet;

  @override
  String toString() {
    return 'CreateDonationResponseDto(message: $message, data: $data, paymentSheet: $paymentSheet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDonationResponseDtoImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.paymentSheet, paymentSheet) ||
                other.paymentSheet == paymentSheet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, data, paymentSheet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDonationResponseDtoImplCopyWith<_$CreateDonationResponseDtoImpl>
      get copyWith => __$$CreateDonationResponseDtoImplCopyWithImpl<
          _$CreateDonationResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateDonationResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateDonationResponseDto implements CreateDonationResponseDto {
  const factory _CreateDonationResponseDto(
          {final String? message,
          required final DonationDto data,
          @JsonKey(name: 'payment_sheet')
          final DonationPaymentSheetDto? paymentSheet}) =
      _$CreateDonationResponseDtoImpl;

  factory _CreateDonationResponseDto.fromJson(Map<String, dynamic> json) =
      _$CreateDonationResponseDtoImpl.fromJson;

  @override
  String? get message;
  @override
  DonationDto get data;
  @override
  @JsonKey(name: 'payment_sheet')
  DonationPaymentSheetDto? get paymentSheet;
  @override
  @JsonKey(ignore: true)
  _$$CreateDonationResponseDtoImplCopyWith<_$CreateDonationResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
