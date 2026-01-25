// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) {
  return _ChatMessageDto.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageDto {
  String? get id => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'tool_results')
  List<ToolResultDto>? get toolResults => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  bool get isStreaming => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageDtoCopyWith<ChatMessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageDtoCopyWith<$Res> {
  factory $ChatMessageDtoCopyWith(
          ChatMessageDto value, $Res Function(ChatMessageDto) then) =
      _$ChatMessageDtoCopyWithImpl<$Res, ChatMessageDto>;
  @useResult
  $Res call(
      {String? id,
      String role,
      String content,
      @JsonKey(name: 'tool_results') List<ToolResultDto>? toolResults,
      @JsonKey(name: 'created_at') String? createdAt,
      bool isStreaming});
}

/// @nodoc
class _$ChatMessageDtoCopyWithImpl<$Res, $Val extends ChatMessageDto>
    implements $ChatMessageDtoCopyWith<$Res> {
  _$ChatMessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? role = null,
    Object? content = null,
    Object? toolResults = freezed,
    Object? createdAt = freezed,
    Object? isStreaming = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      toolResults: freezed == toolResults
          ? _value.toolResults
          : toolResults // ignore: cast_nullable_to_non_nullable
              as List<ToolResultDto>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isStreaming: null == isStreaming
          ? _value.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageDtoImplCopyWith<$Res>
    implements $ChatMessageDtoCopyWith<$Res> {
  factory _$$ChatMessageDtoImplCopyWith(_$ChatMessageDtoImpl value,
          $Res Function(_$ChatMessageDtoImpl) then) =
      __$$ChatMessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String role,
      String content,
      @JsonKey(name: 'tool_results') List<ToolResultDto>? toolResults,
      @JsonKey(name: 'created_at') String? createdAt,
      bool isStreaming});
}

/// @nodoc
class __$$ChatMessageDtoImplCopyWithImpl<$Res>
    extends _$ChatMessageDtoCopyWithImpl<$Res, _$ChatMessageDtoImpl>
    implements _$$ChatMessageDtoImplCopyWith<$Res> {
  __$$ChatMessageDtoImplCopyWithImpl(
      _$ChatMessageDtoImpl _value, $Res Function(_$ChatMessageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? role = null,
    Object? content = null,
    Object? toolResults = freezed,
    Object? createdAt = freezed,
    Object? isStreaming = null,
  }) {
    return _then(_$ChatMessageDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      toolResults: freezed == toolResults
          ? _value._toolResults
          : toolResults // ignore: cast_nullable_to_non_nullable
              as List<ToolResultDto>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isStreaming: null == isStreaming
          ? _value.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageDtoImpl extends _ChatMessageDto {
  const _$ChatMessageDtoImpl(
      {this.id,
      required this.role,
      required this.content,
      @JsonKey(name: 'tool_results') final List<ToolResultDto>? toolResults,
      @JsonKey(name: 'created_at') this.createdAt,
      this.isStreaming = false})
      : _toolResults = toolResults,
        super._();

  factory _$ChatMessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageDtoImplFromJson(json);

  @override
  final String? id;
  @override
  final String role;
  @override
  final String content;
  final List<ToolResultDto>? _toolResults;
  @override
  @JsonKey(name: 'tool_results')
  List<ToolResultDto>? get toolResults {
    final value = _toolResults;
    if (value == null) return null;
    if (_toolResults is EqualUnmodifiableListView) return _toolResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey()
  final bool isStreaming;

  @override
  String toString() {
    return 'ChatMessageDto(id: $id, role: $role, content: $content, toolResults: $toolResults, createdAt: $createdAt, isStreaming: $isStreaming)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._toolResults, _toolResults) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      role,
      content,
      const DeepCollectionEquality().hash(_toolResults),
      createdAt,
      isStreaming);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageDtoImplCopyWith<_$ChatMessageDtoImpl> get copyWith =>
      __$$ChatMessageDtoImplCopyWithImpl<_$ChatMessageDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageDtoImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageDto extends ChatMessageDto {
  const factory _ChatMessageDto(
      {final String? id,
      required final String role,
      required final String content,
      @JsonKey(name: 'tool_results') final List<ToolResultDto>? toolResults,
      @JsonKey(name: 'created_at') final String? createdAt,
      final bool isStreaming}) = _$ChatMessageDtoImpl;
  const _ChatMessageDto._() : super._();

  factory _ChatMessageDto.fromJson(Map<String, dynamic> json) =
      _$ChatMessageDtoImpl.fromJson;

  @override
  String? get id;
  @override
  String get role;
  @override
  String get content;
  @override
  @JsonKey(name: 'tool_results')
  List<ToolResultDto>? get toolResults;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  bool get isStreaming;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageDtoImplCopyWith<_$ChatMessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
