// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'petit_boo_event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PetitBooEventDto _$PetitBooEventDtoFromJson(Map<String, dynamic> json) {
  return _PetitBooEventDto.fromJson(json);
}

/// @nodoc
mixin _$PetitBooEventDto {
  /// Event type: session, token, tool_call, tool_result, error, done
  String get type => throw _privateConstructorUsedError;

  /// Token content (for type=token)
  String? get content => throw _privateConstructorUsedError;

  /// Session UUID (for type=session)
  @JsonKey(name: 'session_uuid')
  String? get sessionUuid => throw _privateConstructorUsedError;

  /// Tool name (for type=tool_call, tool_result)
  String? get tool => throw _privateConstructorUsedError;

  /// Tool arguments (for type=tool_call)
  Map<String, dynamic>? get arguments => throw _privateConstructorUsedError;

  /// Tool result data (for type=tool_result)
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;

  /// Error message (for type=error)
  String? get error => throw _privateConstructorUsedError;

  /// Error code (for type=error)
  String? get code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PetitBooEventDtoCopyWith<PetitBooEventDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetitBooEventDtoCopyWith<$Res> {
  factory $PetitBooEventDtoCopyWith(
          PetitBooEventDto value, $Res Function(PetitBooEventDto) then) =
      _$PetitBooEventDtoCopyWithImpl<$Res, PetitBooEventDto>;
  @useResult
  $Res call(
      {String type,
      String? content,
      @JsonKey(name: 'session_uuid') String? sessionUuid,
      String? tool,
      Map<String, dynamic>? arguments,
      Map<String, dynamic>? result,
      String? error,
      String? code});
}

/// @nodoc
class _$PetitBooEventDtoCopyWithImpl<$Res, $Val extends PetitBooEventDto>
    implements $PetitBooEventDtoCopyWith<$Res> {
  _$PetitBooEventDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? content = freezed,
    Object? sessionUuid = freezed,
    Object? tool = freezed,
    Object? arguments = freezed,
    Object? result = freezed,
    Object? error = freezed,
    Object? code = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionUuid: freezed == sessionUuid
          ? _value.sessionUuid
          : sessionUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      tool: freezed == tool
          ? _value.tool
          : tool // ignore: cast_nullable_to_non_nullable
              as String?,
      arguments: freezed == arguments
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PetitBooEventDtoImplCopyWith<$Res>
    implements $PetitBooEventDtoCopyWith<$Res> {
  factory _$$PetitBooEventDtoImplCopyWith(_$PetitBooEventDtoImpl value,
          $Res Function(_$PetitBooEventDtoImpl) then) =
      __$$PetitBooEventDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String? content,
      @JsonKey(name: 'session_uuid') String? sessionUuid,
      String? tool,
      Map<String, dynamic>? arguments,
      Map<String, dynamic>? result,
      String? error,
      String? code});
}

/// @nodoc
class __$$PetitBooEventDtoImplCopyWithImpl<$Res>
    extends _$PetitBooEventDtoCopyWithImpl<$Res, _$PetitBooEventDtoImpl>
    implements _$$PetitBooEventDtoImplCopyWith<$Res> {
  __$$PetitBooEventDtoImplCopyWithImpl(_$PetitBooEventDtoImpl _value,
      $Res Function(_$PetitBooEventDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? content = freezed,
    Object? sessionUuid = freezed,
    Object? tool = freezed,
    Object? arguments = freezed,
    Object? result = freezed,
    Object? error = freezed,
    Object? code = freezed,
  }) {
    return _then(_$PetitBooEventDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionUuid: freezed == sessionUuid
          ? _value.sessionUuid
          : sessionUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      tool: freezed == tool
          ? _value.tool
          : tool // ignore: cast_nullable_to_non_nullable
              as String?,
      arguments: freezed == arguments
          ? _value._arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      result: freezed == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PetitBooEventDtoImpl implements _PetitBooEventDto {
  const _$PetitBooEventDtoImpl(
      {required this.type,
      this.content,
      @JsonKey(name: 'session_uuid') this.sessionUuid,
      this.tool,
      final Map<String, dynamic>? arguments,
      final Map<String, dynamic>? result,
      this.error,
      this.code})
      : _arguments = arguments,
        _result = result;

  factory _$PetitBooEventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetitBooEventDtoImplFromJson(json);

  /// Event type: session, token, tool_call, tool_result, error, done
  @override
  final String type;

  /// Token content (for type=token)
  @override
  final String? content;

  /// Session UUID (for type=session)
  @override
  @JsonKey(name: 'session_uuid')
  final String? sessionUuid;

  /// Tool name (for type=tool_call, tool_result)
  @override
  final String? tool;

  /// Tool arguments (for type=tool_call)
  final Map<String, dynamic>? _arguments;

  /// Tool arguments (for type=tool_call)
  @override
  Map<String, dynamic>? get arguments {
    final value = _arguments;
    if (value == null) return null;
    if (_arguments is EqualUnmodifiableMapView) return _arguments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Tool result data (for type=tool_result)
  final Map<String, dynamic>? _result;

  /// Tool result data (for type=tool_result)
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Error message (for type=error)
  @override
  final String? error;

  /// Error code (for type=error)
  @override
  final String? code;

  @override
  String toString() {
    return 'PetitBooEventDto(type: $type, content: $content, sessionUuid: $sessionUuid, tool: $tool, arguments: $arguments, result: $result, error: $error, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetitBooEventDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sessionUuid, sessionUuid) ||
                other.sessionUuid == sessionUuid) &&
            (identical(other.tool, tool) || other.tool == tool) &&
            const DeepCollectionEquality()
                .equals(other._arguments, _arguments) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      content,
      sessionUuid,
      tool,
      const DeepCollectionEquality().hash(_arguments),
      const DeepCollectionEquality().hash(_result),
      error,
      code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PetitBooEventDtoImplCopyWith<_$PetitBooEventDtoImpl> get copyWith =>
      __$$PetitBooEventDtoImplCopyWithImpl<_$PetitBooEventDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetitBooEventDtoImplToJson(
      this,
    );
  }
}

abstract class _PetitBooEventDto implements PetitBooEventDto {
  const factory _PetitBooEventDto(
      {required final String type,
      final String? content,
      @JsonKey(name: 'session_uuid') final String? sessionUuid,
      final String? tool,
      final Map<String, dynamic>? arguments,
      final Map<String, dynamic>? result,
      final String? error,
      final String? code}) = _$PetitBooEventDtoImpl;

  factory _PetitBooEventDto.fromJson(Map<String, dynamic> json) =
      _$PetitBooEventDtoImpl.fromJson;

  @override

  /// Event type: session, token, tool_call, tool_result, error, done
  String get type;
  @override

  /// Token content (for type=token)
  String? get content;
  @override

  /// Session UUID (for type=session)
  @JsonKey(name: 'session_uuid')
  String? get sessionUuid;
  @override

  /// Tool name (for type=tool_call, tool_result)
  String? get tool;
  @override

  /// Tool arguments (for type=tool_call)
  Map<String, dynamic>? get arguments;
  @override

  /// Tool result data (for type=tool_result)
  Map<String, dynamic>? get result;
  @override

  /// Error message (for type=error)
  String? get error;
  @override

  /// Error code (for type=error)
  String? get code;
  @override
  @JsonKey(ignore: true)
  _$$PetitBooEventDtoImplCopyWith<_$PetitBooEventDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
