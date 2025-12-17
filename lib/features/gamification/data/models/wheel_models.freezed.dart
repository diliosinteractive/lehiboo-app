// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wheel_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WheelSegment _$WheelSegmentFromJson(Map<String, dynamic> json) {
  return _WheelSegment.fromJson(json);
}

/// @nodoc
mixin _$WheelSegment {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // hibons, multiplier, badge, jackpot
  int get value =>
      throw _privateConstructorUsedError; // Amount of hibons or multiplier value (e.g. 15 for 1.5x)
  double get probability => throw _privateConstructorUsedError;
  int get colorInt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WheelSegmentCopyWith<WheelSegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WheelSegmentCopyWith<$Res> {
  factory $WheelSegmentCopyWith(
          WheelSegment value, $Res Function(WheelSegment) then) =
      _$WheelSegmentCopyWithImpl<$Res, WheelSegment>;
  @useResult
  $Res call(
      {String id,
      String label,
      String type,
      int value,
      double probability,
      int colorInt});
}

/// @nodoc
class _$WheelSegmentCopyWithImpl<$Res, $Val extends WheelSegment>
    implements $WheelSegmentCopyWith<$Res> {
  _$WheelSegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? type = null,
    Object? value = null,
    Object? probability = null,
    Object? colorInt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as double,
      colorInt: null == colorInt
          ? _value.colorInt
          : colorInt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WheelSegmentImplCopyWith<$Res>
    implements $WheelSegmentCopyWith<$Res> {
  factory _$$WheelSegmentImplCopyWith(
          _$WheelSegmentImpl value, $Res Function(_$WheelSegmentImpl) then) =
      __$$WheelSegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String label,
      String type,
      int value,
      double probability,
      int colorInt});
}

/// @nodoc
class __$$WheelSegmentImplCopyWithImpl<$Res>
    extends _$WheelSegmentCopyWithImpl<$Res, _$WheelSegmentImpl>
    implements _$$WheelSegmentImplCopyWith<$Res> {
  __$$WheelSegmentImplCopyWithImpl(
      _$WheelSegmentImpl _value, $Res Function(_$WheelSegmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? type = null,
    Object? value = null,
    Object? probability = null,
    Object? colorInt = null,
  }) {
    return _then(_$WheelSegmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as double,
      colorInt: null == colorInt
          ? _value.colorInt
          : colorInt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WheelSegmentImpl implements _WheelSegment {
  const _$WheelSegmentImpl(
      {required this.id,
      required this.label,
      required this.type,
      required this.value,
      required this.probability,
      this.colorInt = 0xFFFFFFFF});

  factory _$WheelSegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$WheelSegmentImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String type;
// hibons, multiplier, badge, jackpot
  @override
  final int value;
// Amount of hibons or multiplier value (e.g. 15 for 1.5x)
  @override
  final double probability;
  @override
  @JsonKey()
  final int colorInt;

  @override
  String toString() {
    return 'WheelSegment(id: $id, label: $label, type: $type, value: $value, probability: $probability, colorInt: $colorInt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WheelSegmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.probability, probability) ||
                other.probability == probability) &&
            (identical(other.colorInt, colorInt) ||
                other.colorInt == colorInt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, label, type, value, probability, colorInt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WheelSegmentImplCopyWith<_$WheelSegmentImpl> get copyWith =>
      __$$WheelSegmentImplCopyWithImpl<_$WheelSegmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WheelSegmentImplToJson(
      this,
    );
  }
}

abstract class _WheelSegment implements WheelSegment {
  const factory _WheelSegment(
      {required final String id,
      required final String label,
      required final String type,
      required final int value,
      required final double probability,
      final int colorInt}) = _$WheelSegmentImpl;

  factory _WheelSegment.fromJson(Map<String, dynamic> json) =
      _$WheelSegmentImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get type;
  @override // hibons, multiplier, badge, jackpot
  int get value;
  @override // Amount of hibons or multiplier value (e.g. 15 for 1.5x)
  double get probability;
  @override
  int get colorInt;
  @override
  @JsonKey(ignore: true)
  _$$WheelSegmentImplCopyWith<_$WheelSegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WheelConfig _$WheelConfigFromJson(Map<String, dynamic> json) {
  return _WheelConfig.fromJson(json);
}

/// @nodoc
mixin _$WheelConfig {
  List<WheelSegment> get segments => throw _privateConstructorUsedError;
  int get costPerSpin => throw _privateConstructorUsedError;
  bool get isFreeSpinAvailable => throw _privateConstructorUsedError;
  DateTime? get nextFreeSpinDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WheelConfigCopyWith<WheelConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WheelConfigCopyWith<$Res> {
  factory $WheelConfigCopyWith(
          WheelConfig value, $Res Function(WheelConfig) then) =
      _$WheelConfigCopyWithImpl<$Res, WheelConfig>;
  @useResult
  $Res call(
      {List<WheelSegment> segments,
      int costPerSpin,
      bool isFreeSpinAvailable,
      DateTime? nextFreeSpinDate});
}

/// @nodoc
class _$WheelConfigCopyWithImpl<$Res, $Val extends WheelConfig>
    implements $WheelConfigCopyWith<$Res> {
  _$WheelConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segments = null,
    Object? costPerSpin = null,
    Object? isFreeSpinAvailable = null,
    Object? nextFreeSpinDate = freezed,
  }) {
    return _then(_value.copyWith(
      segments: null == segments
          ? _value.segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<WheelSegment>,
      costPerSpin: null == costPerSpin
          ? _value.costPerSpin
          : costPerSpin // ignore: cast_nullable_to_non_nullable
              as int,
      isFreeSpinAvailable: null == isFreeSpinAvailable
          ? _value.isFreeSpinAvailable
          : isFreeSpinAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      nextFreeSpinDate: freezed == nextFreeSpinDate
          ? _value.nextFreeSpinDate
          : nextFreeSpinDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WheelConfigImplCopyWith<$Res>
    implements $WheelConfigCopyWith<$Res> {
  factory _$$WheelConfigImplCopyWith(
          _$WheelConfigImpl value, $Res Function(_$WheelConfigImpl) then) =
      __$$WheelConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WheelSegment> segments,
      int costPerSpin,
      bool isFreeSpinAvailable,
      DateTime? nextFreeSpinDate});
}

/// @nodoc
class __$$WheelConfigImplCopyWithImpl<$Res>
    extends _$WheelConfigCopyWithImpl<$Res, _$WheelConfigImpl>
    implements _$$WheelConfigImplCopyWith<$Res> {
  __$$WheelConfigImplCopyWithImpl(
      _$WheelConfigImpl _value, $Res Function(_$WheelConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segments = null,
    Object? costPerSpin = null,
    Object? isFreeSpinAvailable = null,
    Object? nextFreeSpinDate = freezed,
  }) {
    return _then(_$WheelConfigImpl(
      segments: null == segments
          ? _value._segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<WheelSegment>,
      costPerSpin: null == costPerSpin
          ? _value.costPerSpin
          : costPerSpin // ignore: cast_nullable_to_non_nullable
              as int,
      isFreeSpinAvailable: null == isFreeSpinAvailable
          ? _value.isFreeSpinAvailable
          : isFreeSpinAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      nextFreeSpinDate: freezed == nextFreeSpinDate
          ? _value.nextFreeSpinDate
          : nextFreeSpinDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WheelConfigImpl implements _WheelConfig {
  const _$WheelConfigImpl(
      {required final List<WheelSegment> segments,
      required this.costPerSpin,
      required this.isFreeSpinAvailable,
      this.nextFreeSpinDate})
      : _segments = segments;

  factory _$WheelConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WheelConfigImplFromJson(json);

  final List<WheelSegment> _segments;
  @override
  List<WheelSegment> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  @override
  final int costPerSpin;
  @override
  final bool isFreeSpinAvailable;
  @override
  final DateTime? nextFreeSpinDate;

  @override
  String toString() {
    return 'WheelConfig(segments: $segments, costPerSpin: $costPerSpin, isFreeSpinAvailable: $isFreeSpinAvailable, nextFreeSpinDate: $nextFreeSpinDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WheelConfigImpl &&
            const DeepCollectionEquality().equals(other._segments, _segments) &&
            (identical(other.costPerSpin, costPerSpin) ||
                other.costPerSpin == costPerSpin) &&
            (identical(other.isFreeSpinAvailable, isFreeSpinAvailable) ||
                other.isFreeSpinAvailable == isFreeSpinAvailable) &&
            (identical(other.nextFreeSpinDate, nextFreeSpinDate) ||
                other.nextFreeSpinDate == nextFreeSpinDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_segments),
      costPerSpin,
      isFreeSpinAvailable,
      nextFreeSpinDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WheelConfigImplCopyWith<_$WheelConfigImpl> get copyWith =>
      __$$WheelConfigImplCopyWithImpl<_$WheelConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WheelConfigImplToJson(
      this,
    );
  }
}

abstract class _WheelConfig implements WheelConfig {
  const factory _WheelConfig(
      {required final List<WheelSegment> segments,
      required final int costPerSpin,
      required final bool isFreeSpinAvailable,
      final DateTime? nextFreeSpinDate}) = _$WheelConfigImpl;

  factory _WheelConfig.fromJson(Map<String, dynamic> json) =
      _$WheelConfigImpl.fromJson;

  @override
  List<WheelSegment> get segments;
  @override
  int get costPerSpin;
  @override
  bool get isFreeSpinAvailable;
  @override
  DateTime? get nextFreeSpinDate;
  @override
  @JsonKey(ignore: true)
  _$$WheelConfigImplCopyWith<_$WheelConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WheelSpinResult _$WheelSpinResultFromJson(Map<String, dynamic> json) {
  return _WheelSpinResult.fromJson(json);
}

/// @nodoc
mixin _$WheelSpinResult {
  WheelSegment get segment => throw _privateConstructorUsedError;
  int get earnedHibons =>
      throw _privateConstructorUsedError; // Calculated value
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WheelSpinResultCopyWith<WheelSpinResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WheelSpinResultCopyWith<$Res> {
  factory $WheelSpinResultCopyWith(
          WheelSpinResult value, $Res Function(WheelSpinResult) then) =
      _$WheelSpinResultCopyWithImpl<$Res, WheelSpinResult>;
  @useResult
  $Res call({WheelSegment segment, int earnedHibons, String message});

  $WheelSegmentCopyWith<$Res> get segment;
}

/// @nodoc
class _$WheelSpinResultCopyWithImpl<$Res, $Val extends WheelSpinResult>
    implements $WheelSpinResultCopyWith<$Res> {
  _$WheelSpinResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segment = null,
    Object? earnedHibons = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      segment: null == segment
          ? _value.segment
          : segment // ignore: cast_nullable_to_non_nullable
              as WheelSegment,
      earnedHibons: null == earnedHibons
          ? _value.earnedHibons
          : earnedHibons // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WheelSegmentCopyWith<$Res> get segment {
    return $WheelSegmentCopyWith<$Res>(_value.segment, (value) {
      return _then(_value.copyWith(segment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WheelSpinResultImplCopyWith<$Res>
    implements $WheelSpinResultCopyWith<$Res> {
  factory _$$WheelSpinResultImplCopyWith(_$WheelSpinResultImpl value,
          $Res Function(_$WheelSpinResultImpl) then) =
      __$$WheelSpinResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WheelSegment segment, int earnedHibons, String message});

  @override
  $WheelSegmentCopyWith<$Res> get segment;
}

/// @nodoc
class __$$WheelSpinResultImplCopyWithImpl<$Res>
    extends _$WheelSpinResultCopyWithImpl<$Res, _$WheelSpinResultImpl>
    implements _$$WheelSpinResultImplCopyWith<$Res> {
  __$$WheelSpinResultImplCopyWithImpl(
      _$WheelSpinResultImpl _value, $Res Function(_$WheelSpinResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segment = null,
    Object? earnedHibons = null,
    Object? message = null,
  }) {
    return _then(_$WheelSpinResultImpl(
      segment: null == segment
          ? _value.segment
          : segment // ignore: cast_nullable_to_non_nullable
              as WheelSegment,
      earnedHibons: null == earnedHibons
          ? _value.earnedHibons
          : earnedHibons // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WheelSpinResultImpl implements _WheelSpinResult {
  const _$WheelSpinResultImpl(
      {required this.segment,
      required this.earnedHibons,
      required this.message});

  factory _$WheelSpinResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$WheelSpinResultImplFromJson(json);

  @override
  final WheelSegment segment;
  @override
  final int earnedHibons;
// Calculated value
  @override
  final String message;

  @override
  String toString() {
    return 'WheelSpinResult(segment: $segment, earnedHibons: $earnedHibons, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WheelSpinResultImpl &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.earnedHibons, earnedHibons) ||
                other.earnedHibons == earnedHibons) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, segment, earnedHibons, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WheelSpinResultImplCopyWith<_$WheelSpinResultImpl> get copyWith =>
      __$$WheelSpinResultImplCopyWithImpl<_$WheelSpinResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WheelSpinResultImplToJson(
      this,
    );
  }
}

abstract class _WheelSpinResult implements WheelSpinResult {
  const factory _WheelSpinResult(
      {required final WheelSegment segment,
      required final int earnedHibons,
      required final String message}) = _$WheelSpinResultImpl;

  factory _WheelSpinResult.fromJson(Map<String, dynamic> json) =
      _$WheelSpinResultImpl.fromJson;

  @override
  WheelSegment get segment;
  @override
  int get earnedHibons;
  @override // Calculated value
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$WheelSpinResultImplCopyWith<_$WheelSpinResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
