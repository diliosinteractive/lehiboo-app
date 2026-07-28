// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partnership_accepted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartnershipAcceptedData _$PartnershipAcceptedDataFromJson(
    Map<String, dynamic> json) {
  return _PartnershipAcceptedData.fromJson(json);
}

/// @nodoc
mixin _$PartnershipAcceptedData {
  @JsonKey(name: 'partnership_id')
  String get partnershipId => throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_name')
  String? get partnerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartnershipAcceptedDataCopyWith<PartnershipAcceptedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnershipAcceptedDataCopyWith<$Res> {
  factory $PartnershipAcceptedDataCopyWith(PartnershipAcceptedData value,
          $Res Function(PartnershipAcceptedData) then) =
      _$PartnershipAcceptedDataCopyWithImpl<$Res, PartnershipAcceptedData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'partnership_id') String partnershipId,
      @JsonKey(name: 'partner_name') String? partnerName,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt});
}

/// @nodoc
class _$PartnershipAcceptedDataCopyWithImpl<$Res,
        $Val extends PartnershipAcceptedData>
    implements $PartnershipAcceptedDataCopyWith<$Res> {
  _$PartnershipAcceptedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partnershipId = null,
    Object? partnerName = freezed,
    Object? acceptedAt = freezed,
  }) {
    return _then(_value.copyWith(
      partnershipId: null == partnershipId
          ? _value.partnershipId
          : partnershipId // ignore: cast_nullable_to_non_nullable
              as String,
      partnerName: freezed == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartnershipAcceptedDataImplCopyWith<$Res>
    implements $PartnershipAcceptedDataCopyWith<$Res> {
  factory _$$PartnershipAcceptedDataImplCopyWith(
          _$PartnershipAcceptedDataImpl value,
          $Res Function(_$PartnershipAcceptedDataImpl) then) =
      __$$PartnershipAcceptedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'partnership_id') String partnershipId,
      @JsonKey(name: 'partner_name') String? partnerName,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt});
}

/// @nodoc
class __$$PartnershipAcceptedDataImplCopyWithImpl<$Res>
    extends _$PartnershipAcceptedDataCopyWithImpl<$Res,
        _$PartnershipAcceptedDataImpl>
    implements _$$PartnershipAcceptedDataImplCopyWith<$Res> {
  __$$PartnershipAcceptedDataImplCopyWithImpl(
      _$PartnershipAcceptedDataImpl _value,
      $Res Function(_$PartnershipAcceptedDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partnershipId = null,
    Object? partnerName = freezed,
    Object? acceptedAt = freezed,
  }) {
    return _then(_$PartnershipAcceptedDataImpl(
      partnershipId: null == partnershipId
          ? _value.partnershipId
          : partnershipId // ignore: cast_nullable_to_non_nullable
              as String,
      partnerName: freezed == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PartnershipAcceptedDataImpl implements _PartnershipAcceptedData {
  const _$PartnershipAcceptedDataImpl(
      {@JsonKey(name: 'partnership_id') required this.partnershipId,
      @JsonKey(name: 'partner_name') this.partnerName,
      @JsonKey(name: 'accepted_at') this.acceptedAt});

  factory _$PartnershipAcceptedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartnershipAcceptedDataImplFromJson(json);

  @override
  @JsonKey(name: 'partnership_id')
  final String partnershipId;
  @override
  @JsonKey(name: 'partner_name')
  final String? partnerName;
  @override
  @JsonKey(name: 'accepted_at')
  final DateTime? acceptedAt;

  @override
  String toString() {
    return 'PartnershipAcceptedData(partnershipId: $partnershipId, partnerName: $partnerName, acceptedAt: $acceptedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnershipAcceptedDataImpl &&
            (identical(other.partnershipId, partnershipId) ||
                other.partnershipId == partnershipId) &&
            (identical(other.partnerName, partnerName) ||
                other.partnerName == partnerName) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, partnershipId, partnerName, acceptedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnershipAcceptedDataImplCopyWith<_$PartnershipAcceptedDataImpl>
      get copyWith => __$$PartnershipAcceptedDataImplCopyWithImpl<
          _$PartnershipAcceptedDataImpl>(this, _$identity);
}

abstract class _PartnershipAcceptedData implements PartnershipAcceptedData {
  const factory _PartnershipAcceptedData(
          {@JsonKey(name: 'partnership_id') required final String partnershipId,
          @JsonKey(name: 'partner_name') final String? partnerName,
          @JsonKey(name: 'accepted_at') final DateTime? acceptedAt}) =
      _$PartnershipAcceptedDataImpl;

  factory _PartnershipAcceptedData.fromJson(Map<String, dynamic> json) =
      _$PartnershipAcceptedDataImpl.fromJson;

  @override
  @JsonKey(name: 'partnership_id')
  String get partnershipId;
  @override
  @JsonKey(name: 'partner_name')
  String? get partnerName;
  @override
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt;
  @override
  @JsonKey(ignore: true)
  _$$PartnershipAcceptedDataImplCopyWith<_$PartnershipAcceptedDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PartnershipAcceptedNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  PartnershipAcceptedData get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartnershipAcceptedNotificationCopyWith<PartnershipAcceptedNotification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnershipAcceptedNotificationCopyWith<$Res> {
  factory $PartnershipAcceptedNotificationCopyWith(
          PartnershipAcceptedNotification value,
          $Res Function(PartnershipAcceptedNotification) then) =
      _$PartnershipAcceptedNotificationCopyWithImpl<$Res,
          PartnershipAcceptedNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      PartnershipAcceptedData data,
      DateTime? receivedAt});

  $PartnershipAcceptedDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PartnershipAcceptedNotificationCopyWithImpl<$Res,
        $Val extends PartnershipAcceptedNotification>
    implements $PartnershipAcceptedNotificationCopyWith<$Res> {
  _$PartnershipAcceptedNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PartnershipAcceptedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PartnershipAcceptedDataCopyWith<$Res> get data {
    return $PartnershipAcceptedDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartnershipAcceptedNotificationImplCopyWith<$Res>
    implements $PartnershipAcceptedNotificationCopyWith<$Res> {
  factory _$$PartnershipAcceptedNotificationImplCopyWith(
          _$PartnershipAcceptedNotificationImpl value,
          $Res Function(_$PartnershipAcceptedNotificationImpl) then) =
      __$$PartnershipAcceptedNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      PartnershipAcceptedData data,
      DateTime? receivedAt});

  @override
  $PartnershipAcceptedDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PartnershipAcceptedNotificationImplCopyWithImpl<$Res>
    extends _$PartnershipAcceptedNotificationCopyWithImpl<$Res,
        _$PartnershipAcceptedNotificationImpl>
    implements _$$PartnershipAcceptedNotificationImplCopyWith<$Res> {
  __$$PartnershipAcceptedNotificationImplCopyWithImpl(
      _$PartnershipAcceptedNotificationImpl _value,
      $Res Function(_$PartnershipAcceptedNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$PartnershipAcceptedNotificationImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PartnershipAcceptedData,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$PartnershipAcceptedNotificationImpl
    implements _PartnershipAcceptedNotification {
  const _$PartnershipAcceptedNotificationImpl(
      {required this.event, this.channel, required this.data, this.receivedAt});

  @override
  final String event;
  @override
  final String? channel;
  @override
  final PartnershipAcceptedData data;
  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'PartnershipAcceptedNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnershipAcceptedNotificationImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, event, channel, data, receivedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnershipAcceptedNotificationImplCopyWith<
          _$PartnershipAcceptedNotificationImpl>
      get copyWith => __$$PartnershipAcceptedNotificationImplCopyWithImpl<
          _$PartnershipAcceptedNotificationImpl>(this, _$identity);
}

abstract class _PartnershipAcceptedNotification
    implements PartnershipAcceptedNotification {
  const factory _PartnershipAcceptedNotification(
      {required final String event,
      final String? channel,
      required final PartnershipAcceptedData data,
      final DateTime? receivedAt}) = _$PartnershipAcceptedNotificationImpl;

  @override
  String get event;
  @override
  String? get channel;
  @override
  PartnershipAcceptedData get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$PartnershipAcceptedNotificationImplCopyWith<
          _$PartnershipAcceptedNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
