import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_app_config.freezed.dart';
part 'mobile_app_config.g.dart';

@freezed
class MobileAppConfig with _$MobileAppConfig {
  const factory MobileAppConfig({
    required HeroConfig hero,
    required AdsConfig ads,
    required TextsConfig texts,
  }) = _MobileAppConfig;

  factory MobileAppConfig.fromJson(Map<String, dynamic> json) =>
      _$MobileAppConfigFromJson(json);

  /// Default config when API is unavailable
  factory MobileAppConfig.defaultConfig() => const MobileAppConfig(
        hero: HeroConfig(
          image: '',
          title: 'Trouvez votre prochaine aventure locale',
          subtitle: 'Découvrez les meilleurs événements près de chez vous',
          showSearch: true,
          showQuickFilters: true,
        ),
        ads: AdsConfig(
          enabled: false,
          banners: [],
        ),
        texts: TextsConfig(
          eventsSectionTitle: 'Retrouvez tous vos événements',
          eventsSectionDescription: 'Explorez notre sélection d\'événements locaux',
          thematiquesSectionTitle: 'Explorez par thématique',
          citiesSectionTitle: 'Événements par ville',
          exploreButtonText: 'Explorer les activités',
        ),
      );
}

@freezed
class HeroConfig with _$HeroConfig {
  const factory HeroConfig({
    @Default('') String image,
    @Default('Trouvez votre prochaine aventure locale') String title,
    @Default('Découvrez les meilleurs événements près de chez vous') String subtitle,
    @JsonKey(name: 'show_search') @Default(true) bool showSearch,
    @JsonKey(name: 'show_quick_filters') @Default(true) bool showQuickFilters,
  }) = _HeroConfig;

  factory HeroConfig.fromJson(Map<String, dynamic> json) =>
      _$HeroConfigFromJson(json);
}

@freezed
class AdsConfig with _$AdsConfig {
  const factory AdsConfig({
    @Default(false) bool enabled,
    @Default([]) List<AdBanner> banners,
  }) = _AdsConfig;

  factory AdsConfig.fromJson(Map<String, dynamic> json) =>
      _$AdsConfigFromJson(json);
}

@freezed
class AdBanner with _$AdBanner {
  const factory AdBanner({
    @Default('') String image,
    @Default('') String url,
  }) = _AdBanner;

  factory AdBanner.fromJson(Map<String, dynamic> json) =>
      _$AdBannerFromJson(json);
}

@freezed
class TextsConfig with _$TextsConfig {
  const factory TextsConfig({
    @JsonKey(name: 'events_section_title')
    @Default('Retrouvez tous vos événements')
    String eventsSectionTitle,
    @JsonKey(name: 'events_section_description')
    @Default('Explorez notre sélection d\'événements locaux')
    String eventsSectionDescription,
    @JsonKey(name: 'thematiques_section_title')
    @Default('Explorez par thématique')
    String thematiquesSectionTitle,
    @JsonKey(name: 'cities_section_title')
    @Default('Événements par ville')
    String citiesSectionTitle,
    @JsonKey(name: 'explore_button_text')
    @Default('Explorer les activités')
    String exploreButtonText,
  }) = _TextsConfig;

  factory TextsConfig.fromJson(Map<String, dynamic> json) =>
      _$TextsConfigFromJson(json);
}
