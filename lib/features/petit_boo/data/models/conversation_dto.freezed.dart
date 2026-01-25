// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) {
  return _ConversationDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationDto {
  String get uuid => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_count')
  int get messageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message')
  String? get lastMessage => throw _privateConstructorUsedError;
  List<ChatMessageDto>? get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationDtoCopyWith<ConversationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationDtoCopyWith<$Res> {
  factory $ConversationDtoCopyWith(
          ConversationDto value, $Res Function(ConversationDto) then) =
      _$ConversationDtoCopyWithImpl<$Res, ConversationDto>;
  @useResult
  $Res call(
      {String uuid,
      String? title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'last_message') String? lastMessage,
      List<ChatMessageDto>? messages});
}

/// @nodoc
class _$ConversationDtoCopyWithImpl<$Res, $Val extends ConversationDto>
    implements $ConversationDtoCopyWith<$Res> {
  _$ConversationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? messageCount = null,
    Object? lastMessage = freezed,
    Object? messages = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: freezed == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageDto>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationDtoImplCopyWith<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  factory _$$ConversationDtoImplCopyWith(_$ConversationDtoImpl value,
          $Res Function(_$ConversationDtoImpl) then) =
      __$$ConversationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String? title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'last_message') String? lastMessage,
      List<ChatMessageDto>? messages});
}

/// @nodoc
class __$$ConversationDtoImplCopyWithImpl<$Res>
    extends _$ConversationDtoCopyWithImpl<$Res, _$ConversationDtoImpl>
    implements _$$ConversationDtoImplCopyWith<$Res> {
  __$$ConversationDtoImplCopyWithImpl(
      _$ConversationDtoImpl _value, $Res Function(_$ConversationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? messageCount = null,
    Object? lastMessage = freezed,
    Object? messages = freezed,
  }) {
    return _then(_$ConversationDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: freezed == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationDtoImpl implements _ConversationDto {
  const _$ConversationDtoImpl(
      {required this.uuid,
      this.title,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'message_count') this.messageCount = 0,
      @JsonKey(name: 'last_message') this.lastMessage,
      final List<ChatMessageDto>? messages})
      : _messages = messages;

  factory _$ConversationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  final String? title;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'message_count')
  final int messageCount;
  @override
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  final List<ChatMessageDto>? _messages;
  @override
  List<ChatMessageDto>? get messages {
    final value = _messages;
    if (value == null) return null;
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ConversationDto(uuid: $uuid, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, messageCount: $messageCount, lastMessage: $lastMessage, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      title,
      createdAt,
      updatedAt,
      messageCount,
      lastMessage,
      const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationDtoImplCopyWith<_$ConversationDtoImpl> get copyWith =>
      __$$ConversationDtoImplCopyWithImpl<_$ConversationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationDto implements ConversationDto {
  const factory _ConversationDto(
      {required final String uuid,
      final String? title,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'message_count') final int messageCount,
      @JsonKey(name: 'last_message') final String? lastMessage,
      final List<ChatMessageDto>? messages}) = _$ConversationDtoImpl;

  factory _ConversationDto.fromJson(Map<String, dynamic> json) =
      _$ConversationDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  String? get title;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'message_count')
  int get messageCount;
  @override
  @JsonKey(name: 'last_message')
  String? get lastMessage;
  @override
  List<ChatMessageDto>? get messages;
  @override
  @JsonKey(ignore: true)
  _$$ConversationDtoImplCopyWith<_$ConversationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationsResponseDto _$ConversationsResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _ConversationsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationsResponseDto {
  bool get success => throw _privateConstructorUsedError;
  List<ConversationDto> get data => throw _privateConstructorUsedError;
  ConversationMetaDto? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationsResponseDtoCopyWith<ConversationsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationsResponseDtoCopyWith<$Res> {
  factory $ConversationsResponseDtoCopyWith(ConversationsResponseDto value,
          $Res Function(ConversationsResponseDto) then) =
      _$ConversationsResponseDtoCopyWithImpl<$Res, ConversationsResponseDto>;
  @useResult
  $Res call(
      {bool success, List<ConversationDto> data, ConversationMetaDto? meta});

  $ConversationMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$ConversationsResponseDtoCopyWithImpl<$Res,
        $Val extends ConversationsResponseDto>
    implements $ConversationsResponseDtoCopyWith<$Res> {
  _$ConversationsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ConversationDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as ConversationMetaDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationMetaDtoCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $ConversationMetaDtoCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationsResponseDtoImplCopyWith<$Res>
    implements $ConversationsResponseDtoCopyWith<$Res> {
  factory _$$ConversationsResponseDtoImplCopyWith(
          _$ConversationsResponseDtoImpl value,
          $Res Function(_$ConversationsResponseDtoImpl) then) =
      __$$ConversationsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success, List<ConversationDto> data, ConversationMetaDto? meta});

  @override
  $ConversationMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$ConversationsResponseDtoImplCopyWithImpl<$Res>
    extends _$ConversationsResponseDtoCopyWithImpl<$Res,
        _$ConversationsResponseDtoImpl>
    implements _$$ConversationsResponseDtoImplCopyWith<$Res> {
  __$$ConversationsResponseDtoImplCopyWithImpl(
      _$ConversationsResponseDtoImpl _value,
      $Res Function(_$ConversationsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_$ConversationsResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ConversationDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as ConversationMetaDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationsResponseDtoImpl implements _ConversationsResponseDto {
  const _$ConversationsResponseDtoImpl(
      {required this.success,
      required final List<ConversationDto> data,
      this.meta})
      : _data = data;

  factory _$ConversationsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationsResponseDtoImplFromJson(json);

  @override
  final bool success;
  final List<ConversationDto> _data;
  @override
  List<ConversationDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final ConversationMetaDto? meta;

  @override
  String toString() {
    return 'ConversationsResponseDto(success: $success, data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationsResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, const DeepCollectionEquality().hash(_data), meta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationsResponseDtoImplCopyWith<_$ConversationsResponseDtoImpl>
      get copyWith => __$$ConversationsResponseDtoImplCopyWithImpl<
          _$ConversationsResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationsResponseDto implements ConversationsResponseDto {
  const factory _ConversationsResponseDto(
      {required final bool success,
      required final List<ConversationDto> data,
      final ConversationMetaDto? meta}) = _$ConversationsResponseDtoImpl;

  factory _ConversationsResponseDto.fromJson(Map<String, dynamic> json) =
      _$ConversationsResponseDtoImpl.fromJson;

  @override
  bool get success;
  @override
  List<ConversationDto> get data;
  @override
  ConversationMetaDto? get meta;
  @override
  @JsonKey(ignore: true)
  _$$ConversationsResponseDtoImplCopyWith<_$ConversationsResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConversationMetaDto _$ConversationMetaDtoFromJson(Map<String, dynamic> json) {
  return _ConversationMetaDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationMetaDto {
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page')
  int get lastPage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationMetaDtoCopyWith<ConversationMetaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationMetaDtoCopyWith<$Res> {
  factory $ConversationMetaDtoCopyWith(
          ConversationMetaDto value, $Res Function(ConversationMetaDto) then) =
      _$ConversationMetaDtoCopyWithImpl<$Res, ConversationMetaDto>;
  @useResult
  $Res call(
      {int total,
      int page,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'last_page') int lastPage});
}

/// @nodoc
class _$ConversationMetaDtoCopyWithImpl<$Res, $Val extends ConversationMetaDto>
    implements $ConversationMetaDtoCopyWith<$Res> {
  _$ConversationMetaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? perPage = null,
    Object? lastPage = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationMetaDtoImplCopyWith<$Res>
    implements $ConversationMetaDtoCopyWith<$Res> {
  factory _$$ConversationMetaDtoImplCopyWith(_$ConversationMetaDtoImpl value,
          $Res Function(_$ConversationMetaDtoImpl) then) =
      __$$ConversationMetaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int page,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'last_page') int lastPage});
}

/// @nodoc
class __$$ConversationMetaDtoImplCopyWithImpl<$Res>
    extends _$ConversationMetaDtoCopyWithImpl<$Res, _$ConversationMetaDtoImpl>
    implements _$$ConversationMetaDtoImplCopyWith<$Res> {
  __$$ConversationMetaDtoImplCopyWithImpl(_$ConversationMetaDtoImpl _value,
      $Res Function(_$ConversationMetaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? perPage = null,
    Object? lastPage = null,
  }) {
    return _then(_$ConversationMetaDtoImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationMetaDtoImpl implements _ConversationMetaDto {
  const _$ConversationMetaDtoImpl(
      {required this.total,
      required this.page,
      @JsonKey(name: 'per_page') required this.perPage,
      @JsonKey(name: 'last_page') required this.lastPage});

  factory _$ConversationMetaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationMetaDtoImplFromJson(json);

  @override
  final int total;
  @override
  final int page;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  @JsonKey(name: 'last_page')
  final int lastPage;

  @override
  String toString() {
    return 'ConversationMetaDto(total: $total, page: $page, perPage: $perPage, lastPage: $lastPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationMetaDtoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, total, page, perPage, lastPage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationMetaDtoImplCopyWith<_$ConversationMetaDtoImpl> get copyWith =>
      __$$ConversationMetaDtoImplCopyWithImpl<_$ConversationMetaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationMetaDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationMetaDto implements ConversationMetaDto {
  const factory _ConversationMetaDto(
          {required final int total,
          required final int page,
          @JsonKey(name: 'per_page') required final int perPage,
          @JsonKey(name: 'last_page') required final int lastPage}) =
      _$ConversationMetaDtoImpl;

  factory _ConversationMetaDto.fromJson(Map<String, dynamic> json) =
      _$ConversationMetaDtoImpl.fromJson;

  @override
  int get total;
  @override
  int get page;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  @JsonKey(name: 'last_page')
  int get lastPage;
  @override
  @JsonKey(ignore: true)
  _$$ConversationMetaDtoImplCopyWith<_$ConversationMetaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
