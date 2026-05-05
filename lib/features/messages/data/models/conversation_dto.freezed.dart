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

ConversationOrganizationDto _$ConversationOrganizationDtoFromJson(
    Map<String, dynamic> json) {
  return _ConversationOrganizationDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationOrganizationDto {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name')
  String get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_display_name')
  String? get organizationDisplayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationOrganizationDtoCopyWith<ConversationOrganizationDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationOrganizationDtoCopyWith<$Res> {
  factory $ConversationOrganizationDtoCopyWith(
          ConversationOrganizationDto value,
          $Res Function(ConversationOrganizationDto) then) =
      _$ConversationOrganizationDtoCopyWithImpl<$Res,
          ConversationOrganizationDto>;
  @useResult
  $Res call(
      {int id,
      String uuid,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'organization_name') String organizationName,
      @JsonKey(name: 'organization_display_name')
      String? organizationDisplayName,
      @JsonKey(name: 'logo_url') String? logoUrl,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class _$ConversationOrganizationDtoCopyWithImpl<$Res,
        $Val extends ConversationOrganizationDto>
    implements $ConversationOrganizationDtoCopyWith<$Res> {
  _$ConversationOrganizationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? companyName = null,
    Object? organizationName = null,
    Object? organizationDisplayName = freezed,
    Object? logoUrl = freezed,
    Object? avatarUrl = freezed,
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
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationName: null == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationDisplayName: freezed == organizationDisplayName
          ? _value.organizationDisplayName
          : organizationDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationOrganizationDtoImplCopyWith<$Res>
    implements $ConversationOrganizationDtoCopyWith<$Res> {
  factory _$$ConversationOrganizationDtoImplCopyWith(
          _$ConversationOrganizationDtoImpl value,
          $Res Function(_$ConversationOrganizationDtoImpl) then) =
      __$$ConversationOrganizationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uuid,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'organization_name') String organizationName,
      @JsonKey(name: 'organization_display_name')
      String? organizationDisplayName,
      @JsonKey(name: 'logo_url') String? logoUrl,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class __$$ConversationOrganizationDtoImplCopyWithImpl<$Res>
    extends _$ConversationOrganizationDtoCopyWithImpl<$Res,
        _$ConversationOrganizationDtoImpl>
    implements _$$ConversationOrganizationDtoImplCopyWith<$Res> {
  __$$ConversationOrganizationDtoImplCopyWithImpl(
      _$ConversationOrganizationDtoImpl _value,
      $Res Function(_$ConversationOrganizationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? companyName = null,
    Object? organizationName = null,
    Object? organizationDisplayName = freezed,
    Object? logoUrl = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$ConversationOrganizationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationName: null == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationDisplayName: freezed == organizationDisplayName
          ? _value.organizationDisplayName
          : organizationDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationOrganizationDtoImpl
    implements _ConversationOrganizationDto {
  const _$ConversationOrganizationDtoImpl(
      {required this.id,
      required this.uuid,
      @JsonKey(name: 'company_name') required this.companyName,
      @JsonKey(name: 'organization_name') required this.organizationName,
      @JsonKey(name: 'organization_display_name') this.organizationDisplayName,
      @JsonKey(name: 'logo_url') this.logoUrl,
      @JsonKey(name: 'avatar_url') this.avatarUrl});

  factory _$ConversationOrganizationDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ConversationOrganizationDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String uuid;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'organization_name')
  final String organizationName;
  @override
  @JsonKey(name: 'organization_display_name')
  final String? organizationDisplayName;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  String toString() {
    return 'ConversationOrganizationDto(id: $id, uuid: $uuid, companyName: $companyName, organizationName: $organizationName, organizationDisplayName: $organizationDisplayName, logoUrl: $logoUrl, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationOrganizationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(
                    other.organizationDisplayName, organizationDisplayName) ||
                other.organizationDisplayName == organizationDisplayName) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, uuid, companyName,
      organizationName, organizationDisplayName, logoUrl, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationOrganizationDtoImplCopyWith<_$ConversationOrganizationDtoImpl>
      get copyWith => __$$ConversationOrganizationDtoImplCopyWithImpl<
          _$ConversationOrganizationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationOrganizationDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationOrganizationDto
    implements ConversationOrganizationDto {
  const factory _ConversationOrganizationDto(
          {required final int id,
          required final String uuid,
          @JsonKey(name: 'company_name') required final String companyName,
          @JsonKey(name: 'organization_name')
          required final String organizationName,
          @JsonKey(name: 'organization_display_name')
          final String? organizationDisplayName,
          @JsonKey(name: 'logo_url') final String? logoUrl,
          @JsonKey(name: 'avatar_url') final String? avatarUrl}) =
      _$ConversationOrganizationDtoImpl;

  factory _ConversationOrganizationDto.fromJson(Map<String, dynamic> json) =
      _$ConversationOrganizationDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get uuid;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'organization_name')
  String get organizationName;
  @override
  @JsonKey(name: 'organization_display_name')
  String? get organizationDisplayName;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$ConversationOrganizationDtoImplCopyWith<_$ConversationOrganizationDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConversationParticipantDto _$ConversationParticipantDtoFromJson(
    Map<String, dynamic> json) {
  return _ConversationParticipantDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationParticipantDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationParticipantDtoCopyWith<ConversationParticipantDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationParticipantDtoCopyWith<$Res> {
  factory $ConversationParticipantDtoCopyWith(ConversationParticipantDto value,
          $Res Function(ConversationParticipantDto) then) =
      _$ConversationParticipantDtoCopyWithImpl<$Res,
          ConversationParticipantDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      String email,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class _$ConversationParticipantDtoCopyWithImpl<$Res,
        $Val extends ConversationParticipantDto>
    implements $ConversationParticipantDtoCopyWith<$Res> {
  _$ConversationParticipantDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationParticipantDtoImplCopyWith<$Res>
    implements $ConversationParticipantDtoCopyWith<$Res> {
  factory _$$ConversationParticipantDtoImplCopyWith(
          _$ConversationParticipantDtoImpl value,
          $Res Function(_$ConversationParticipantDtoImpl) then) =
      __$$ConversationParticipantDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String email,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class __$$ConversationParticipantDtoImplCopyWithImpl<$Res>
    extends _$ConversationParticipantDtoCopyWithImpl<$Res,
        _$ConversationParticipantDtoImpl>
    implements _$$ConversationParticipantDtoImplCopyWith<$Res> {
  __$$ConversationParticipantDtoImplCopyWithImpl(
      _$ConversationParticipantDtoImpl _value,
      $Res Function(_$ConversationParticipantDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$ConversationParticipantDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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
class _$ConversationParticipantDtoImpl implements _ConversationParticipantDto {
  const _$ConversationParticipantDtoImpl(
      {required this.id,
      required this.name,
      required this.email,
      @JsonKey(name: 'avatar_url') this.avatarUrl});

  factory _$ConversationParticipantDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ConversationParticipantDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  String toString() {
    return 'ConversationParticipantDto(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationParticipantDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationParticipantDtoImplCopyWith<_$ConversationParticipantDtoImpl>
      get copyWith => __$$ConversationParticipantDtoImplCopyWithImpl<
          _$ConversationParticipantDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationParticipantDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationParticipantDto
    implements ConversationParticipantDto {
  const factory _ConversationParticipantDto(
          {required final int id,
          required final String name,
          required final String email,
          @JsonKey(name: 'avatar_url') final String? avatarUrl}) =
      _$ConversationParticipantDtoImpl;

  factory _ConversationParticipantDto.fromJson(Map<String, dynamic> json) =
      _$ConversationParticipantDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get email;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$ConversationParticipantDtoImplCopyWith<_$ConversationParticipantDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConversationEventDto _$ConversationEventDtoFromJson(Map<String, dynamic> json) {
  return _ConversationEventDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationEventDto {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationEventDtoCopyWith<ConversationEventDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationEventDtoCopyWith<$Res> {
  factory $ConversationEventDtoCopyWith(ConversationEventDto value,
          $Res Function(ConversationEventDto) then) =
      _$ConversationEventDtoCopyWithImpl<$Res, ConversationEventDto>;
  @useResult
  $Res call({int id, String uuid, String title, String slug});
}

/// @nodoc
class _$ConversationEventDtoCopyWithImpl<$Res,
        $Val extends ConversationEventDto>
    implements $ConversationEventDtoCopyWith<$Res> {
  _$ConversationEventDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? title = null,
    Object? slug = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationEventDtoImplCopyWith<$Res>
    implements $ConversationEventDtoCopyWith<$Res> {
  factory _$$ConversationEventDtoImplCopyWith(_$ConversationEventDtoImpl value,
          $Res Function(_$ConversationEventDtoImpl) then) =
      __$$ConversationEventDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String uuid, String title, String slug});
}

/// @nodoc
class __$$ConversationEventDtoImplCopyWithImpl<$Res>
    extends _$ConversationEventDtoCopyWithImpl<$Res, _$ConversationEventDtoImpl>
    implements _$$ConversationEventDtoImplCopyWith<$Res> {
  __$$ConversationEventDtoImplCopyWithImpl(_$ConversationEventDtoImpl _value,
      $Res Function(_$ConversationEventDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? title = null,
    Object? slug = null,
  }) {
    return _then(_$ConversationEventDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationEventDtoImpl implements _ConversationEventDto {
  const _$ConversationEventDtoImpl(
      {required this.id,
      required this.uuid,
      required this.title,
      required this.slug});

  factory _$ConversationEventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationEventDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String uuid;
  @override
  final String title;
  @override
  final String slug;

  @override
  String toString() {
    return 'ConversationEventDto(id: $id, uuid: $uuid, title: $title, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationEventDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, uuid, title, slug);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationEventDtoImplCopyWith<_$ConversationEventDtoImpl>
      get copyWith =>
          __$$ConversationEventDtoImplCopyWithImpl<_$ConversationEventDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationEventDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationEventDto implements ConversationEventDto {
  const factory _ConversationEventDto(
      {required final int id,
      required final String uuid,
      required final String title,
      required final String slug}) = _$ConversationEventDtoImpl;

  factory _ConversationEventDto.fromJson(Map<String, dynamic> json) =
      _$ConversationEventDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get uuid;
  @override
  String get title;
  @override
  String get slug;
  @override
  @JsonKey(ignore: true)
  _$$ConversationEventDtoImplCopyWith<_$ConversationEventDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) {
  return _ConversationDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationDto {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_label')
  String? get statusLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_type')
  String get conversationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'closed_at')
  String? get closedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_at')
  String? get lastMessageAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_signalement')
  bool get isSignalement => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_has_reported')
  bool get userHasReported => throw _privateConstructorUsedError;
  ConversationOrganizationDto? get organization =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_organization')
  ConversationOrganizationDto? get partnerOrganization =>
      throw _privateConstructorUsedError;
  ConversationParticipantDto? get participant =>
      throw _privateConstructorUsedError;
  ConversationEventDto? get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'latest_message')
  MessageDto? get latestMessage => throw _privateConstructorUsedError;
  List<MessageDto> get messages => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

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
      {int id,
      String uuid,
      String subject,
      String status,
      @JsonKey(name: 'status_label') String? statusLabel,
      @JsonKey(name: 'conversation_type') String conversationType,
      @JsonKey(name: 'closed_at') String? closedAt,
      @JsonKey(name: 'last_message_at') String? lastMessageAt,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'is_signalement') bool isSignalement,
      @JsonKey(name: 'user_has_reported') bool userHasReported,
      ConversationOrganizationDto? organization,
      @JsonKey(name: 'partner_organization')
      ConversationOrganizationDto? partnerOrganization,
      ConversationParticipantDto? participant,
      ConversationEventDto? event,
      @JsonKey(name: 'latest_message') MessageDto? latestMessage,
      List<MessageDto> messages,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});

  $ConversationOrganizationDtoCopyWith<$Res>? get organization;
  $ConversationOrganizationDtoCopyWith<$Res>? get partnerOrganization;
  $ConversationParticipantDtoCopyWith<$Res>? get participant;
  $ConversationEventDtoCopyWith<$Res>? get event;
  $MessageDtoCopyWith<$Res>? get latestMessage;
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
    Object? id = null,
    Object? uuid = null,
    Object? subject = null,
    Object? status = null,
    Object? statusLabel = freezed,
    Object? conversationType = null,
    Object? closedAt = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCount = null,
    Object? isSignalement = null,
    Object? userHasReported = null,
    Object? organization = freezed,
    Object? partnerOrganization = freezed,
    Object? participant = freezed,
    Object? event = freezed,
    Object? latestMessage = freezed,
    Object? messages = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusLabel: freezed == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      conversationType: null == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSignalement: null == isSignalement
          ? _value.isSignalement
          : isSignalement // ignore: cast_nullable_to_non_nullable
              as bool,
      userHasReported: null == userHasReported
          ? _value.userHasReported
          : userHasReported // ignore: cast_nullable_to_non_nullable
              as bool,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as ConversationOrganizationDto?,
      partnerOrganization: freezed == partnerOrganization
          ? _value.partnerOrganization
          : partnerOrganization // ignore: cast_nullable_to_non_nullable
              as ConversationOrganizationDto?,
      participant: freezed == participant
          ? _value.participant
          : participant // ignore: cast_nullable_to_non_nullable
              as ConversationParticipantDto?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as ConversationEventDto?,
      latestMessage: freezed == latestMessage
          ? _value.latestMessage
          : latestMessage // ignore: cast_nullable_to_non_nullable
              as MessageDto?,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDto>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationOrganizationDtoCopyWith<$Res>? get organization {
    if (_value.organization == null) {
      return null;
    }

    return $ConversationOrganizationDtoCopyWith<$Res>(_value.organization!,
        (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationOrganizationDtoCopyWith<$Res>? get partnerOrganization {
    if (_value.partnerOrganization == null) {
      return null;
    }

    return $ConversationOrganizationDtoCopyWith<$Res>(
        _value.partnerOrganization!, (value) {
      return _then(_value.copyWith(partnerOrganization: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationParticipantDtoCopyWith<$Res>? get participant {
    if (_value.participant == null) {
      return null;
    }

    return $ConversationParticipantDtoCopyWith<$Res>(_value.participant!,
        (value) {
      return _then(_value.copyWith(participant: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationEventDtoCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $ConversationEventDtoCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageDtoCopyWith<$Res>? get latestMessage {
    if (_value.latestMessage == null) {
      return null;
    }

    return $MessageDtoCopyWith<$Res>(_value.latestMessage!, (value) {
      return _then(_value.copyWith(latestMessage: value) as $Val);
    });
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
      {int id,
      String uuid,
      String subject,
      String status,
      @JsonKey(name: 'status_label') String? statusLabel,
      @JsonKey(name: 'conversation_type') String conversationType,
      @JsonKey(name: 'closed_at') String? closedAt,
      @JsonKey(name: 'last_message_at') String? lastMessageAt,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'is_signalement') bool isSignalement,
      @JsonKey(name: 'user_has_reported') bool userHasReported,
      ConversationOrganizationDto? organization,
      @JsonKey(name: 'partner_organization')
      ConversationOrganizationDto? partnerOrganization,
      ConversationParticipantDto? participant,
      ConversationEventDto? event,
      @JsonKey(name: 'latest_message') MessageDto? latestMessage,
      List<MessageDto> messages,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});

  @override
  $ConversationOrganizationDtoCopyWith<$Res>? get organization;
  @override
  $ConversationOrganizationDtoCopyWith<$Res>? get partnerOrganization;
  @override
  $ConversationParticipantDtoCopyWith<$Res>? get participant;
  @override
  $ConversationEventDtoCopyWith<$Res>? get event;
  @override
  $MessageDtoCopyWith<$Res>? get latestMessage;
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
    Object? id = null,
    Object? uuid = null,
    Object? subject = null,
    Object? status = null,
    Object? statusLabel = freezed,
    Object? conversationType = null,
    Object? closedAt = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCount = null,
    Object? isSignalement = null,
    Object? userHasReported = null,
    Object? organization = freezed,
    Object? partnerOrganization = freezed,
    Object? participant = freezed,
    Object? event = freezed,
    Object? latestMessage = freezed,
    Object? messages = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ConversationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusLabel: freezed == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      conversationType: null == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSignalement: null == isSignalement
          ? _value.isSignalement
          : isSignalement // ignore: cast_nullable_to_non_nullable
              as bool,
      userHasReported: null == userHasReported
          ? _value.userHasReported
          : userHasReported // ignore: cast_nullable_to_non_nullable
              as bool,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as ConversationOrganizationDto?,
      partnerOrganization: freezed == partnerOrganization
          ? _value.partnerOrganization
          : partnerOrganization // ignore: cast_nullable_to_non_nullable
              as ConversationOrganizationDto?,
      participant: freezed == participant
          ? _value.participant
          : participant // ignore: cast_nullable_to_non_nullable
              as ConversationParticipantDto?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as ConversationEventDto?,
      latestMessage: freezed == latestMessage
          ? _value.latestMessage
          : latestMessage // ignore: cast_nullable_to_non_nullable
              as MessageDto?,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDto>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationDtoImpl implements _ConversationDto {
  const _$ConversationDtoImpl(
      {required this.id,
      required this.uuid,
      required this.subject,
      required this.status,
      @JsonKey(name: 'status_label') this.statusLabel,
      @JsonKey(name: 'conversation_type') required this.conversationType,
      @JsonKey(name: 'closed_at') this.closedAt,
      @JsonKey(name: 'last_message_at') this.lastMessageAt,
      @JsonKey(name: 'unread_count') this.unreadCount = 0,
      @JsonKey(name: 'is_signalement') this.isSignalement = false,
      @JsonKey(name: 'user_has_reported') this.userHasReported = false,
      this.organization,
      @JsonKey(name: 'partner_organization') this.partnerOrganization,
      this.participant,
      this.event,
      @JsonKey(name: 'latest_message') this.latestMessage,
      final List<MessageDto> messages = const [],
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _messages = messages;

  factory _$ConversationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String uuid;
  @override
  final String subject;
  @override
  final String status;
  @override
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  @override
  @JsonKey(name: 'conversation_type')
  final String conversationType;
  @override
  @JsonKey(name: 'closed_at')
  final String? closedAt;
  @override
  @JsonKey(name: 'last_message_at')
  final String? lastMessageAt;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  @JsonKey(name: 'is_signalement')
  final bool isSignalement;
  @override
  @JsonKey(name: 'user_has_reported')
  final bool userHasReported;
  @override
  final ConversationOrganizationDto? organization;
  @override
  @JsonKey(name: 'partner_organization')
  final ConversationOrganizationDto? partnerOrganization;
  @override
  final ConversationParticipantDto? participant;
  @override
  final ConversationEventDto? event;
  @override
  @JsonKey(name: 'latest_message')
  final MessageDto? latestMessage;
  final List<MessageDto> _messages;
  @override
  @JsonKey()
  List<MessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'ConversationDto(id: $id, uuid: $uuid, subject: $subject, status: $status, statusLabel: $statusLabel, conversationType: $conversationType, closedAt: $closedAt, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount, isSignalement: $isSignalement, userHasReported: $userHasReported, organization: $organization, partnerOrganization: $partnerOrganization, participant: $participant, event: $event, latestMessage: $latestMessage, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isSignalement, isSignalement) ||
                other.isSignalement == isSignalement) &&
            (identical(other.userHasReported, userHasReported) ||
                other.userHasReported == userHasReported) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.partnerOrganization, partnerOrganization) ||
                other.partnerOrganization == partnerOrganization) &&
            (identical(other.participant, participant) ||
                other.participant == participant) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.latestMessage, latestMessage) ||
                other.latestMessage == latestMessage) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        uuid,
        subject,
        status,
        statusLabel,
        conversationType,
        closedAt,
        lastMessageAt,
        unreadCount,
        isSignalement,
        userHasReported,
        organization,
        partnerOrganization,
        participant,
        event,
        latestMessage,
        const DeepCollectionEquality().hash(_messages),
        createdAt,
        updatedAt
      ]);

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
          {required final int id,
          required final String uuid,
          required final String subject,
          required final String status,
          @JsonKey(name: 'status_label') final String? statusLabel,
          @JsonKey(name: 'conversation_type')
          required final String conversationType,
          @JsonKey(name: 'closed_at') final String? closedAt,
          @JsonKey(name: 'last_message_at') final String? lastMessageAt,
          @JsonKey(name: 'unread_count') final int unreadCount,
          @JsonKey(name: 'is_signalement') final bool isSignalement,
          @JsonKey(name: 'user_has_reported') final bool userHasReported,
          final ConversationOrganizationDto? organization,
          @JsonKey(name: 'partner_organization')
          final ConversationOrganizationDto? partnerOrganization,
          final ConversationParticipantDto? participant,
          final ConversationEventDto? event,
          @JsonKey(name: 'latest_message') final MessageDto? latestMessage,
          final List<MessageDto> messages,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$ConversationDtoImpl;

  factory _ConversationDto.fromJson(Map<String, dynamic> json) =
      _$ConversationDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get uuid;
  @override
  String get subject;
  @override
  String get status;
  @override
  @JsonKey(name: 'status_label')
  String? get statusLabel;
  @override
  @JsonKey(name: 'conversation_type')
  String get conversationType;
  @override
  @JsonKey(name: 'closed_at')
  String? get closedAt;
  @override
  @JsonKey(name: 'last_message_at')
  String? get lastMessageAt;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'is_signalement')
  bool get isSignalement;
  @override
  @JsonKey(name: 'user_has_reported')
  bool get userHasReported;
  @override
  ConversationOrganizationDto? get organization;
  @override
  @JsonKey(name: 'partner_organization')
  ConversationOrganizationDto? get partnerOrganization;
  @override
  ConversationParticipantDto? get participant;
  @override
  ConversationEventDto? get event;
  @override
  @JsonKey(name: 'latest_message')
  MessageDto? get latestMessage;
  @override
  List<MessageDto> get messages;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationDtoImplCopyWith<_$ConversationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
