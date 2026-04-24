// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageSenderDto _$MessageSenderDtoFromJson(Map<String, dynamic> json) {
  return _MessageSenderDto.fromJson(json);
}

/// @nodoc
mixin _$MessageSenderDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageSenderDtoCopyWith<MessageSenderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageSenderDtoCopyWith<$Res> {
  factory $MessageSenderDtoCopyWith(
          MessageSenderDto value, $Res Function(MessageSenderDto) then) =
      _$MessageSenderDtoCopyWithImpl<$Res, MessageSenderDto>;
  @useResult
  $Res call(
      {int id, String name, @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class _$MessageSenderDtoCopyWithImpl<$Res, $Val extends MessageSenderDto>
    implements $MessageSenderDtoCopyWith<$Res> {
  _$MessageSenderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageSenderDtoImplCopyWith<$Res>
    implements $MessageSenderDtoCopyWith<$Res> {
  factory _$$MessageSenderDtoImplCopyWith(_$MessageSenderDtoImpl value,
          $Res Function(_$MessageSenderDtoImpl) then) =
      __$$MessageSenderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String name, @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class __$$MessageSenderDtoImplCopyWithImpl<$Res>
    extends _$MessageSenderDtoCopyWithImpl<$Res, _$MessageSenderDtoImpl>
    implements _$$MessageSenderDtoImplCopyWith<$Res> {
  __$$MessageSenderDtoImplCopyWithImpl(_$MessageSenderDtoImpl _value,
      $Res Function(_$MessageSenderDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$MessageSenderDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageSenderDtoImpl implements _MessageSenderDto {
  const _$MessageSenderDtoImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'avatar_url') this.avatarUrl});

  factory _$MessageSenderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageSenderDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  String toString() {
    return 'MessageSenderDto(id: $id, name: $name, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageSenderDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageSenderDtoImplCopyWith<_$MessageSenderDtoImpl> get copyWith =>
      __$$MessageSenderDtoImplCopyWithImpl<_$MessageSenderDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageSenderDtoImplToJson(
      this,
    );
  }
}

abstract class _MessageSenderDto implements MessageSenderDto {
  const factory _MessageSenderDto(
          {required final int id,
          required final String name,
          @JsonKey(name: 'avatar_url') final String? avatarUrl}) =
      _$MessageSenderDtoImpl;

  factory _MessageSenderDto.fromJson(Map<String, dynamic> json) =
      _$MessageSenderDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$MessageSenderDtoImplCopyWith<_$MessageSenderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return _MessageDto.fromJson(json);
}

/// @nodoc
mixin _$MessageDto {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  int get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_type')
  String get senderType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_type_label')
  String? get senderTypeLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_system')
  bool get isSystem => throw _privateConstructorUsedError;
  MessageSenderDto? get sender => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_edited')
  bool get isEdited => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_delivered')
  bool get isDelivered => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_mine')
  bool get isMine => throw _privateConstructorUsedError;
  List<AttachmentDto> get attachments => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_at')
  String? get editedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  String? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  String? get deliveredAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageDtoCopyWith<MessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDtoCopyWith<$Res> {
  factory $MessageDtoCopyWith(
          MessageDto value, $Res Function(MessageDto) then) =
      _$MessageDtoCopyWithImpl<$Res, MessageDto>;
  @useResult
  $Res call(
      {int id,
      String uuid,
      @JsonKey(name: 'conversation_id') int conversationId,
      @JsonKey(name: 'sender_type') String senderType,
      @JsonKey(name: 'sender_type_label') String? senderTypeLabel,
      @JsonKey(name: 'is_system') bool isSystem,
      MessageSenderDto? sender,
      String? content,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'is_edited') bool isEdited,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_delivered') bool isDelivered,
      @JsonKey(name: 'is_mine') bool isMine,
      List<AttachmentDto> attachments,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'edited_at') String? editedAt,
      @JsonKey(name: 'read_at') String? readAt,
      @JsonKey(name: 'delivered_at') String? deliveredAt});

  $MessageSenderDtoCopyWith<$Res>? get sender;
}

/// @nodoc
class _$MessageDtoCopyWithImpl<$Res, $Val extends MessageDto>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? conversationId = null,
    Object? senderType = null,
    Object? senderTypeLabel = freezed,
    Object? isSystem = null,
    Object? sender = freezed,
    Object? content = freezed,
    Object? isDeleted = null,
    Object? isEdited = null,
    Object? isRead = null,
    Object? isDelivered = null,
    Object? isMine = null,
    Object? attachments = null,
    Object? createdAt = null,
    Object? editedAt = freezed,
    Object? readAt = freezed,
    Object? deliveredAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      senderType: null == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String,
      senderTypeLabel: freezed == senderTypeLabel
          ? _value.senderTypeLabel
          : senderTypeLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as MessageSenderDto?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelivered: null == isDelivered
          ? _value.isDelivered
          : isDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentDto>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageSenderDtoCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $MessageSenderDtoCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageDtoImplCopyWith<$Res>
    implements $MessageDtoCopyWith<$Res> {
  factory _$$MessageDtoImplCopyWith(
          _$MessageDtoImpl value, $Res Function(_$MessageDtoImpl) then) =
      __$$MessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uuid,
      @JsonKey(name: 'conversation_id') int conversationId,
      @JsonKey(name: 'sender_type') String senderType,
      @JsonKey(name: 'sender_type_label') String? senderTypeLabel,
      @JsonKey(name: 'is_system') bool isSystem,
      MessageSenderDto? sender,
      String? content,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'is_edited') bool isEdited,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_delivered') bool isDelivered,
      @JsonKey(name: 'is_mine') bool isMine,
      List<AttachmentDto> attachments,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'edited_at') String? editedAt,
      @JsonKey(name: 'read_at') String? readAt,
      @JsonKey(name: 'delivered_at') String? deliveredAt});

  @override
  $MessageSenderDtoCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$MessageDtoImplCopyWithImpl<$Res>
    extends _$MessageDtoCopyWithImpl<$Res, _$MessageDtoImpl>
    implements _$$MessageDtoImplCopyWith<$Res> {
  __$$MessageDtoImplCopyWithImpl(
      _$MessageDtoImpl _value, $Res Function(_$MessageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? conversationId = null,
    Object? senderType = null,
    Object? senderTypeLabel = freezed,
    Object? isSystem = null,
    Object? sender = freezed,
    Object? content = freezed,
    Object? isDeleted = null,
    Object? isEdited = null,
    Object? isRead = null,
    Object? isDelivered = null,
    Object? isMine = null,
    Object? attachments = null,
    Object? createdAt = null,
    Object? editedAt = freezed,
    Object? readAt = freezed,
    Object? deliveredAt = freezed,
  }) {
    return _then(_$MessageDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      senderType: null == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String,
      senderTypeLabel: freezed == senderTypeLabel
          ? _value.senderTypeLabel
          : senderTypeLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as MessageSenderDto?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelivered: null == isDelivered
          ? _value.isDelivered
          : isDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentDto>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageDtoImpl implements _MessageDto {
  const _$MessageDtoImpl(
      {required this.id,
      required this.uuid,
      @JsonKey(name: 'conversation_id') required this.conversationId,
      @JsonKey(name: 'sender_type') required this.senderType,
      @JsonKey(name: 'sender_type_label') this.senderTypeLabel,
      @JsonKey(name: 'is_system') this.isSystem = false,
      this.sender,
      this.content,
      @JsonKey(name: 'is_deleted') this.isDeleted = false,
      @JsonKey(name: 'is_edited') this.isEdited = false,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'is_delivered') this.isDelivered = false,
      @JsonKey(name: 'is_mine') this.isMine = false,
      final List<AttachmentDto> attachments = const [],
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'edited_at') this.editedAt,
      @JsonKey(name: 'read_at') this.readAt,
      @JsonKey(name: 'delivered_at') this.deliveredAt})
      : _attachments = attachments;

  factory _$MessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String uuid;
  @override
  @JsonKey(name: 'conversation_id')
  final int conversationId;
  @override
  @JsonKey(name: 'sender_type')
  final String senderType;
  @override
  @JsonKey(name: 'sender_type_label')
  final String? senderTypeLabel;
  @override
  @JsonKey(name: 'is_system')
  final bool isSystem;
  @override
  final MessageSenderDto? sender;
  @override
  final String? content;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @override
  @JsonKey(name: 'is_edited')
  final bool isEdited;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'is_delivered')
  final bool isDelivered;
  @override
  @JsonKey(name: 'is_mine')
  final bool isMine;
  final List<AttachmentDto> _attachments;
  @override
  @JsonKey()
  List<AttachmentDto> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'edited_at')
  final String? editedAt;
  @override
  @JsonKey(name: 'read_at')
  final String? readAt;
  @override
  @JsonKey(name: 'delivered_at')
  final String? deliveredAt;

  @override
  String toString() {
    return 'MessageDto(id: $id, uuid: $uuid, conversationId: $conversationId, senderType: $senderType, senderTypeLabel: $senderTypeLabel, isSystem: $isSystem, sender: $sender, content: $content, isDeleted: $isDeleted, isEdited: $isEdited, isRead: $isRead, isDelivered: $isDelivered, isMine: $isMine, attachments: $attachments, createdAt: $createdAt, editedAt: $editedAt, readAt: $readAt, deliveredAt: $deliveredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderType, senderType) ||
                other.senderType == senderType) &&
            (identical(other.senderTypeLabel, senderTypeLabel) ||
                other.senderTypeLabel == senderTypeLabel) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDelivered, isDelivered) ||
                other.isDelivered == isDelivered) &&
            (identical(other.isMine, isMine) || other.isMine == isMine) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uuid,
      conversationId,
      senderType,
      senderTypeLabel,
      isSystem,
      sender,
      content,
      isDeleted,
      isEdited,
      isRead,
      isDelivered,
      isMine,
      const DeepCollectionEquality().hash(_attachments),
      createdAt,
      editedAt,
      readAt,
      deliveredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      __$$MessageDtoImplCopyWithImpl<_$MessageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageDtoImplToJson(
      this,
    );
  }
}

abstract class _MessageDto implements MessageDto {
  const factory _MessageDto(
          {required final int id,
          required final String uuid,
          @JsonKey(name: 'conversation_id') required final int conversationId,
          @JsonKey(name: 'sender_type') required final String senderType,
          @JsonKey(name: 'sender_type_label') final String? senderTypeLabel,
          @JsonKey(name: 'is_system') final bool isSystem,
          final MessageSenderDto? sender,
          final String? content,
          @JsonKey(name: 'is_deleted') final bool isDeleted,
          @JsonKey(name: 'is_edited') final bool isEdited,
          @JsonKey(name: 'is_read') final bool isRead,
          @JsonKey(name: 'is_delivered') final bool isDelivered,
          @JsonKey(name: 'is_mine') final bool isMine,
          final List<AttachmentDto> attachments,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'edited_at') final String? editedAt,
          @JsonKey(name: 'read_at') final String? readAt,
          @JsonKey(name: 'delivered_at') final String? deliveredAt}) =
      _$MessageDtoImpl;

  factory _MessageDto.fromJson(Map<String, dynamic> json) =
      _$MessageDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get uuid;
  @override
  @JsonKey(name: 'conversation_id')
  int get conversationId;
  @override
  @JsonKey(name: 'sender_type')
  String get senderType;
  @override
  @JsonKey(name: 'sender_type_label')
  String? get senderTypeLabel;
  @override
  @JsonKey(name: 'is_system')
  bool get isSystem;
  @override
  MessageSenderDto? get sender;
  @override
  String? get content;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;
  @override
  @JsonKey(name: 'is_edited')
  bool get isEdited;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'is_delivered')
  bool get isDelivered;
  @override
  @JsonKey(name: 'is_mine')
  bool get isMine;
  @override
  List<AttachmentDto> get attachments;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'edited_at')
  String? get editedAt;
  @override
  @JsonKey(name: 'read_at')
  String? get readAt;
  @override
  @JsonKey(name: 'delivered_at')
  String? get deliveredAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
