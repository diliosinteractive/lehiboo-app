// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_schema_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToolSchemaDto _$ToolSchemaDtoFromJson(Map<String, dynamic> json) {
  return _ToolSchemaDto.fromJson(json);
}

/// @nodoc
mixin _$ToolSchemaDto {
  /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
  String get name => throw _privateConstructorUsedError;

  /// Human-readable description
  String get description => throw _privateConstructorUsedError;

  /// Display type for the UI (event_list, booking_list, profile, stats, detail)
  @JsonKey(name: 'display_type')
  String get displayType => throw _privateConstructorUsedError;

  /// Material icon name (e.g., 'favorite', 'search', 'person')
  String get icon => throw _privateConstructorUsedError;

  /// Accent color as hex (e.g., '#FF5252')
  String? get color => throw _privateConstructorUsedError;

  /// Title shown in the card header
  String? get title => throw _privateConstructorUsedError;

  /// Empty state message when no data
  @JsonKey(name: 'empty_message')
  String? get emptyMessage => throw _privateConstructorUsedError;

  /// Schema for parsing the response
  @JsonKey(name: 'response_schema')
  ToolResponseSchemaDto? get responseSchema =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolSchemaDtoCopyWith<ToolSchemaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolSchemaDtoCopyWith<$Res> {
  factory $ToolSchemaDtoCopyWith(
          ToolSchemaDto value, $Res Function(ToolSchemaDto) then) =
      _$ToolSchemaDtoCopyWithImpl<$Res, ToolSchemaDto>;
  @useResult
  $Res call(
      {String name,
      String description,
      @JsonKey(name: 'display_type') String displayType,
      String icon,
      String? color,
      String? title,
      @JsonKey(name: 'empty_message') String? emptyMessage,
      @JsonKey(name: 'response_schema') ToolResponseSchemaDto? responseSchema});

  $ToolResponseSchemaDtoCopyWith<$Res>? get responseSchema;
}

/// @nodoc
class _$ToolSchemaDtoCopyWithImpl<$Res, $Val extends ToolSchemaDto>
    implements $ToolSchemaDtoCopyWith<$Res> {
  _$ToolSchemaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? displayType = null,
    Object? icon = null,
    Object? color = freezed,
    Object? title = freezed,
    Object? emptyMessage = freezed,
    Object? responseSchema = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      displayType: null == displayType
          ? _value.displayType
          : displayType // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      emptyMessage: freezed == emptyMessage
          ? _value.emptyMessage
          : emptyMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseSchema: freezed == responseSchema
          ? _value.responseSchema
          : responseSchema // ignore: cast_nullable_to_non_nullable
              as ToolResponseSchemaDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ToolResponseSchemaDtoCopyWith<$Res>? get responseSchema {
    if (_value.responseSchema == null) {
      return null;
    }

    return $ToolResponseSchemaDtoCopyWith<$Res>(_value.responseSchema!,
        (value) {
      return _then(_value.copyWith(responseSchema: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ToolSchemaDtoImplCopyWith<$Res>
    implements $ToolSchemaDtoCopyWith<$Res> {
  factory _$$ToolSchemaDtoImplCopyWith(
          _$ToolSchemaDtoImpl value, $Res Function(_$ToolSchemaDtoImpl) then) =
      __$$ToolSchemaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      @JsonKey(name: 'display_type') String displayType,
      String icon,
      String? color,
      String? title,
      @JsonKey(name: 'empty_message') String? emptyMessage,
      @JsonKey(name: 'response_schema') ToolResponseSchemaDto? responseSchema});

  @override
  $ToolResponseSchemaDtoCopyWith<$Res>? get responseSchema;
}

/// @nodoc
class __$$ToolSchemaDtoImplCopyWithImpl<$Res>
    extends _$ToolSchemaDtoCopyWithImpl<$Res, _$ToolSchemaDtoImpl>
    implements _$$ToolSchemaDtoImplCopyWith<$Res> {
  __$$ToolSchemaDtoImplCopyWithImpl(
      _$ToolSchemaDtoImpl _value, $Res Function(_$ToolSchemaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? displayType = null,
    Object? icon = null,
    Object? color = freezed,
    Object? title = freezed,
    Object? emptyMessage = freezed,
    Object? responseSchema = freezed,
  }) {
    return _then(_$ToolSchemaDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      displayType: null == displayType
          ? _value.displayType
          : displayType // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      emptyMessage: freezed == emptyMessage
          ? _value.emptyMessage
          : emptyMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseSchema: freezed == responseSchema
          ? _value.responseSchema
          : responseSchema // ignore: cast_nullable_to_non_nullable
              as ToolResponseSchemaDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolSchemaDtoImpl implements _ToolSchemaDto {
  const _$ToolSchemaDtoImpl(
      {required this.name,
      required this.description,
      @JsonKey(name: 'display_type') this.displayType = 'list',
      this.icon = 'extension',
      this.color,
      this.title,
      @JsonKey(name: 'empty_message') this.emptyMessage,
      @JsonKey(name: 'response_schema') this.responseSchema});

  factory _$ToolSchemaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolSchemaDtoImplFromJson(json);

  /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
  @override
  final String name;

  /// Human-readable description
  @override
  final String description;

  /// Display type for the UI (event_list, booking_list, profile, stats, detail)
  @override
  @JsonKey(name: 'display_type')
  final String displayType;

  /// Material icon name (e.g., 'favorite', 'search', 'person')
  @override
  @JsonKey()
  final String icon;

  /// Accent color as hex (e.g., '#FF5252')
  @override
  final String? color;

  /// Title shown in the card header
  @override
  final String? title;

  /// Empty state message when no data
  @override
  @JsonKey(name: 'empty_message')
  final String? emptyMessage;

  /// Schema for parsing the response
  @override
  @JsonKey(name: 'response_schema')
  final ToolResponseSchemaDto? responseSchema;

  @override
  String toString() {
    return 'ToolSchemaDto(name: $name, description: $description, displayType: $displayType, icon: $icon, color: $color, title: $title, emptyMessage: $emptyMessage, responseSchema: $responseSchema)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolSchemaDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displayType, displayType) ||
                other.displayType == displayType) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.emptyMessage, emptyMessage) ||
                other.emptyMessage == emptyMessage) &&
            (identical(other.responseSchema, responseSchema) ||
                other.responseSchema == responseSchema));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, displayType,
      icon, color, title, emptyMessage, responseSchema);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolSchemaDtoImplCopyWith<_$ToolSchemaDtoImpl> get copyWith =>
      __$$ToolSchemaDtoImplCopyWithImpl<_$ToolSchemaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolSchemaDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolSchemaDto implements ToolSchemaDto {
  const factory _ToolSchemaDto(
      {required final String name,
      required final String description,
      @JsonKey(name: 'display_type') final String displayType,
      final String icon,
      final String? color,
      final String? title,
      @JsonKey(name: 'empty_message') final String? emptyMessage,
      @JsonKey(name: 'response_schema')
      final ToolResponseSchemaDto? responseSchema}) = _$ToolSchemaDtoImpl;

  factory _ToolSchemaDto.fromJson(Map<String, dynamic> json) =
      _$ToolSchemaDtoImpl.fromJson;

  @override

  /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
  String get name;
  @override

  /// Human-readable description
  String get description;
  @override

  /// Display type for the UI (event_list, booking_list, profile, stats, detail)
  @JsonKey(name: 'display_type')
  String get displayType;
  @override

  /// Material icon name (e.g., 'favorite', 'search', 'person')
  String get icon;
  @override

  /// Accent color as hex (e.g., '#FF5252')
  String? get color;
  @override

  /// Title shown in the card header
  String? get title;
  @override

  /// Empty state message when no data
  @JsonKey(name: 'empty_message')
  String? get emptyMessage;
  @override

  /// Schema for parsing the response
  @JsonKey(name: 'response_schema')
  ToolResponseSchemaDto? get responseSchema;
  @override
  @JsonKey(ignore: true)
  _$$ToolSchemaDtoImplCopyWith<_$ToolSchemaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToolResponseSchemaDto _$ToolResponseSchemaDtoFromJson(
    Map<String, dynamic> json) {
  return _ToolResponseSchemaDto.fromJson(json);
}

/// @nodoc
mixin _$ToolResponseSchemaDto {
  /// Key for the items list in response (e.g., 'favorites', 'events', 'bookings')
  @JsonKey(name: 'items_key')
  String? get itemsKey => throw _privateConstructorUsedError;

  /// Key for total count
  @JsonKey(name: 'total_key')
  String? get totalKey => throw _privateConstructorUsedError;

  /// Key for a single item (for detail views)
  @JsonKey(name: 'item_key')
  String? get itemKey => throw _privateConstructorUsedError;

  /// Schema for list items
  @JsonKey(name: 'item_schema')
  ToolItemSchemaDto? get itemSchema => throw _privateConstructorUsedError;

  /// Stats to display (for profile/stats views)
  List<ToolStatSchemaDto>? get stats => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolResponseSchemaDtoCopyWith<ToolResponseSchemaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolResponseSchemaDtoCopyWith<$Res> {
  factory $ToolResponseSchemaDtoCopyWith(ToolResponseSchemaDto value,
          $Res Function(ToolResponseSchemaDto) then) =
      _$ToolResponseSchemaDtoCopyWithImpl<$Res, ToolResponseSchemaDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'items_key') String? itemsKey,
      @JsonKey(name: 'total_key') String? totalKey,
      @JsonKey(name: 'item_key') String? itemKey,
      @JsonKey(name: 'item_schema') ToolItemSchemaDto? itemSchema,
      List<ToolStatSchemaDto>? stats});

  $ToolItemSchemaDtoCopyWith<$Res>? get itemSchema;
}

/// @nodoc
class _$ToolResponseSchemaDtoCopyWithImpl<$Res,
        $Val extends ToolResponseSchemaDto>
    implements $ToolResponseSchemaDtoCopyWith<$Res> {
  _$ToolResponseSchemaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsKey = freezed,
    Object? totalKey = freezed,
    Object? itemKey = freezed,
    Object? itemSchema = freezed,
    Object? stats = freezed,
  }) {
    return _then(_value.copyWith(
      itemsKey: freezed == itemsKey
          ? _value.itemsKey
          : itemsKey // ignore: cast_nullable_to_non_nullable
              as String?,
      totalKey: freezed == totalKey
          ? _value.totalKey
          : totalKey // ignore: cast_nullable_to_non_nullable
              as String?,
      itemKey: freezed == itemKey
          ? _value.itemKey
          : itemKey // ignore: cast_nullable_to_non_nullable
              as String?,
      itemSchema: freezed == itemSchema
          ? _value.itemSchema
          : itemSchema // ignore: cast_nullable_to_non_nullable
              as ToolItemSchemaDto?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<ToolStatSchemaDto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ToolItemSchemaDtoCopyWith<$Res>? get itemSchema {
    if (_value.itemSchema == null) {
      return null;
    }

    return $ToolItemSchemaDtoCopyWith<$Res>(_value.itemSchema!, (value) {
      return _then(_value.copyWith(itemSchema: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ToolResponseSchemaDtoImplCopyWith<$Res>
    implements $ToolResponseSchemaDtoCopyWith<$Res> {
  factory _$$ToolResponseSchemaDtoImplCopyWith(
          _$ToolResponseSchemaDtoImpl value,
          $Res Function(_$ToolResponseSchemaDtoImpl) then) =
      __$$ToolResponseSchemaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'items_key') String? itemsKey,
      @JsonKey(name: 'total_key') String? totalKey,
      @JsonKey(name: 'item_key') String? itemKey,
      @JsonKey(name: 'item_schema') ToolItemSchemaDto? itemSchema,
      List<ToolStatSchemaDto>? stats});

  @override
  $ToolItemSchemaDtoCopyWith<$Res>? get itemSchema;
}

/// @nodoc
class __$$ToolResponseSchemaDtoImplCopyWithImpl<$Res>
    extends _$ToolResponseSchemaDtoCopyWithImpl<$Res,
        _$ToolResponseSchemaDtoImpl>
    implements _$$ToolResponseSchemaDtoImplCopyWith<$Res> {
  __$$ToolResponseSchemaDtoImplCopyWithImpl(_$ToolResponseSchemaDtoImpl _value,
      $Res Function(_$ToolResponseSchemaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsKey = freezed,
    Object? totalKey = freezed,
    Object? itemKey = freezed,
    Object? itemSchema = freezed,
    Object? stats = freezed,
  }) {
    return _then(_$ToolResponseSchemaDtoImpl(
      itemsKey: freezed == itemsKey
          ? _value.itemsKey
          : itemsKey // ignore: cast_nullable_to_non_nullable
              as String?,
      totalKey: freezed == totalKey
          ? _value.totalKey
          : totalKey // ignore: cast_nullable_to_non_nullable
              as String?,
      itemKey: freezed == itemKey
          ? _value.itemKey
          : itemKey // ignore: cast_nullable_to_non_nullable
              as String?,
      itemSchema: freezed == itemSchema
          ? _value.itemSchema
          : itemSchema // ignore: cast_nullable_to_non_nullable
              as ToolItemSchemaDto?,
      stats: freezed == stats
          ? _value._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<ToolStatSchemaDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolResponseSchemaDtoImpl implements _ToolResponseSchemaDto {
  const _$ToolResponseSchemaDtoImpl(
      {@JsonKey(name: 'items_key') this.itemsKey,
      @JsonKey(name: 'total_key') this.totalKey,
      @JsonKey(name: 'item_key') this.itemKey,
      @JsonKey(name: 'item_schema') this.itemSchema,
      final List<ToolStatSchemaDto>? stats})
      : _stats = stats;

  factory _$ToolResponseSchemaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolResponseSchemaDtoImplFromJson(json);

  /// Key for the items list in response (e.g., 'favorites', 'events', 'bookings')
  @override
  @JsonKey(name: 'items_key')
  final String? itemsKey;

  /// Key for total count
  @override
  @JsonKey(name: 'total_key')
  final String? totalKey;

  /// Key for a single item (for detail views)
  @override
  @JsonKey(name: 'item_key')
  final String? itemKey;

  /// Schema for list items
  @override
  @JsonKey(name: 'item_schema')
  final ToolItemSchemaDto? itemSchema;

  /// Stats to display (for profile/stats views)
  final List<ToolStatSchemaDto>? _stats;

  /// Stats to display (for profile/stats views)
  @override
  List<ToolStatSchemaDto>? get stats {
    final value = _stats;
    if (value == null) return null;
    if (_stats is EqualUnmodifiableListView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ToolResponseSchemaDto(itemsKey: $itemsKey, totalKey: $totalKey, itemKey: $itemKey, itemSchema: $itemSchema, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolResponseSchemaDtoImpl &&
            (identical(other.itemsKey, itemsKey) ||
                other.itemsKey == itemsKey) &&
            (identical(other.totalKey, totalKey) ||
                other.totalKey == totalKey) &&
            (identical(other.itemKey, itemKey) || other.itemKey == itemKey) &&
            (identical(other.itemSchema, itemSchema) ||
                other.itemSchema == itemSchema) &&
            const DeepCollectionEquality().equals(other._stats, _stats));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, itemsKey, totalKey, itemKey,
      itemSchema, const DeepCollectionEquality().hash(_stats));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolResponseSchemaDtoImplCopyWith<_$ToolResponseSchemaDtoImpl>
      get copyWith => __$$ToolResponseSchemaDtoImplCopyWithImpl<
          _$ToolResponseSchemaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolResponseSchemaDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolResponseSchemaDto implements ToolResponseSchemaDto {
  const factory _ToolResponseSchemaDto(
      {@JsonKey(name: 'items_key') final String? itemsKey,
      @JsonKey(name: 'total_key') final String? totalKey,
      @JsonKey(name: 'item_key') final String? itemKey,
      @JsonKey(name: 'item_schema') final ToolItemSchemaDto? itemSchema,
      final List<ToolStatSchemaDto>? stats}) = _$ToolResponseSchemaDtoImpl;

  factory _ToolResponseSchemaDto.fromJson(Map<String, dynamic> json) =
      _$ToolResponseSchemaDtoImpl.fromJson;

  @override

  /// Key for the items list in response (e.g., 'favorites', 'events', 'bookings')
  @JsonKey(name: 'items_key')
  String? get itemsKey;
  @override

  /// Key for total count
  @JsonKey(name: 'total_key')
  String? get totalKey;
  @override

  /// Key for a single item (for detail views)
  @JsonKey(name: 'item_key')
  String? get itemKey;
  @override

  /// Schema for list items
  @JsonKey(name: 'item_schema')
  ToolItemSchemaDto? get itemSchema;
  @override

  /// Stats to display (for profile/stats views)
  List<ToolStatSchemaDto>? get stats;
  @override
  @JsonKey(ignore: true)
  _$$ToolResponseSchemaDtoImplCopyWith<_$ToolResponseSchemaDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ToolItemSchemaDto _$ToolItemSchemaDtoFromJson(Map<String, dynamic> json) {
  return _ToolItemSchemaDto.fromJson(json);
}

/// @nodoc
mixin _$ToolItemSchemaDto {
  /// Field name for item title
  @JsonKey(name: 'title_field')
  String? get titleField => throw _privateConstructorUsedError;

  /// Field name for subtitle
  @JsonKey(name: 'subtitle_field')
  String? get subtitleField => throw _privateConstructorUsedError;

  /// Field name for image URL
  @JsonKey(name: 'image_field')
  String? get imageField => throw _privateConstructorUsedError;

  /// Field name for date display
  @JsonKey(name: 'date_field')
  String? get dateField => throw _privateConstructorUsedError;

  /// Field name for time display
  @JsonKey(name: 'time_field')
  String? get timeField => throw _privateConstructorUsedError;

  /// Field name for price display
  @JsonKey(name: 'price_field')
  String? get priceField => throw _privateConstructorUsedError;

  /// Field name for status (for bookings, tickets)
  @JsonKey(name: 'status_field')
  String? get statusField => throw _privateConstructorUsedError;

  /// Field name for badge text (e.g., 'Gratuit')
  @JsonKey(name: 'badge_field')
  String? get badgeField => throw _privateConstructorUsedError;

  /// Field name for badge condition (e.g., 'is_free')
  @JsonKey(name: 'badge_condition_field')
  String? get badgeConditionField => throw _privateConstructorUsedError;

  /// Badge text to show when condition is true
  @JsonKey(name: 'badge_text')
  String? get badgeText => throw _privateConstructorUsedError;

  /// Navigation configuration
  ToolNavigationDto? get navigation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolItemSchemaDtoCopyWith<ToolItemSchemaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolItemSchemaDtoCopyWith<$Res> {
  factory $ToolItemSchemaDtoCopyWith(
          ToolItemSchemaDto value, $Res Function(ToolItemSchemaDto) then) =
      _$ToolItemSchemaDtoCopyWithImpl<$Res, ToolItemSchemaDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'title_field') String? titleField,
      @JsonKey(name: 'subtitle_field') String? subtitleField,
      @JsonKey(name: 'image_field') String? imageField,
      @JsonKey(name: 'date_field') String? dateField,
      @JsonKey(name: 'time_field') String? timeField,
      @JsonKey(name: 'price_field') String? priceField,
      @JsonKey(name: 'status_field') String? statusField,
      @JsonKey(name: 'badge_field') String? badgeField,
      @JsonKey(name: 'badge_condition_field') String? badgeConditionField,
      @JsonKey(name: 'badge_text') String? badgeText,
      ToolNavigationDto? navigation});

  $ToolNavigationDtoCopyWith<$Res>? get navigation;
}

/// @nodoc
class _$ToolItemSchemaDtoCopyWithImpl<$Res, $Val extends ToolItemSchemaDto>
    implements $ToolItemSchemaDtoCopyWith<$Res> {
  _$ToolItemSchemaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titleField = freezed,
    Object? subtitleField = freezed,
    Object? imageField = freezed,
    Object? dateField = freezed,
    Object? timeField = freezed,
    Object? priceField = freezed,
    Object? statusField = freezed,
    Object? badgeField = freezed,
    Object? badgeConditionField = freezed,
    Object? badgeText = freezed,
    Object? navigation = freezed,
  }) {
    return _then(_value.copyWith(
      titleField: freezed == titleField
          ? _value.titleField
          : titleField // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitleField: freezed == subtitleField
          ? _value.subtitleField
          : subtitleField // ignore: cast_nullable_to_non_nullable
              as String?,
      imageField: freezed == imageField
          ? _value.imageField
          : imageField // ignore: cast_nullable_to_non_nullable
              as String?,
      dateField: freezed == dateField
          ? _value.dateField
          : dateField // ignore: cast_nullable_to_non_nullable
              as String?,
      timeField: freezed == timeField
          ? _value.timeField
          : timeField // ignore: cast_nullable_to_non_nullable
              as String?,
      priceField: freezed == priceField
          ? _value.priceField
          : priceField // ignore: cast_nullable_to_non_nullable
              as String?,
      statusField: freezed == statusField
          ? _value.statusField
          : statusField // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeField: freezed == badgeField
          ? _value.badgeField
          : badgeField // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeConditionField: freezed == badgeConditionField
          ? _value.badgeConditionField
          : badgeConditionField // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeText: freezed == badgeText
          ? _value.badgeText
          : badgeText // ignore: cast_nullable_to_non_nullable
              as String?,
      navigation: freezed == navigation
          ? _value.navigation
          : navigation // ignore: cast_nullable_to_non_nullable
              as ToolNavigationDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ToolNavigationDtoCopyWith<$Res>? get navigation {
    if (_value.navigation == null) {
      return null;
    }

    return $ToolNavigationDtoCopyWith<$Res>(_value.navigation!, (value) {
      return _then(_value.copyWith(navigation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ToolItemSchemaDtoImplCopyWith<$Res>
    implements $ToolItemSchemaDtoCopyWith<$Res> {
  factory _$$ToolItemSchemaDtoImplCopyWith(_$ToolItemSchemaDtoImpl value,
          $Res Function(_$ToolItemSchemaDtoImpl) then) =
      __$$ToolItemSchemaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'title_field') String? titleField,
      @JsonKey(name: 'subtitle_field') String? subtitleField,
      @JsonKey(name: 'image_field') String? imageField,
      @JsonKey(name: 'date_field') String? dateField,
      @JsonKey(name: 'time_field') String? timeField,
      @JsonKey(name: 'price_field') String? priceField,
      @JsonKey(name: 'status_field') String? statusField,
      @JsonKey(name: 'badge_field') String? badgeField,
      @JsonKey(name: 'badge_condition_field') String? badgeConditionField,
      @JsonKey(name: 'badge_text') String? badgeText,
      ToolNavigationDto? navigation});

  @override
  $ToolNavigationDtoCopyWith<$Res>? get navigation;
}

/// @nodoc
class __$$ToolItemSchemaDtoImplCopyWithImpl<$Res>
    extends _$ToolItemSchemaDtoCopyWithImpl<$Res, _$ToolItemSchemaDtoImpl>
    implements _$$ToolItemSchemaDtoImplCopyWith<$Res> {
  __$$ToolItemSchemaDtoImplCopyWithImpl(_$ToolItemSchemaDtoImpl _value,
      $Res Function(_$ToolItemSchemaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titleField = freezed,
    Object? subtitleField = freezed,
    Object? imageField = freezed,
    Object? dateField = freezed,
    Object? timeField = freezed,
    Object? priceField = freezed,
    Object? statusField = freezed,
    Object? badgeField = freezed,
    Object? badgeConditionField = freezed,
    Object? badgeText = freezed,
    Object? navigation = freezed,
  }) {
    return _then(_$ToolItemSchemaDtoImpl(
      titleField: freezed == titleField
          ? _value.titleField
          : titleField // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitleField: freezed == subtitleField
          ? _value.subtitleField
          : subtitleField // ignore: cast_nullable_to_non_nullable
              as String?,
      imageField: freezed == imageField
          ? _value.imageField
          : imageField // ignore: cast_nullable_to_non_nullable
              as String?,
      dateField: freezed == dateField
          ? _value.dateField
          : dateField // ignore: cast_nullable_to_non_nullable
              as String?,
      timeField: freezed == timeField
          ? _value.timeField
          : timeField // ignore: cast_nullable_to_non_nullable
              as String?,
      priceField: freezed == priceField
          ? _value.priceField
          : priceField // ignore: cast_nullable_to_non_nullable
              as String?,
      statusField: freezed == statusField
          ? _value.statusField
          : statusField // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeField: freezed == badgeField
          ? _value.badgeField
          : badgeField // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeConditionField: freezed == badgeConditionField
          ? _value.badgeConditionField
          : badgeConditionField // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeText: freezed == badgeText
          ? _value.badgeText
          : badgeText // ignore: cast_nullable_to_non_nullable
              as String?,
      navigation: freezed == navigation
          ? _value.navigation
          : navigation // ignore: cast_nullable_to_non_nullable
              as ToolNavigationDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolItemSchemaDtoImpl implements _ToolItemSchemaDto {
  const _$ToolItemSchemaDtoImpl(
      {@JsonKey(name: 'title_field') this.titleField,
      @JsonKey(name: 'subtitle_field') this.subtitleField,
      @JsonKey(name: 'image_field') this.imageField,
      @JsonKey(name: 'date_field') this.dateField,
      @JsonKey(name: 'time_field') this.timeField,
      @JsonKey(name: 'price_field') this.priceField,
      @JsonKey(name: 'status_field') this.statusField,
      @JsonKey(name: 'badge_field') this.badgeField,
      @JsonKey(name: 'badge_condition_field') this.badgeConditionField,
      @JsonKey(name: 'badge_text') this.badgeText,
      this.navigation});

  factory _$ToolItemSchemaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolItemSchemaDtoImplFromJson(json);

  /// Field name for item title
  @override
  @JsonKey(name: 'title_field')
  final String? titleField;

  /// Field name for subtitle
  @override
  @JsonKey(name: 'subtitle_field')
  final String? subtitleField;

  /// Field name for image URL
  @override
  @JsonKey(name: 'image_field')
  final String? imageField;

  /// Field name for date display
  @override
  @JsonKey(name: 'date_field')
  final String? dateField;

  /// Field name for time display
  @override
  @JsonKey(name: 'time_field')
  final String? timeField;

  /// Field name for price display
  @override
  @JsonKey(name: 'price_field')
  final String? priceField;

  /// Field name for status (for bookings, tickets)
  @override
  @JsonKey(name: 'status_field')
  final String? statusField;

  /// Field name for badge text (e.g., 'Gratuit')
  @override
  @JsonKey(name: 'badge_field')
  final String? badgeField;

  /// Field name for badge condition (e.g., 'is_free')
  @override
  @JsonKey(name: 'badge_condition_field')
  final String? badgeConditionField;

  /// Badge text to show when condition is true
  @override
  @JsonKey(name: 'badge_text')
  final String? badgeText;

  /// Navigation configuration
  @override
  final ToolNavigationDto? navigation;

  @override
  String toString() {
    return 'ToolItemSchemaDto(titleField: $titleField, subtitleField: $subtitleField, imageField: $imageField, dateField: $dateField, timeField: $timeField, priceField: $priceField, statusField: $statusField, badgeField: $badgeField, badgeConditionField: $badgeConditionField, badgeText: $badgeText, navigation: $navigation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolItemSchemaDtoImpl &&
            (identical(other.titleField, titleField) ||
                other.titleField == titleField) &&
            (identical(other.subtitleField, subtitleField) ||
                other.subtitleField == subtitleField) &&
            (identical(other.imageField, imageField) ||
                other.imageField == imageField) &&
            (identical(other.dateField, dateField) ||
                other.dateField == dateField) &&
            (identical(other.timeField, timeField) ||
                other.timeField == timeField) &&
            (identical(other.priceField, priceField) ||
                other.priceField == priceField) &&
            (identical(other.statusField, statusField) ||
                other.statusField == statusField) &&
            (identical(other.badgeField, badgeField) ||
                other.badgeField == badgeField) &&
            (identical(other.badgeConditionField, badgeConditionField) ||
                other.badgeConditionField == badgeConditionField) &&
            (identical(other.badgeText, badgeText) ||
                other.badgeText == badgeText) &&
            (identical(other.navigation, navigation) ||
                other.navigation == navigation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      titleField,
      subtitleField,
      imageField,
      dateField,
      timeField,
      priceField,
      statusField,
      badgeField,
      badgeConditionField,
      badgeText,
      navigation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolItemSchemaDtoImplCopyWith<_$ToolItemSchemaDtoImpl> get copyWith =>
      __$$ToolItemSchemaDtoImplCopyWithImpl<_$ToolItemSchemaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolItemSchemaDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolItemSchemaDto implements ToolItemSchemaDto {
  const factory _ToolItemSchemaDto(
      {@JsonKey(name: 'title_field') final String? titleField,
      @JsonKey(name: 'subtitle_field') final String? subtitleField,
      @JsonKey(name: 'image_field') final String? imageField,
      @JsonKey(name: 'date_field') final String? dateField,
      @JsonKey(name: 'time_field') final String? timeField,
      @JsonKey(name: 'price_field') final String? priceField,
      @JsonKey(name: 'status_field') final String? statusField,
      @JsonKey(name: 'badge_field') final String? badgeField,
      @JsonKey(name: 'badge_condition_field') final String? badgeConditionField,
      @JsonKey(name: 'badge_text') final String? badgeText,
      final ToolNavigationDto? navigation}) = _$ToolItemSchemaDtoImpl;

  factory _ToolItemSchemaDto.fromJson(Map<String, dynamic> json) =
      _$ToolItemSchemaDtoImpl.fromJson;

  @override

  /// Field name for item title
  @JsonKey(name: 'title_field')
  String? get titleField;
  @override

  /// Field name for subtitle
  @JsonKey(name: 'subtitle_field')
  String? get subtitleField;
  @override

  /// Field name for image URL
  @JsonKey(name: 'image_field')
  String? get imageField;
  @override

  /// Field name for date display
  @JsonKey(name: 'date_field')
  String? get dateField;
  @override

  /// Field name for time display
  @JsonKey(name: 'time_field')
  String? get timeField;
  @override

  /// Field name for price display
  @JsonKey(name: 'price_field')
  String? get priceField;
  @override

  /// Field name for status (for bookings, tickets)
  @JsonKey(name: 'status_field')
  String? get statusField;
  @override

  /// Field name for badge text (e.g., 'Gratuit')
  @JsonKey(name: 'badge_field')
  String? get badgeField;
  @override

  /// Field name for badge condition (e.g., 'is_free')
  @JsonKey(name: 'badge_condition_field')
  String? get badgeConditionField;
  @override

  /// Badge text to show when condition is true
  @JsonKey(name: 'badge_text')
  String? get badgeText;
  @override

  /// Navigation configuration
  ToolNavigationDto? get navigation;
  @override
  @JsonKey(ignore: true)
  _$$ToolItemSchemaDtoImplCopyWith<_$ToolItemSchemaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToolNavigationDto _$ToolNavigationDtoFromJson(Map<String, dynamic> json) {
  return _ToolNavigationDto.fromJson(json);
}

/// @nodoc
mixin _$ToolNavigationDto {
  /// Route template with placeholders (e.g., '/event/{slug}', '/booking/{uuid}')
  String get route => throw _privateConstructorUsedError;

  /// Field name for the route parameter (e.g., 'slug', 'uuid')
  @JsonKey(name: 'id_field')
  String get idField => throw _privateConstructorUsedError;

  /// Whether to use go() instead of push() (for shell routes)
  @JsonKey(name: 'use_go')
  bool get useGo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolNavigationDtoCopyWith<ToolNavigationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolNavigationDtoCopyWith<$Res> {
  factory $ToolNavigationDtoCopyWith(
          ToolNavigationDto value, $Res Function(ToolNavigationDto) then) =
      _$ToolNavigationDtoCopyWithImpl<$Res, ToolNavigationDto>;
  @useResult
  $Res call(
      {String route,
      @JsonKey(name: 'id_field') String idField,
      @JsonKey(name: 'use_go') bool useGo});
}

/// @nodoc
class _$ToolNavigationDtoCopyWithImpl<$Res, $Val extends ToolNavigationDto>
    implements $ToolNavigationDtoCopyWith<$Res> {
  _$ToolNavigationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = null,
    Object? idField = null,
    Object? useGo = null,
  }) {
    return _then(_value.copyWith(
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String,
      idField: null == idField
          ? _value.idField
          : idField // ignore: cast_nullable_to_non_nullable
              as String,
      useGo: null == useGo
          ? _value.useGo
          : useGo // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolNavigationDtoImplCopyWith<$Res>
    implements $ToolNavigationDtoCopyWith<$Res> {
  factory _$$ToolNavigationDtoImplCopyWith(_$ToolNavigationDtoImpl value,
          $Res Function(_$ToolNavigationDtoImpl) then) =
      __$$ToolNavigationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String route,
      @JsonKey(name: 'id_field') String idField,
      @JsonKey(name: 'use_go') bool useGo});
}

/// @nodoc
class __$$ToolNavigationDtoImplCopyWithImpl<$Res>
    extends _$ToolNavigationDtoCopyWithImpl<$Res, _$ToolNavigationDtoImpl>
    implements _$$ToolNavigationDtoImplCopyWith<$Res> {
  __$$ToolNavigationDtoImplCopyWithImpl(_$ToolNavigationDtoImpl _value,
      $Res Function(_$ToolNavigationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = null,
    Object? idField = null,
    Object? useGo = null,
  }) {
    return _then(_$ToolNavigationDtoImpl(
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String,
      idField: null == idField
          ? _value.idField
          : idField // ignore: cast_nullable_to_non_nullable
              as String,
      useGo: null == useGo
          ? _value.useGo
          : useGo // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolNavigationDtoImpl implements _ToolNavigationDto {
  const _$ToolNavigationDtoImpl(
      {required this.route,
      @JsonKey(name: 'id_field') required this.idField,
      @JsonKey(name: 'use_go') this.useGo = false});

  factory _$ToolNavigationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolNavigationDtoImplFromJson(json);

  /// Route template with placeholders (e.g., '/event/{slug}', '/booking/{uuid}')
  @override
  final String route;

  /// Field name for the route parameter (e.g., 'slug', 'uuid')
  @override
  @JsonKey(name: 'id_field')
  final String idField;

  /// Whether to use go() instead of push() (for shell routes)
  @override
  @JsonKey(name: 'use_go')
  final bool useGo;

  @override
  String toString() {
    return 'ToolNavigationDto(route: $route, idField: $idField, useGo: $useGo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolNavigationDtoImpl &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.idField, idField) || other.idField == idField) &&
            (identical(other.useGo, useGo) || other.useGo == useGo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, route, idField, useGo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolNavigationDtoImplCopyWith<_$ToolNavigationDtoImpl> get copyWith =>
      __$$ToolNavigationDtoImplCopyWithImpl<_$ToolNavigationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolNavigationDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolNavigationDto implements ToolNavigationDto {
  const factory _ToolNavigationDto(
      {required final String route,
      @JsonKey(name: 'id_field') required final String idField,
      @JsonKey(name: 'use_go') final bool useGo}) = _$ToolNavigationDtoImpl;

  factory _ToolNavigationDto.fromJson(Map<String, dynamic> json) =
      _$ToolNavigationDtoImpl.fromJson;

  @override

  /// Route template with placeholders (e.g., '/event/{slug}', '/booking/{uuid}')
  String get route;
  @override

  /// Field name for the route parameter (e.g., 'slug', 'uuid')
  @JsonKey(name: 'id_field')
  String get idField;
  @override

  /// Whether to use go() instead of push() (for shell routes)
  @JsonKey(name: 'use_go')
  bool get useGo;
  @override
  @JsonKey(ignore: true)
  _$$ToolNavigationDtoImplCopyWith<_$ToolNavigationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToolStatSchemaDto _$ToolStatSchemaDtoFromJson(Map<String, dynamic> json) {
  return _ToolStatSchemaDto.fromJson(json);
}

/// @nodoc
mixin _$ToolStatSchemaDto {
  /// Material icon name
  String get icon => throw _privateConstructorUsedError;

  /// Label text
  String get label => throw _privateConstructorUsedError;

  /// Field name in the data
  String get field => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolStatSchemaDtoCopyWith<ToolStatSchemaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolStatSchemaDtoCopyWith<$Res> {
  factory $ToolStatSchemaDtoCopyWith(
          ToolStatSchemaDto value, $Res Function(ToolStatSchemaDto) then) =
      _$ToolStatSchemaDtoCopyWithImpl<$Res, ToolStatSchemaDto>;
  @useResult
  $Res call({String icon, String label, String field});
}

/// @nodoc
class _$ToolStatSchemaDtoCopyWithImpl<$Res, $Val extends ToolStatSchemaDto>
    implements $ToolStatSchemaDtoCopyWith<$Res> {
  _$ToolStatSchemaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? label = null,
    Object? field = null,
  }) {
    return _then(_value.copyWith(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolStatSchemaDtoImplCopyWith<$Res>
    implements $ToolStatSchemaDtoCopyWith<$Res> {
  factory _$$ToolStatSchemaDtoImplCopyWith(_$ToolStatSchemaDtoImpl value,
          $Res Function(_$ToolStatSchemaDtoImpl) then) =
      __$$ToolStatSchemaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String icon, String label, String field});
}

/// @nodoc
class __$$ToolStatSchemaDtoImplCopyWithImpl<$Res>
    extends _$ToolStatSchemaDtoCopyWithImpl<$Res, _$ToolStatSchemaDtoImpl>
    implements _$$ToolStatSchemaDtoImplCopyWith<$Res> {
  __$$ToolStatSchemaDtoImplCopyWithImpl(_$ToolStatSchemaDtoImpl _value,
      $Res Function(_$ToolStatSchemaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? label = null,
    Object? field = null,
  }) {
    return _then(_$ToolStatSchemaDtoImpl(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolStatSchemaDtoImpl implements _ToolStatSchemaDto {
  const _$ToolStatSchemaDtoImpl(
      {required this.icon, required this.label, required this.field});

  factory _$ToolStatSchemaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolStatSchemaDtoImplFromJson(json);

  /// Material icon name
  @override
  final String icon;

  /// Label text
  @override
  final String label;

  /// Field name in the data
  @override
  final String field;

  @override
  String toString() {
    return 'ToolStatSchemaDto(icon: $icon, label: $label, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolStatSchemaDtoImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.field, field) || other.field == field));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, icon, label, field);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolStatSchemaDtoImplCopyWith<_$ToolStatSchemaDtoImpl> get copyWith =>
      __$$ToolStatSchemaDtoImplCopyWithImpl<_$ToolStatSchemaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolStatSchemaDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolStatSchemaDto implements ToolStatSchemaDto {
  const factory _ToolStatSchemaDto(
      {required final String icon,
      required final String label,
      required final String field}) = _$ToolStatSchemaDtoImpl;

  factory _ToolStatSchemaDto.fromJson(Map<String, dynamic> json) =
      _$ToolStatSchemaDtoImpl.fromJson;

  @override

  /// Material icon name
  String get icon;
  @override

  /// Label text
  String get label;
  @override

  /// Field name in the data
  String get field;
  @override
  @JsonKey(ignore: true)
  _$$ToolStatSchemaDtoImplCopyWith<_$ToolStatSchemaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToolsResponseDto _$ToolsResponseDtoFromJson(Map<String, dynamic> json) {
  return _ToolsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ToolsResponseDto {
  bool get success => throw _privateConstructorUsedError;
  List<ToolSchemaDto> get tools => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolsResponseDtoCopyWith<ToolsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolsResponseDtoCopyWith<$Res> {
  factory $ToolsResponseDtoCopyWith(
          ToolsResponseDto value, $Res Function(ToolsResponseDto) then) =
      _$ToolsResponseDtoCopyWithImpl<$Res, ToolsResponseDto>;
  @useResult
  $Res call({bool success, List<ToolSchemaDto> tools});
}

/// @nodoc
class _$ToolsResponseDtoCopyWithImpl<$Res, $Val extends ToolsResponseDto>
    implements $ToolsResponseDtoCopyWith<$Res> {
  _$ToolsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? tools = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      tools: null == tools
          ? _value.tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<ToolSchemaDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolsResponseDtoImplCopyWith<$Res>
    implements $ToolsResponseDtoCopyWith<$Res> {
  factory _$$ToolsResponseDtoImplCopyWith(_$ToolsResponseDtoImpl value,
          $Res Function(_$ToolsResponseDtoImpl) then) =
      __$$ToolsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<ToolSchemaDto> tools});
}

/// @nodoc
class __$$ToolsResponseDtoImplCopyWithImpl<$Res>
    extends _$ToolsResponseDtoCopyWithImpl<$Res, _$ToolsResponseDtoImpl>
    implements _$$ToolsResponseDtoImplCopyWith<$Res> {
  __$$ToolsResponseDtoImplCopyWithImpl(_$ToolsResponseDtoImpl _value,
      $Res Function(_$ToolsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? tools = null,
  }) {
    return _then(_$ToolsResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      tools: null == tools
          ? _value._tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<ToolSchemaDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolsResponseDtoImpl implements _ToolsResponseDto {
  const _$ToolsResponseDtoImpl(
      {this.success = true, final List<ToolSchemaDto> tools = const []})
      : _tools = tools;

  factory _$ToolsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolsResponseDtoImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  final List<ToolSchemaDto> _tools;
  @override
  @JsonKey()
  List<ToolSchemaDto> get tools {
    if (_tools is EqualUnmodifiableListView) return _tools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tools);
  }

  @override
  String toString() {
    return 'ToolsResponseDto(success: $success, tools: $tools)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolsResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._tools, _tools));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, const DeepCollectionEquality().hash(_tools));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolsResponseDtoImplCopyWith<_$ToolsResponseDtoImpl> get copyWith =>
      __$$ToolsResponseDtoImplCopyWithImpl<_$ToolsResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _ToolsResponseDto implements ToolsResponseDto {
  const factory _ToolsResponseDto(
      {final bool success,
      final List<ToolSchemaDto> tools}) = _$ToolsResponseDtoImpl;

  factory _ToolsResponseDto.fromJson(Map<String, dynamic> json) =
      _$ToolsResponseDtoImpl.fromJson;

  @override
  bool get success;
  @override
  List<ToolSchemaDto> get tools;
  @override
  @JsonKey(ignore: true)
  _$$ToolsResponseDtoImplCopyWith<_$ToolsResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
