// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thematique_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThematiqueDto _$ThematiqueDtoFromJson(Map<String, dynamic> json) {
  return _ThematiqueDto.fromJson(json);
}

/// @nodoc
mixin _$ThematiqueDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  ThematiqueImageDto? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_count')
  int? get eventCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThematiqueDtoCopyWith<ThematiqueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThematiqueDtoCopyWith<$Res> {
  factory $ThematiqueDtoCopyWith(
          ThematiqueDto value, $Res Function(ThematiqueDto) then) =
      _$ThematiqueDtoCopyWithImpl<$Res, ThematiqueDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      String? description,
      String? icon,
      ThematiqueImageDto? image,
      @JsonKey(name: 'event_count') int? eventCount});

  $ThematiqueImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class _$ThematiqueDtoCopyWithImpl<$Res, $Val extends ThematiqueDto>
    implements $ThematiqueDtoCopyWith<$Res> {
  _$ThematiqueDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? image = freezed,
    Object? eventCount = freezed,
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ThematiqueImageDto?,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ThematiqueImageDtoCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $ThematiqueImageDtoCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ThematiqueDtoImplCopyWith<$Res>
    implements $ThematiqueDtoCopyWith<$Res> {
  factory _$$ThematiqueDtoImplCopyWith(
          _$ThematiqueDtoImpl value, $Res Function(_$ThematiqueDtoImpl) then) =
      __$$ThematiqueDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      String? description,
      String? icon,
      ThematiqueImageDto? image,
      @JsonKey(name: 'event_count') int? eventCount});

  @override
  $ThematiqueImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class __$$ThematiqueDtoImplCopyWithImpl<$Res>
    extends _$ThematiqueDtoCopyWithImpl<$Res, _$ThematiqueDtoImpl>
    implements _$$ThematiqueDtoImplCopyWith<$Res> {
  __$$ThematiqueDtoImplCopyWithImpl(
      _$ThematiqueDtoImpl _value, $Res Function(_$ThematiqueDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? image = freezed,
    Object? eventCount = freezed,
  }) {
    return _then(_$ThematiqueDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ThematiqueImageDto?,
      eventCount: freezed == eventCount
          ? _value.eventCount
          : eventCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThematiqueDtoImpl implements _ThematiqueDto {
  const _$ThematiqueDtoImpl(
      {required this.id,
      required this.name,
      required this.slug,
      this.description,
      this.icon,
      this.image,
      @JsonKey(name: 'event_count') this.eventCount});

  factory _$ThematiqueDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThematiqueDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  final ThematiqueImageDto? image;
  @override
  @JsonKey(name: 'event_count')
  final int? eventCount;

  @override
  String toString() {
    return 'ThematiqueDto(id: $id, name: $name, slug: $slug, description: $description, icon: $icon, image: $image, eventCount: $eventCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThematiqueDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, slug, description, icon, image, eventCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThematiqueDtoImplCopyWith<_$ThematiqueDtoImpl> get copyWith =>
      __$$ThematiqueDtoImplCopyWithImpl<_$ThematiqueDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThematiqueDtoImplToJson(
      this,
    );
  }
}

abstract class _ThematiqueDto implements ThematiqueDto {
  const factory _ThematiqueDto(
          {required final int id,
          required final String name,
          required final String slug,
          final String? description,
          final String? icon,
          final ThematiqueImageDto? image,
          @JsonKey(name: 'event_count') final int? eventCount}) =
      _$ThematiqueDtoImpl;

  factory _ThematiqueDto.fromJson(Map<String, dynamic> json) =
      _$ThematiqueDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  ThematiqueImageDto? get image;
  @override
  @JsonKey(name: 'event_count')
  int? get eventCount;
  @override
  @JsonKey(ignore: true)
  _$$ThematiqueDtoImplCopyWith<_$ThematiqueDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThematiqueImageDto _$ThematiqueImageDtoFromJson(Map<String, dynamic> json) {
  return _ThematiqueImageDto.fromJson(json);
}

/// @nodoc
mixin _$ThematiqueImageDto {
  int? get id => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String? get medium => throw _privateConstructorUsedError;
  String? get large => throw _privateConstructorUsedError;
  String? get full => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThematiqueImageDtoCopyWith<ThematiqueImageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThematiqueImageDtoCopyWith<$Res> {
  factory $ThematiqueImageDtoCopyWith(
          ThematiqueImageDto value, $Res Function(ThematiqueImageDto) then) =
      _$ThematiqueImageDtoCopyWithImpl<$Res, ThematiqueImageDto>;
  @useResult
  $Res call(
      {int? id,
      String? thumbnail,
      String? medium,
      String? large,
      String? full});
}

/// @nodoc
class _$ThematiqueImageDtoCopyWithImpl<$Res, $Val extends ThematiqueImageDto>
    implements $ThematiqueImageDtoCopyWith<$Res> {
  _$ThematiqueImageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? thumbnail = freezed,
    Object? medium = freezed,
    Object? large = freezed,
    Object? full = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      large: freezed == large
          ? _value.large
          : large // ignore: cast_nullable_to_non_nullable
              as String?,
      full: freezed == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThematiqueImageDtoImplCopyWith<$Res>
    implements $ThematiqueImageDtoCopyWith<$Res> {
  factory _$$ThematiqueImageDtoImplCopyWith(_$ThematiqueImageDtoImpl value,
          $Res Function(_$ThematiqueImageDtoImpl) then) =
      __$$ThematiqueImageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? thumbnail,
      String? medium,
      String? large,
      String? full});
}

/// @nodoc
class __$$ThematiqueImageDtoImplCopyWithImpl<$Res>
    extends _$ThematiqueImageDtoCopyWithImpl<$Res, _$ThematiqueImageDtoImpl>
    implements _$$ThematiqueImageDtoImplCopyWith<$Res> {
  __$$ThematiqueImageDtoImplCopyWithImpl(_$ThematiqueImageDtoImpl _value,
      $Res Function(_$ThematiqueImageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? thumbnail = freezed,
    Object? medium = freezed,
    Object? large = freezed,
    Object? full = freezed,
  }) {
    return _then(_$ThematiqueImageDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      large: freezed == large
          ? _value.large
          : large // ignore: cast_nullable_to_non_nullable
              as String?,
      full: freezed == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThematiqueImageDtoImpl implements _ThematiqueImageDto {
  const _$ThematiqueImageDtoImpl(
      {this.id, this.thumbnail, this.medium, this.large, this.full});

  factory _$ThematiqueImageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThematiqueImageDtoImplFromJson(json);

  @override
  final int? id;
  @override
  final String? thumbnail;
  @override
  final String? medium;
  @override
  final String? large;
  @override
  final String? full;

  @override
  String toString() {
    return 'ThematiqueImageDto(id: $id, thumbnail: $thumbnail, medium: $medium, large: $large, full: $full)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThematiqueImageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.full, full) || other.full == full));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, thumbnail, medium, large, full);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThematiqueImageDtoImplCopyWith<_$ThematiqueImageDtoImpl> get copyWith =>
      __$$ThematiqueImageDtoImplCopyWithImpl<_$ThematiqueImageDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThematiqueImageDtoImplToJson(
      this,
    );
  }
}

abstract class _ThematiqueImageDto implements ThematiqueImageDto {
  const factory _ThematiqueImageDto(
      {final int? id,
      final String? thumbnail,
      final String? medium,
      final String? large,
      final String? full}) = _$ThematiqueImageDtoImpl;

  factory _ThematiqueImageDto.fromJson(Map<String, dynamic> json) =
      _$ThematiqueImageDtoImpl.fromJson;

  @override
  int? get id;
  @override
  String? get thumbnail;
  @override
  String? get medium;
  @override
  String? get large;
  @override
  String? get full;
  @override
  @JsonKey(ignore: true)
  _$$ThematiqueImageDtoImplCopyWith<_$ThematiqueImageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThematiquesResponseDto _$ThematiquesResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _ThematiquesResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ThematiquesResponseDto {
  List<ThematiqueDto> get thematiques => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThematiquesResponseDtoCopyWith<ThematiquesResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThematiquesResponseDtoCopyWith<$Res> {
  factory $ThematiquesResponseDtoCopyWith(ThematiquesResponseDto value,
          $Res Function(ThematiquesResponseDto) then) =
      _$ThematiquesResponseDtoCopyWithImpl<$Res, ThematiquesResponseDto>;
  @useResult
  $Res call({List<ThematiqueDto> thematiques, int count});
}

/// @nodoc
class _$ThematiquesResponseDtoCopyWithImpl<$Res,
        $Val extends ThematiquesResponseDto>
    implements $ThematiquesResponseDtoCopyWith<$Res> {
  _$ThematiquesResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thematiques = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      thematiques: null == thematiques
          ? _value.thematiques
          : thematiques // ignore: cast_nullable_to_non_nullable
              as List<ThematiqueDto>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThematiquesResponseDtoImplCopyWith<$Res>
    implements $ThematiquesResponseDtoCopyWith<$Res> {
  factory _$$ThematiquesResponseDtoImplCopyWith(
          _$ThematiquesResponseDtoImpl value,
          $Res Function(_$ThematiquesResponseDtoImpl) then) =
      __$$ThematiquesResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ThematiqueDto> thematiques, int count});
}

/// @nodoc
class __$$ThematiquesResponseDtoImplCopyWithImpl<$Res>
    extends _$ThematiquesResponseDtoCopyWithImpl<$Res,
        _$ThematiquesResponseDtoImpl>
    implements _$$ThematiquesResponseDtoImplCopyWith<$Res> {
  __$$ThematiquesResponseDtoImplCopyWithImpl(
      _$ThematiquesResponseDtoImpl _value,
      $Res Function(_$ThematiquesResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thematiques = null,
    Object? count = null,
  }) {
    return _then(_$ThematiquesResponseDtoImpl(
      thematiques: null == thematiques
          ? _value._thematiques
          : thematiques // ignore: cast_nullable_to_non_nullable
              as List<ThematiqueDto>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThematiquesResponseDtoImpl implements _ThematiquesResponseDto {
  const _$ThematiquesResponseDtoImpl(
      {required final List<ThematiqueDto> thematiques, required this.count})
      : _thematiques = thematiques;

  factory _$ThematiquesResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThematiquesResponseDtoImplFromJson(json);

  final List<ThematiqueDto> _thematiques;
  @override
  List<ThematiqueDto> get thematiques {
    if (_thematiques is EqualUnmodifiableListView) return _thematiques;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thematiques);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'ThematiquesResponseDto(thematiques: $thematiques, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThematiquesResponseDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._thematiques, _thematiques) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_thematiques), count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThematiquesResponseDtoImplCopyWith<_$ThematiquesResponseDtoImpl>
      get copyWith => __$$ThematiquesResponseDtoImplCopyWithImpl<
          _$ThematiquesResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThematiquesResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _ThematiquesResponseDto implements ThematiquesResponseDto {
  const factory _ThematiquesResponseDto(
      {required final List<ThematiqueDto> thematiques,
      required final int count}) = _$ThematiquesResponseDtoImpl;

  factory _ThematiquesResponseDto.fromJson(Map<String, dynamic> json) =
      _$ThematiquesResponseDtoImpl.fromJson;

  @override
  List<ThematiqueDto> get thematiques;
  @override
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$ThematiquesResponseDtoImplCopyWith<_$ThematiquesResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
