// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quota_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuotaDto _$QuotaDtoFromJson(Map<String, dynamic> json) {
  return _QuotaDto.fromJson(json);
}

/// @nodoc
mixin _$QuotaDto {
  /// Messages used in current period
  int get used => throw _privateConstructorUsedError;

  /// Maximum messages allowed in period
  int get limit => throw _privateConstructorUsedError;

  /// Remaining messages
  int get remaining => throw _privateConstructorUsedError;

  /// When the quota resets (ISO 8601)
  @JsonKey(name: 'resets_at')
  String? get resetsAt => throw _privateConstructorUsedError;

  /// Period type (daily, weekly, monthly)
  String get period => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotaDtoCopyWith<QuotaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaDtoCopyWith<$Res> {
  factory $QuotaDtoCopyWith(QuotaDto value, $Res Function(QuotaDto) then) =
      _$QuotaDtoCopyWithImpl<$Res, QuotaDto>;
  @useResult
  $Res call(
      {int used,
      int limit,
      int remaining,
      @JsonKey(name: 'resets_at') String? resetsAt,
      String period});
}

/// @nodoc
class _$QuotaDtoCopyWithImpl<$Res, $Val extends QuotaDto>
    implements $QuotaDtoCopyWith<$Res> {
  _$QuotaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? limit = null,
    Object? remaining = null,
    Object? resetsAt = freezed,
    Object? period = null,
  }) {
    return _then(_value.copyWith(
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as int,
      resetsAt: freezed == resetsAt
          ? _value.resetsAt
          : resetsAt // ignore: cast_nullable_to_non_nullable
              as String?,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuotaDtoImplCopyWith<$Res>
    implements $QuotaDtoCopyWith<$Res> {
  factory _$$QuotaDtoImplCopyWith(
          _$QuotaDtoImpl value, $Res Function(_$QuotaDtoImpl) then) =
      __$$QuotaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int used,
      int limit,
      int remaining,
      @JsonKey(name: 'resets_at') String? resetsAt,
      String period});
}

/// @nodoc
class __$$QuotaDtoImplCopyWithImpl<$Res>
    extends _$QuotaDtoCopyWithImpl<$Res, _$QuotaDtoImpl>
    implements _$$QuotaDtoImplCopyWith<$Res> {
  __$$QuotaDtoImplCopyWithImpl(
      _$QuotaDtoImpl _value, $Res Function(_$QuotaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? limit = null,
    Object? remaining = null,
    Object? resetsAt = freezed,
    Object? period = null,
  }) {
    return _then(_$QuotaDtoImpl(
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as int,
      resetsAt: freezed == resetsAt
          ? _value.resetsAt
          : resetsAt // ignore: cast_nullable_to_non_nullable
              as String?,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotaDtoImpl extends _QuotaDto {
  const _$QuotaDtoImpl(
      {this.used = 0,
      this.limit = 10,
      this.remaining = 10,
      @JsonKey(name: 'resets_at') this.resetsAt,
      this.period = 'daily'})
      : super._();

  factory _$QuotaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotaDtoImplFromJson(json);

  /// Messages used in current period
  @override
  @JsonKey()
  final int used;

  /// Maximum messages allowed in period
  @override
  @JsonKey()
  final int limit;

  /// Remaining messages
  @override
  @JsonKey()
  final int remaining;

  /// When the quota resets (ISO 8601)
  @override
  @JsonKey(name: 'resets_at')
  final String? resetsAt;

  /// Period type (daily, weekly, monthly)
  @override
  @JsonKey()
  final String period;

  @override
  String toString() {
    return 'QuotaDto(used: $used, limit: $limit, remaining: $remaining, resetsAt: $resetsAt, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaDtoImpl &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.resetsAt, resetsAt) ||
                other.resetsAt == resetsAt) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, used, limit, remaining, resetsAt, period);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaDtoImplCopyWith<_$QuotaDtoImpl> get copyWith =>
      __$$QuotaDtoImplCopyWithImpl<_$QuotaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotaDtoImplToJson(
      this,
    );
  }
}

abstract class _QuotaDto extends QuotaDto {
  const factory _QuotaDto(
      {final int used,
      final int limit,
      final int remaining,
      @JsonKey(name: 'resets_at') final String? resetsAt,
      final String period}) = _$QuotaDtoImpl;
  const _QuotaDto._() : super._();

  factory _QuotaDto.fromJson(Map<String, dynamic> json) =
      _$QuotaDtoImpl.fromJson;

  @override

  /// Messages used in current period
  int get used;
  @override

  /// Maximum messages allowed in period
  int get limit;
  @override

  /// Remaining messages
  int get remaining;
  @override

  /// When the quota resets (ISO 8601)
  @JsonKey(name: 'resets_at')
  String? get resetsAt;
  @override

  /// Period type (daily, weekly, monthly)
  String get period;
  @override
  @JsonKey(ignore: true)
  _$$QuotaDtoImplCopyWith<_$QuotaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuotaResponseDto _$QuotaResponseDtoFromJson(Map<String, dynamic> json) {
  return _QuotaResponseDto.fromJson(json);
}

/// @nodoc
mixin _$QuotaResponseDto {
  bool get success => throw _privateConstructorUsedError;
  QuotaDto get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotaResponseDtoCopyWith<QuotaResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaResponseDtoCopyWith<$Res> {
  factory $QuotaResponseDtoCopyWith(
          QuotaResponseDto value, $Res Function(QuotaResponseDto) then) =
      _$QuotaResponseDtoCopyWithImpl<$Res, QuotaResponseDto>;
  @useResult
  $Res call({bool success, QuotaDto data});

  $QuotaDtoCopyWith<$Res> get data;
}

/// @nodoc
class _$QuotaResponseDtoCopyWithImpl<$Res, $Val extends QuotaResponseDto>
    implements $QuotaResponseDtoCopyWith<$Res> {
  _$QuotaResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as QuotaDto,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $QuotaDtoCopyWith<$Res> get data {
    return $QuotaDtoCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuotaResponseDtoImplCopyWith<$Res>
    implements $QuotaResponseDtoCopyWith<$Res> {
  factory _$$QuotaResponseDtoImplCopyWith(_$QuotaResponseDtoImpl value,
          $Res Function(_$QuotaResponseDtoImpl) then) =
      __$$QuotaResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, QuotaDto data});

  @override
  $QuotaDtoCopyWith<$Res> get data;
}

/// @nodoc
class __$$QuotaResponseDtoImplCopyWithImpl<$Res>
    extends _$QuotaResponseDtoCopyWithImpl<$Res, _$QuotaResponseDtoImpl>
    implements _$$QuotaResponseDtoImplCopyWith<$Res> {
  __$$QuotaResponseDtoImplCopyWithImpl(_$QuotaResponseDtoImpl _value,
      $Res Function(_$QuotaResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_$QuotaResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as QuotaDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotaResponseDtoImpl implements _QuotaResponseDto {
  const _$QuotaResponseDtoImpl({required this.success, required this.data});

  factory _$QuotaResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotaResponseDtoImplFromJson(json);

  @override
  final bool success;
  @override
  final QuotaDto data;

  @override
  String toString() {
    return 'QuotaResponseDto(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaResponseDtoImplCopyWith<_$QuotaResponseDtoImpl> get copyWith =>
      __$$QuotaResponseDtoImplCopyWithImpl<_$QuotaResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotaResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _QuotaResponseDto implements QuotaResponseDto {
  const factory _QuotaResponseDto(
      {required final bool success,
      required final QuotaDto data}) = _$QuotaResponseDtoImpl;

  factory _QuotaResponseDto.fromJson(Map<String, dynamic> json) =
      _$QuotaResponseDtoImpl.fromJson;

  @override
  bool get success;
  @override
  QuotaDto get data;
  @override
  @JsonKey(ignore: true)
  _$$QuotaResponseDtoImplCopyWith<_$QuotaResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
