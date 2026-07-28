// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ws_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WSNotification {
  String get event => throw _privateConstructorUsedError;
  String? get channel => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WSNotificationCopyWith<WSNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WSNotificationCopyWith<$Res> {
  factory $WSNotificationCopyWith(
          WSNotification value, $Res Function(WSNotification) then) =
      _$WSNotificationCopyWithImpl<$Res, WSNotification>;
  @useResult
  $Res call(
      {String event,
      String? channel,
      Map<String, dynamic> data,
      DateTime? receivedAt});
}

/// @nodoc
class _$WSNotificationCopyWithImpl<$Res, $Val extends WSNotification>
    implements $WSNotificationCopyWith<$Res> {
  _$WSNotificationCopyWithImpl(this._value, this._then);

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
              as Map<String, dynamic>,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WSNotificationImplCopyWith<$Res>
    implements $WSNotificationCopyWith<$Res> {
  factory _$$WSNotificationImplCopyWith(_$WSNotificationImpl value,
          $Res Function(_$WSNotificationImpl) then) =
      __$$WSNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String? channel,
      Map<String, dynamic> data,
      DateTime? receivedAt});
}

/// @nodoc
class __$$WSNotificationImplCopyWithImpl<$Res>
    extends _$WSNotificationCopyWithImpl<$Res, _$WSNotificationImpl>
    implements _$$WSNotificationImplCopyWith<$Res> {
  __$$WSNotificationImplCopyWithImpl(
      _$WSNotificationImpl _value, $Res Function(_$WSNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? channel = freezed,
    Object? data = null,
    Object? receivedAt = freezed,
  }) {
    return _then(_$WSNotificationImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$WSNotificationImpl extends _WSNotification {
  const _$WSNotificationImpl(
      {required this.event,
      this.channel,
      final Map<String, dynamic> data = const <String, dynamic>{},
      this.receivedAt})
      : _data = data,
        super._();

  @override
  final String event;
  @override
  final String? channel;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime? receivedAt;

  @override
  String toString() {
    return 'WSNotification(event: $event, channel: $channel, data: $data, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WSNotificationImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event, channel,
      const DeepCollectionEquality().hash(_data), receivedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WSNotificationImplCopyWith<_$WSNotificationImpl> get copyWith =>
      __$$WSNotificationImplCopyWithImpl<_$WSNotificationImpl>(
          this, _$identity);
}

abstract class _WSNotification extends WSNotification {
  const factory _WSNotification(
      {required final String event,
      final String? channel,
      final Map<String, dynamic> data,
      final DateTime? receivedAt}) = _$WSNotificationImpl;
  const _WSNotification._() : super._();

  @override
  String get event;
  @override
  String? get channel;
  @override
  Map<String, dynamic> get data;
  @override
  DateTime? get receivedAt;
  @override
  @JsonKey(ignore: true)
  _$$WSNotificationImplCopyWith<_$WSNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
