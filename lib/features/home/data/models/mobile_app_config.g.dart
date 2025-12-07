// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileAppConfigImpl _$$MobileAppConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$MobileAppConfigImpl(
      hero: HeroConfig.fromJson(json['hero'] as Map<String, dynamic>),
      ads: AdsConfig.fromJson(json['ads'] as Map<String, dynamic>),
      texts: TextsConfig.fromJson(json['texts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MobileAppConfigImplToJson(
        _$MobileAppConfigImpl instance) =>
    <String, dynamic>{
      'hero': instance.hero,
      'ads': instance.ads,
      'texts': instance.texts,
    };

_$HeroConfigImpl _$$HeroConfigImplFromJson(Map<String, dynamic> json) =>
    _$HeroConfigImpl(
      image: json['image'] as String? ?? '',
      title:
          json['title'] as String? ?? 'Trouvez votre prochaine aventure locale',
      subtitle: json['subtitle'] as String? ??
          'Découvrez les meilleurs événements près de chez vous',
      showSearch: json['show_search'] as bool? ?? true,
      showQuickFilters: json['show_quick_filters'] as bool? ?? true,
    );

Map<String, dynamic> _$$HeroConfigImplToJson(_$HeroConfigImpl instance) =>
    <String, dynamic>{
      'image': instance.image,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'show_search': instance.showSearch,
      'show_quick_filters': instance.showQuickFilters,
    };

_$AdsConfigImpl _$$AdsConfigImplFromJson(Map<String, dynamic> json) =>
    _$AdsConfigImpl(
      enabled: json['enabled'] as bool? ?? false,
      banners: (json['banners'] as List<dynamic>?)
              ?.map((e) => AdBanner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AdsConfigImplToJson(_$AdsConfigImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'banners': instance.banners,
    };

_$AdBannerImpl _$$AdBannerImplFromJson(Map<String, dynamic> json) =>
    _$AdBannerImpl(
      image: json['image'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$$AdBannerImplToJson(_$AdBannerImpl instance) =>
    <String, dynamic>{
      'image': instance.image,
      'url': instance.url,
    };

_$TextsConfigImpl _$$TextsConfigImplFromJson(Map<String, dynamic> json) =>
    _$TextsConfigImpl(
      eventsSectionTitle: json['events_section_title'] as String? ??
          'Retrouvez tous vos événements',
      eventsSectionDescription: json['events_section_description'] as String? ??
          'Explorez notre sélection d\'événements locaux',
      thematiquesSectionTitle: json['thematiques_section_title'] as String? ??
          'Explorez par thématique',
      citiesSectionTitle:
          json['cities_section_title'] as String? ?? 'Événements par ville',
      exploreButtonText:
          json['explore_button_text'] as String? ?? 'Explorer les activités',
    );

Map<String, dynamic> _$$TextsConfigImplToJson(_$TextsConfigImpl instance) =>
    <String, dynamic>{
      'events_section_title': instance.eventsSectionTitle,
      'events_section_description': instance.eventsSectionDescription,
      'thematiques_section_title': instance.thematiquesSectionTitle,
      'cities_section_title': instance.citiesSectionTitle,
      'explore_button_text': instance.exploreButtonText,
    };
