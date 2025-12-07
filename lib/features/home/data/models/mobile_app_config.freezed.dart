// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MobileAppConfig _$MobileAppConfigFromJson(Map<String, dynamic> json) {
  return _MobileAppConfig.fromJson(json);
}

/// @nodoc
mixin _$MobileAppConfig {
  HeroConfig get hero => throw _privateConstructorUsedError;
  AdsConfig get ads => throw _privateConstructorUsedError;
  TextsConfig get texts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MobileAppConfigCopyWith<MobileAppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileAppConfigCopyWith<$Res> {
  factory $MobileAppConfigCopyWith(
          MobileAppConfig value, $Res Function(MobileAppConfig) then) =
      _$MobileAppConfigCopyWithImpl<$Res, MobileAppConfig>;
  @useResult
  $Res call({HeroConfig hero, AdsConfig ads, TextsConfig texts});

  $HeroConfigCopyWith<$Res> get hero;
  $AdsConfigCopyWith<$Res> get ads;
  $TextsConfigCopyWith<$Res> get texts;
}

/// @nodoc
class _$MobileAppConfigCopyWithImpl<$Res, $Val extends MobileAppConfig>
    implements $MobileAppConfigCopyWith<$Res> {
  _$MobileAppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hero = null,
    Object? ads = null,
    Object? texts = null,
  }) {
    return _then(_value.copyWith(
      hero: null == hero
          ? _value.hero
          : hero // ignore: cast_nullable_to_non_nullable
              as HeroConfig,
      ads: null == ads
          ? _value.ads
          : ads // ignore: cast_nullable_to_non_nullable
              as AdsConfig,
      texts: null == texts
          ? _value.texts
          : texts // ignore: cast_nullable_to_non_nullable
              as TextsConfig,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HeroConfigCopyWith<$Res> get hero {
    return $HeroConfigCopyWith<$Res>(_value.hero, (value) {
      return _then(_value.copyWith(hero: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AdsConfigCopyWith<$Res> get ads {
    return $AdsConfigCopyWith<$Res>(_value.ads, (value) {
      return _then(_value.copyWith(ads: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TextsConfigCopyWith<$Res> get texts {
    return $TextsConfigCopyWith<$Res>(_value.texts, (value) {
      return _then(_value.copyWith(texts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MobileAppConfigImplCopyWith<$Res>
    implements $MobileAppConfigCopyWith<$Res> {
  factory _$$MobileAppConfigImplCopyWith(_$MobileAppConfigImpl value,
          $Res Function(_$MobileAppConfigImpl) then) =
      __$$MobileAppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HeroConfig hero, AdsConfig ads, TextsConfig texts});

  @override
  $HeroConfigCopyWith<$Res> get hero;
  @override
  $AdsConfigCopyWith<$Res> get ads;
  @override
  $TextsConfigCopyWith<$Res> get texts;
}

/// @nodoc
class __$$MobileAppConfigImplCopyWithImpl<$Res>
    extends _$MobileAppConfigCopyWithImpl<$Res, _$MobileAppConfigImpl>
    implements _$$MobileAppConfigImplCopyWith<$Res> {
  __$$MobileAppConfigImplCopyWithImpl(
      _$MobileAppConfigImpl _value, $Res Function(_$MobileAppConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hero = null,
    Object? ads = null,
    Object? texts = null,
  }) {
    return _then(_$MobileAppConfigImpl(
      hero: null == hero
          ? _value.hero
          : hero // ignore: cast_nullable_to_non_nullable
              as HeroConfig,
      ads: null == ads
          ? _value.ads
          : ads // ignore: cast_nullable_to_non_nullable
              as AdsConfig,
      texts: null == texts
          ? _value.texts
          : texts // ignore: cast_nullable_to_non_nullable
              as TextsConfig,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileAppConfigImpl implements _MobileAppConfig {
  const _$MobileAppConfigImpl(
      {required this.hero, required this.ads, required this.texts});

  factory _$MobileAppConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileAppConfigImplFromJson(json);

  @override
  final HeroConfig hero;
  @override
  final AdsConfig ads;
  @override
  final TextsConfig texts;

  @override
  String toString() {
    return 'MobileAppConfig(hero: $hero, ads: $ads, texts: $texts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileAppConfigImpl &&
            (identical(other.hero, hero) || other.hero == hero) &&
            (identical(other.ads, ads) || other.ads == ads) &&
            (identical(other.texts, texts) || other.texts == texts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hero, ads, texts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileAppConfigImplCopyWith<_$MobileAppConfigImpl> get copyWith =>
      __$$MobileAppConfigImplCopyWithImpl<_$MobileAppConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileAppConfigImplToJson(
      this,
    );
  }
}

abstract class _MobileAppConfig implements MobileAppConfig {
  const factory _MobileAppConfig(
      {required final HeroConfig hero,
      required final AdsConfig ads,
      required final TextsConfig texts}) = _$MobileAppConfigImpl;

  factory _MobileAppConfig.fromJson(Map<String, dynamic> json) =
      _$MobileAppConfigImpl.fromJson;

  @override
  HeroConfig get hero;
  @override
  AdsConfig get ads;
  @override
  TextsConfig get texts;
  @override
  @JsonKey(ignore: true)
  _$$MobileAppConfigImplCopyWith<_$MobileAppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeroConfig _$HeroConfigFromJson(Map<String, dynamic> json) {
  return _HeroConfig.fromJson(json);
}

/// @nodoc
mixin _$HeroConfig {
  String get image => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_search')
  bool get showSearch => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_quick_filters')
  bool get showQuickFilters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HeroConfigCopyWith<HeroConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeroConfigCopyWith<$Res> {
  factory $HeroConfigCopyWith(
          HeroConfig value, $Res Function(HeroConfig) then) =
      _$HeroConfigCopyWithImpl<$Res, HeroConfig>;
  @useResult
  $Res call(
      {String image,
      String title,
      String subtitle,
      @JsonKey(name: 'show_search') bool showSearch,
      @JsonKey(name: 'show_quick_filters') bool showQuickFilters});
}

/// @nodoc
class _$HeroConfigCopyWithImpl<$Res, $Val extends HeroConfig>
    implements $HeroConfigCopyWith<$Res> {
  _$HeroConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? title = null,
    Object? subtitle = null,
    Object? showSearch = null,
    Object? showQuickFilters = null,
  }) {
    return _then(_value.copyWith(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      showSearch: null == showSearch
          ? _value.showSearch
          : showSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      showQuickFilters: null == showQuickFilters
          ? _value.showQuickFilters
          : showQuickFilters // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeroConfigImplCopyWith<$Res>
    implements $HeroConfigCopyWith<$Res> {
  factory _$$HeroConfigImplCopyWith(
          _$HeroConfigImpl value, $Res Function(_$HeroConfigImpl) then) =
      __$$HeroConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String image,
      String title,
      String subtitle,
      @JsonKey(name: 'show_search') bool showSearch,
      @JsonKey(name: 'show_quick_filters') bool showQuickFilters});
}

/// @nodoc
class __$$HeroConfigImplCopyWithImpl<$Res>
    extends _$HeroConfigCopyWithImpl<$Res, _$HeroConfigImpl>
    implements _$$HeroConfigImplCopyWith<$Res> {
  __$$HeroConfigImplCopyWithImpl(
      _$HeroConfigImpl _value, $Res Function(_$HeroConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? title = null,
    Object? subtitle = null,
    Object? showSearch = null,
    Object? showQuickFilters = null,
  }) {
    return _then(_$HeroConfigImpl(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      showSearch: null == showSearch
          ? _value.showSearch
          : showSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      showQuickFilters: null == showQuickFilters
          ? _value.showQuickFilters
          : showQuickFilters // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeroConfigImpl implements _HeroConfig {
  const _$HeroConfigImpl(
      {this.image = '',
      this.title = 'Trouvez votre prochaine aventure locale',
      this.subtitle = 'Découvrez les meilleurs événements près de chez vous',
      @JsonKey(name: 'show_search') this.showSearch = true,
      @JsonKey(name: 'show_quick_filters') this.showQuickFilters = true});

  factory _$HeroConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeroConfigImplFromJson(json);

  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String subtitle;
  @override
  @JsonKey(name: 'show_search')
  final bool showSearch;
  @override
  @JsonKey(name: 'show_quick_filters')
  final bool showQuickFilters;

  @override
  String toString() {
    return 'HeroConfig(image: $image, title: $title, subtitle: $subtitle, showSearch: $showSearch, showQuickFilters: $showQuickFilters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeroConfigImpl &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.showSearch, showSearch) ||
                other.showSearch == showSearch) &&
            (identical(other.showQuickFilters, showQuickFilters) ||
                other.showQuickFilters == showQuickFilters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, image, title, subtitle, showSearch, showQuickFilters);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HeroConfigImplCopyWith<_$HeroConfigImpl> get copyWith =>
      __$$HeroConfigImplCopyWithImpl<_$HeroConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeroConfigImplToJson(
      this,
    );
  }
}

abstract class _HeroConfig implements HeroConfig {
  const factory _HeroConfig(
          {final String image,
          final String title,
          final String subtitle,
          @JsonKey(name: 'show_search') final bool showSearch,
          @JsonKey(name: 'show_quick_filters') final bool showQuickFilters}) =
      _$HeroConfigImpl;

  factory _HeroConfig.fromJson(Map<String, dynamic> json) =
      _$HeroConfigImpl.fromJson;

  @override
  String get image;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  @JsonKey(name: 'show_search')
  bool get showSearch;
  @override
  @JsonKey(name: 'show_quick_filters')
  bool get showQuickFilters;
  @override
  @JsonKey(ignore: true)
  _$$HeroConfigImplCopyWith<_$HeroConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdsConfig _$AdsConfigFromJson(Map<String, dynamic> json) {
  return _AdsConfig.fromJson(json);
}

/// @nodoc
mixin _$AdsConfig {
  bool get enabled => throw _privateConstructorUsedError;
  List<AdBanner> get banners => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdsConfigCopyWith<AdsConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdsConfigCopyWith<$Res> {
  factory $AdsConfigCopyWith(AdsConfig value, $Res Function(AdsConfig) then) =
      _$AdsConfigCopyWithImpl<$Res, AdsConfig>;
  @useResult
  $Res call({bool enabled, List<AdBanner> banners});
}

/// @nodoc
class _$AdsConfigCopyWithImpl<$Res, $Val extends AdsConfig>
    implements $AdsConfigCopyWith<$Res> {
  _$AdsConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? banners = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      banners: null == banners
          ? _value.banners
          : banners // ignore: cast_nullable_to_non_nullable
              as List<AdBanner>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdsConfigImplCopyWith<$Res>
    implements $AdsConfigCopyWith<$Res> {
  factory _$$AdsConfigImplCopyWith(
          _$AdsConfigImpl value, $Res Function(_$AdsConfigImpl) then) =
      __$$AdsConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enabled, List<AdBanner> banners});
}

/// @nodoc
class __$$AdsConfigImplCopyWithImpl<$Res>
    extends _$AdsConfigCopyWithImpl<$Res, _$AdsConfigImpl>
    implements _$$AdsConfigImplCopyWith<$Res> {
  __$$AdsConfigImplCopyWithImpl(
      _$AdsConfigImpl _value, $Res Function(_$AdsConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? banners = null,
  }) {
    return _then(_$AdsConfigImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      banners: null == banners
          ? _value._banners
          : banners // ignore: cast_nullable_to_non_nullable
              as List<AdBanner>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdsConfigImpl implements _AdsConfig {
  const _$AdsConfigImpl(
      {this.enabled = false, final List<AdBanner> banners = const []})
      : _banners = banners;

  factory _$AdsConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdsConfigImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  final List<AdBanner> _banners;
  @override
  @JsonKey()
  List<AdBanner> get banners {
    if (_banners is EqualUnmodifiableListView) return _banners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banners);
  }

  @override
  String toString() {
    return 'AdsConfig(enabled: $enabled, banners: $banners)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdsConfigImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(other._banners, _banners));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, enabled, const DeepCollectionEquality().hash(_banners));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdsConfigImplCopyWith<_$AdsConfigImpl> get copyWith =>
      __$$AdsConfigImplCopyWithImpl<_$AdsConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdsConfigImplToJson(
      this,
    );
  }
}

abstract class _AdsConfig implements AdsConfig {
  const factory _AdsConfig({final bool enabled, final List<AdBanner> banners}) =
      _$AdsConfigImpl;

  factory _AdsConfig.fromJson(Map<String, dynamic> json) =
      _$AdsConfigImpl.fromJson;

  @override
  bool get enabled;
  @override
  List<AdBanner> get banners;
  @override
  @JsonKey(ignore: true)
  _$$AdsConfigImplCopyWith<_$AdsConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdBanner _$AdBannerFromJson(Map<String, dynamic> json) {
  return _AdBanner.fromJson(json);
}

/// @nodoc
mixin _$AdBanner {
  String get image => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdBannerCopyWith<AdBanner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdBannerCopyWith<$Res> {
  factory $AdBannerCopyWith(AdBanner value, $Res Function(AdBanner) then) =
      _$AdBannerCopyWithImpl<$Res, AdBanner>;
  @useResult
  $Res call({String image, String url});
}

/// @nodoc
class _$AdBannerCopyWithImpl<$Res, $Val extends AdBanner>
    implements $AdBannerCopyWith<$Res> {
  _$AdBannerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdBannerImplCopyWith<$Res>
    implements $AdBannerCopyWith<$Res> {
  factory _$$AdBannerImplCopyWith(
          _$AdBannerImpl value, $Res Function(_$AdBannerImpl) then) =
      __$$AdBannerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String image, String url});
}

/// @nodoc
class __$$AdBannerImplCopyWithImpl<$Res>
    extends _$AdBannerCopyWithImpl<$Res, _$AdBannerImpl>
    implements _$$AdBannerImplCopyWith<$Res> {
  __$$AdBannerImplCopyWithImpl(
      _$AdBannerImpl _value, $Res Function(_$AdBannerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? url = null,
  }) {
    return _then(_$AdBannerImpl(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdBannerImpl implements _AdBanner {
  const _$AdBannerImpl({this.image = '', this.url = ''});

  factory _$AdBannerImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdBannerImplFromJson(json);

  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'AdBanner(image: $image, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdBannerImpl &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, image, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdBannerImplCopyWith<_$AdBannerImpl> get copyWith =>
      __$$AdBannerImplCopyWithImpl<_$AdBannerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdBannerImplToJson(
      this,
    );
  }
}

abstract class _AdBanner implements AdBanner {
  const factory _AdBanner({final String image, final String url}) =
      _$AdBannerImpl;

  factory _AdBanner.fromJson(Map<String, dynamic> json) =
      _$AdBannerImpl.fromJson;

  @override
  String get image;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$AdBannerImplCopyWith<_$AdBannerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TextsConfig _$TextsConfigFromJson(Map<String, dynamic> json) {
  return _TextsConfig.fromJson(json);
}

/// @nodoc
mixin _$TextsConfig {
  @JsonKey(name: 'events_section_title')
  String get eventsSectionTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'events_section_description')
  String get eventsSectionDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'thematiques_section_title')
  String get thematiquesSectionTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'cities_section_title')
  String get citiesSectionTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'explore_button_text')
  String get exploreButtonText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TextsConfigCopyWith<TextsConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextsConfigCopyWith<$Res> {
  factory $TextsConfigCopyWith(
          TextsConfig value, $Res Function(TextsConfig) then) =
      _$TextsConfigCopyWithImpl<$Res, TextsConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'events_section_title') String eventsSectionTitle,
      @JsonKey(name: 'events_section_description')
      String eventsSectionDescription,
      @JsonKey(name: 'thematiques_section_title')
      String thematiquesSectionTitle,
      @JsonKey(name: 'cities_section_title') String citiesSectionTitle,
      @JsonKey(name: 'explore_button_text') String exploreButtonText});
}

/// @nodoc
class _$TextsConfigCopyWithImpl<$Res, $Val extends TextsConfig>
    implements $TextsConfigCopyWith<$Res> {
  _$TextsConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventsSectionTitle = null,
    Object? eventsSectionDescription = null,
    Object? thematiquesSectionTitle = null,
    Object? citiesSectionTitle = null,
    Object? exploreButtonText = null,
  }) {
    return _then(_value.copyWith(
      eventsSectionTitle: null == eventsSectionTitle
          ? _value.eventsSectionTitle
          : eventsSectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      eventsSectionDescription: null == eventsSectionDescription
          ? _value.eventsSectionDescription
          : eventsSectionDescription // ignore: cast_nullable_to_non_nullable
              as String,
      thematiquesSectionTitle: null == thematiquesSectionTitle
          ? _value.thematiquesSectionTitle
          : thematiquesSectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      citiesSectionTitle: null == citiesSectionTitle
          ? _value.citiesSectionTitle
          : citiesSectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      exploreButtonText: null == exploreButtonText
          ? _value.exploreButtonText
          : exploreButtonText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextsConfigImplCopyWith<$Res>
    implements $TextsConfigCopyWith<$Res> {
  factory _$$TextsConfigImplCopyWith(
          _$TextsConfigImpl value, $Res Function(_$TextsConfigImpl) then) =
      __$$TextsConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'events_section_title') String eventsSectionTitle,
      @JsonKey(name: 'events_section_description')
      String eventsSectionDescription,
      @JsonKey(name: 'thematiques_section_title')
      String thematiquesSectionTitle,
      @JsonKey(name: 'cities_section_title') String citiesSectionTitle,
      @JsonKey(name: 'explore_button_text') String exploreButtonText});
}

/// @nodoc
class __$$TextsConfigImplCopyWithImpl<$Res>
    extends _$TextsConfigCopyWithImpl<$Res, _$TextsConfigImpl>
    implements _$$TextsConfigImplCopyWith<$Res> {
  __$$TextsConfigImplCopyWithImpl(
      _$TextsConfigImpl _value, $Res Function(_$TextsConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventsSectionTitle = null,
    Object? eventsSectionDescription = null,
    Object? thematiquesSectionTitle = null,
    Object? citiesSectionTitle = null,
    Object? exploreButtonText = null,
  }) {
    return _then(_$TextsConfigImpl(
      eventsSectionTitle: null == eventsSectionTitle
          ? _value.eventsSectionTitle
          : eventsSectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      eventsSectionDescription: null == eventsSectionDescription
          ? _value.eventsSectionDescription
          : eventsSectionDescription // ignore: cast_nullable_to_non_nullable
              as String,
      thematiquesSectionTitle: null == thematiquesSectionTitle
          ? _value.thematiquesSectionTitle
          : thematiquesSectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      citiesSectionTitle: null == citiesSectionTitle
          ? _value.citiesSectionTitle
          : citiesSectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      exploreButtonText: null == exploreButtonText
          ? _value.exploreButtonText
          : exploreButtonText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TextsConfigImpl implements _TextsConfig {
  const _$TextsConfigImpl(
      {@JsonKey(name: 'events_section_title')
      this.eventsSectionTitle = 'Retrouvez tous vos événements',
      @JsonKey(name: 'events_section_description')
      this.eventsSectionDescription =
          'Explorez notre sélection d\'événements locaux',
      @JsonKey(name: 'thematiques_section_title')
      this.thematiquesSectionTitle = 'Explorez par thématique',
      @JsonKey(name: 'cities_section_title')
      this.citiesSectionTitle = 'Événements par ville',
      @JsonKey(name: 'explore_button_text')
      this.exploreButtonText = 'Explorer les activités'});

  factory _$TextsConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TextsConfigImplFromJson(json);

  @override
  @JsonKey(name: 'events_section_title')
  final String eventsSectionTitle;
  @override
  @JsonKey(name: 'events_section_description')
  final String eventsSectionDescription;
  @override
  @JsonKey(name: 'thematiques_section_title')
  final String thematiquesSectionTitle;
  @override
  @JsonKey(name: 'cities_section_title')
  final String citiesSectionTitle;
  @override
  @JsonKey(name: 'explore_button_text')
  final String exploreButtonText;

  @override
  String toString() {
    return 'TextsConfig(eventsSectionTitle: $eventsSectionTitle, eventsSectionDescription: $eventsSectionDescription, thematiquesSectionTitle: $thematiquesSectionTitle, citiesSectionTitle: $citiesSectionTitle, exploreButtonText: $exploreButtonText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextsConfigImpl &&
            (identical(other.eventsSectionTitle, eventsSectionTitle) ||
                other.eventsSectionTitle == eventsSectionTitle) &&
            (identical(
                    other.eventsSectionDescription, eventsSectionDescription) ||
                other.eventsSectionDescription == eventsSectionDescription) &&
            (identical(
                    other.thematiquesSectionTitle, thematiquesSectionTitle) ||
                other.thematiquesSectionTitle == thematiquesSectionTitle) &&
            (identical(other.citiesSectionTitle, citiesSectionTitle) ||
                other.citiesSectionTitle == citiesSectionTitle) &&
            (identical(other.exploreButtonText, exploreButtonText) ||
                other.exploreButtonText == exploreButtonText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventsSectionTitle,
      eventsSectionDescription,
      thematiquesSectionTitle,
      citiesSectionTitle,
      exploreButtonText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TextsConfigImplCopyWith<_$TextsConfigImpl> get copyWith =>
      __$$TextsConfigImplCopyWithImpl<_$TextsConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TextsConfigImplToJson(
      this,
    );
  }
}

abstract class _TextsConfig implements TextsConfig {
  const factory _TextsConfig(
      {@JsonKey(name: 'events_section_title') final String eventsSectionTitle,
      @JsonKey(name: 'events_section_description')
      final String eventsSectionDescription,
      @JsonKey(name: 'thematiques_section_title')
      final String thematiquesSectionTitle,
      @JsonKey(name: 'cities_section_title') final String citiesSectionTitle,
      @JsonKey(name: 'explore_button_text')
      final String exploreButtonText}) = _$TextsConfigImpl;

  factory _TextsConfig.fromJson(Map<String, dynamic> json) =
      _$TextsConfigImpl.fromJson;

  @override
  @JsonKey(name: 'events_section_title')
  String get eventsSectionTitle;
  @override
  @JsonKey(name: 'events_section_description')
  String get eventsSectionDescription;
  @override
  @JsonKey(name: 'thematiques_section_title')
  String get thematiquesSectionTitle;
  @override
  @JsonKey(name: 'cities_section_title')
  String get citiesSectionTitle;
  @override
  @JsonKey(name: 'explore_button_text')
  String get exploreButtonText;
  @override
  @JsonKey(ignore: true)
  _$$TextsConfigImplCopyWith<_$TextsConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
