// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToolResultDto _$ToolResultDtoFromJson(Map<String, dynamic> json) {
  return _ToolResultDto.fromJson(json);
}

/// @nodoc
mixin _$ToolResultDto {
  /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
  String get tool => throw _privateConstructorUsedError;

  /// Tool-specific result data (raw Map)
  /// Backend sends 'result' in history, 'data' in SSE events
  @JsonKey(readValue: _readDataOrResult)
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Timestamp of tool execution
  @JsonKey(name: 'executed_at')
  String? get executedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolResultDtoCopyWith<ToolResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolResultDtoCopyWith<$Res> {
  factory $ToolResultDtoCopyWith(
          ToolResultDto value, $Res Function(ToolResultDto) then) =
      _$ToolResultDtoCopyWithImpl<$Res, ToolResultDto>;
  @useResult
  $Res call(
      {String tool,
      @JsonKey(readValue: _readDataOrResult) Map<String, dynamic> data,
      @JsonKey(name: 'executed_at') String? executedAt});
}

/// @nodoc
class _$ToolResultDtoCopyWithImpl<$Res, $Val extends ToolResultDto>
    implements $ToolResultDtoCopyWith<$Res> {
  _$ToolResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tool = null,
    Object? data = null,
    Object? executedAt = freezed,
  }) {
    return _then(_value.copyWith(
      tool: null == tool
          ? _value.tool
          : tool // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolResultDtoImplCopyWith<$Res>
    implements $ToolResultDtoCopyWith<$Res> {
  factory _$$ToolResultDtoImplCopyWith(
          _$ToolResultDtoImpl value, $Res Function(_$ToolResultDtoImpl) then) =
      __$$ToolResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tool,
      @JsonKey(readValue: _readDataOrResult) Map<String, dynamic> data,
      @JsonKey(name: 'executed_at') String? executedAt});
}

/// @nodoc
class __$$ToolResultDtoImplCopyWithImpl<$Res>
    extends _$ToolResultDtoCopyWithImpl<$Res, _$ToolResultDtoImpl>
    implements _$$ToolResultDtoImplCopyWith<$Res> {
  __$$ToolResultDtoImplCopyWithImpl(
      _$ToolResultDtoImpl _value, $Res Function(_$ToolResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tool = null,
    Object? data = null,
    Object? executedAt = freezed,
  }) {
    return _then(_$ToolResultDtoImpl(
      tool: null == tool
          ? _value.tool
          : tool // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolResultDtoImpl extends _ToolResultDto {
  const _$ToolResultDtoImpl(
      {required this.tool,
      @JsonKey(readValue: _readDataOrResult)
      required final Map<String, dynamic> data,
      @JsonKey(name: 'executed_at') this.executedAt})
      : _data = data,
        super._();

  factory _$ToolResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolResultDtoImplFromJson(json);

  /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
  @override
  final String tool;

  /// Tool-specific result data (raw Map)
  /// Backend sends 'result' in history, 'data' in SSE events
  final Map<String, dynamic> _data;

  /// Tool-specific result data (raw Map)
  /// Backend sends 'result' in history, 'data' in SSE events
  @override
  @JsonKey(readValue: _readDataOrResult)
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Timestamp of tool execution
  @override
  @JsonKey(name: 'executed_at')
  final String? executedAt;

  @override
  String toString() {
    return 'ToolResultDto(tool: $tool, data: $data, executedAt: $executedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolResultDtoImpl &&
            (identical(other.tool, tool) || other.tool == tool) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tool,
      const DeepCollectionEquality().hash(_data), executedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolResultDtoImplCopyWith<_$ToolResultDtoImpl> get copyWith =>
      __$$ToolResultDtoImplCopyWithImpl<_$ToolResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolResultDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolResultDto extends ToolResultDto {
  const factory _ToolResultDto(
          {required final String tool,
          @JsonKey(readValue: _readDataOrResult)
          required final Map<String, dynamic> data,
          @JsonKey(name: 'executed_at') final String? executedAt}) =
      _$ToolResultDtoImpl;
  const _ToolResultDto._() : super._();

  factory _ToolResultDto.fromJson(Map<String, dynamic> json) =
      _$ToolResultDtoImpl.fromJson;

  @override

  /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
  String get tool;
  @override

  /// Tool-specific result data (raw Map)
  /// Backend sends 'result' in history, 'data' in SSE events
  @JsonKey(readValue: _readDataOrResult)
  Map<String, dynamic> get data;
  @override

  /// Timestamp of tool execution
  @JsonKey(name: 'executed_at')
  String? get executedAt;
  @override
  @JsonKey(ignore: true)
  _$$ToolResultDtoImplCopyWith<_$ToolResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
