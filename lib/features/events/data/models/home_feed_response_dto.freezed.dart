// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_feed_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomeFeedResponseDto _$HomeFeedResponseDtoFromJson(Map<String, dynamic> json) {
  return _HomeFeedResponseDto.fromJson(json);
}

/// @nodoc
mixin _$HomeFeedResponseDto {
  bool get success => throw _privateConstructorUsedError;
  HomeFeedDataDto? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeFeedResponseDtoCopyWith<HomeFeedResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeFeedResponseDtoCopyWith<$Res> {
  factory $HomeFeedResponseDtoCopyWith(
          HomeFeedResponseDto value, $Res Function(HomeFeedResponseDto) then) =
      _$HomeFeedResponseDtoCopyWithImpl<$Res, HomeFeedResponseDto>;
  @useResult
  $Res call({bool success, HomeFeedDataDto? data});

  $HomeFeedDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class _$HomeFeedResponseDtoCopyWithImpl<$Res, $Val extends HomeFeedResponseDto>
    implements $HomeFeedResponseDtoCopyWith<$Res> {
  _$HomeFeedResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HomeFeedDataDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeFeedDataDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $HomeFeedDataDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeFeedResponseDtoImplCopyWith<$Res>
    implements $HomeFeedResponseDtoCopyWith<$Res> {
  factory _$$HomeFeedResponseDtoImplCopyWith(_$HomeFeedResponseDtoImpl value,
          $Res Function(_$HomeFeedResponseDtoImpl) then) =
      __$$HomeFeedResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, HomeFeedDataDto? data});

  @override
  $HomeFeedDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class __$$HomeFeedResponseDtoImplCopyWithImpl<$Res>
    extends _$HomeFeedResponseDtoCopyWithImpl<$Res, _$HomeFeedResponseDtoImpl>
    implements _$$HomeFeedResponseDtoImplCopyWith<$Res> {
  __$$HomeFeedResponseDtoImplCopyWithImpl(_$HomeFeedResponseDtoImpl _value,
      $Res Function(_$HomeFeedResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
  }) {
    return _then(_$HomeFeedResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HomeFeedDataDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeFeedResponseDtoImpl implements _HomeFeedResponseDto {
  const _$HomeFeedResponseDtoImpl({required this.success, this.data});

  factory _$HomeFeedResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeFeedResponseDtoImplFromJson(json);

  @override
  final bool success;
  @override
  final HomeFeedDataDto? data;

  @override
  String toString() {
    return 'HomeFeedResponseDto(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeFeedResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeFeedResponseDtoImplCopyWith<_$HomeFeedResponseDtoImpl> get copyWith =>
      __$$HomeFeedResponseDtoImplCopyWithImpl<_$HomeFeedResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeFeedResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _HomeFeedResponseDto implements HomeFeedResponseDto {
  const factory _HomeFeedResponseDto(
      {required final bool success,
      final HomeFeedDataDto? data}) = _$HomeFeedResponseDtoImpl;

  factory _HomeFeedResponseDto.fromJson(Map<String, dynamic> json) =
      _$HomeFeedResponseDtoImpl.fromJson;

  @override
  bool get success;
  @override
  HomeFeedDataDto? get data;
  @override
  @JsonKey(ignore: true)
  _$$HomeFeedResponseDtoImplCopyWith<_$HomeFeedResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeFeedDataDto _$HomeFeedDataDtoFromJson(Map<String, dynamic> json) {
  return _HomeFeedDataDto.fromJson(json);
}

/// @nodoc
mixin _$HomeFeedDataDto {
  List<EventDto> get today => throw _privateConstructorUsedError;
  List<EventDto> get tomorrow => throw _privateConstructorUsedError;
  List<EventDto> get recommended => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_provided')
  bool get locationProvided => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeFeedDataDtoCopyWith<HomeFeedDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeFeedDataDtoCopyWith<$Res> {
  factory $HomeFeedDataDtoCopyWith(
          HomeFeedDataDto value, $Res Function(HomeFeedDataDto) then) =
      _$HomeFeedDataDtoCopyWithImpl<$Res, HomeFeedDataDto>;
  @useResult
  $Res call(
      {List<EventDto> today,
      List<EventDto> tomorrow,
      List<EventDto> recommended,
      @JsonKey(name: 'location_provided') bool locationProvided});
}

/// @nodoc
class _$HomeFeedDataDtoCopyWithImpl<$Res, $Val extends HomeFeedDataDto>
    implements $HomeFeedDataDtoCopyWith<$Res> {
  _$HomeFeedDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? tomorrow = null,
    Object? recommended = null,
    Object? locationProvided = null,
  }) {
    return _then(_value.copyWith(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      tomorrow: null == tomorrow
          ? _value.tomorrow
          : tomorrow // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      recommended: null == recommended
          ? _value.recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      locationProvided: null == locationProvided
          ? _value.locationProvided
          : locationProvided // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeFeedDataDtoImplCopyWith<$Res>
    implements $HomeFeedDataDtoCopyWith<$Res> {
  factory _$$HomeFeedDataDtoImplCopyWith(_$HomeFeedDataDtoImpl value,
          $Res Function(_$HomeFeedDataDtoImpl) then) =
      __$$HomeFeedDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EventDto> today,
      List<EventDto> tomorrow,
      List<EventDto> recommended,
      @JsonKey(name: 'location_provided') bool locationProvided});
}

/// @nodoc
class __$$HomeFeedDataDtoImplCopyWithImpl<$Res>
    extends _$HomeFeedDataDtoCopyWithImpl<$Res, _$HomeFeedDataDtoImpl>
    implements _$$HomeFeedDataDtoImplCopyWith<$Res> {
  __$$HomeFeedDataDtoImplCopyWithImpl(
      _$HomeFeedDataDtoImpl _value, $Res Function(_$HomeFeedDataDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? tomorrow = null,
    Object? recommended = null,
    Object? locationProvided = null,
  }) {
    return _then(_$HomeFeedDataDtoImpl(
      today: null == today
          ? _value._today
          : today // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      tomorrow: null == tomorrow
          ? _value._tomorrow
          : tomorrow // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      recommended: null == recommended
          ? _value._recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as List<EventDto>,
      locationProvided: null == locationProvided
          ? _value.locationProvided
          : locationProvided // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeFeedDataDtoImpl implements _HomeFeedDataDto {
  const _$HomeFeedDataDtoImpl(
      {final List<EventDto> today = const [],
      final List<EventDto> tomorrow = const [],
      final List<EventDto> recommended = const [],
      @JsonKey(name: 'location_provided') this.locationProvided = false})
      : _today = today,
        _tomorrow = tomorrow,
        _recommended = recommended;

  factory _$HomeFeedDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeFeedDataDtoImplFromJson(json);

  final List<EventDto> _today;
  @override
  @JsonKey()
  List<EventDto> get today {
    if (_today is EqualUnmodifiableListView) return _today;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_today);
  }

  final List<EventDto> _tomorrow;
  @override
  @JsonKey()
  List<EventDto> get tomorrow {
    if (_tomorrow is EqualUnmodifiableListView) return _tomorrow;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tomorrow);
  }

  final List<EventDto> _recommended;
  @override
  @JsonKey()
  List<EventDto> get recommended {
    if (_recommended is EqualUnmodifiableListView) return _recommended;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommended);
  }

  @override
  @JsonKey(name: 'location_provided')
  final bool locationProvided;

  @override
  String toString() {
    return 'HomeFeedDataDto(today: $today, tomorrow: $tomorrow, recommended: $recommended, locationProvided: $locationProvided)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeFeedDataDtoImpl &&
            const DeepCollectionEquality().equals(other._today, _today) &&
            const DeepCollectionEquality().equals(other._tomorrow, _tomorrow) &&
            const DeepCollectionEquality()
                .equals(other._recommended, _recommended) &&
            (identical(other.locationProvided, locationProvided) ||
                other.locationProvided == locationProvided));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_today),
      const DeepCollectionEquality().hash(_tomorrow),
      const DeepCollectionEquality().hash(_recommended),
      locationProvided);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeFeedDataDtoImplCopyWith<_$HomeFeedDataDtoImpl> get copyWith =>
      __$$HomeFeedDataDtoImplCopyWithImpl<_$HomeFeedDataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeFeedDataDtoImplToJson(
      this,
    );
  }
}

abstract class _HomeFeedDataDto implements HomeFeedDataDto {
  const factory _HomeFeedDataDto(
          {final List<EventDto> today,
          final List<EventDto> tomorrow,
          final List<EventDto> recommended,
          @JsonKey(name: 'location_provided') final bool locationProvided}) =
      _$HomeFeedDataDtoImpl;

  factory _HomeFeedDataDto.fromJson(Map<String, dynamic> json) =
      _$HomeFeedDataDtoImpl.fromJson;

  @override
  List<EventDto> get today;
  @override
  List<EventDto> get tomorrow;
  @override
  List<EventDto> get recommended;
  @override
  @JsonKey(name: 'location_provided')
  bool get locationProvided;
  @override
  @JsonKey(ignore: true)
  _$$HomeFeedDataDtoImplCopyWith<_$HomeFeedDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
