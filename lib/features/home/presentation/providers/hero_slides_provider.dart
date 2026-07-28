import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/hero_slides_api_datasource.dart';
import '../../data/models/hero_slide_dto.dart';
import 'home_providers.dart';

/// Home-screen hero carousel feed.
///
/// Spec: docs/HERO_SLIDES_MOBILE_SPEC.md §2 — caching is `keepAlive`
/// + manual refresh hooked into the home screen's pull-to-refresh,
/// matching the existing `mobileAppConfigProvider` pattern. Cold-load errors
/// remain observable as [AsyncError], while ContextualHero uses its static
/// fallback until data exists. Refresh errors retain the previous slides.
final heroSlidesProvider = AutoDisposeAsyncNotifierProvider<
    HeroSlidesNotifier, List<HeroSlideDto>>(HeroSlidesNotifier.new);

class HeroSlidesNotifier extends AutoDisposeAsyncNotifier<List<HeroSlideDto>> {
  Future<void>? _refreshInFlight;
  Timer? _freshnessTimer;
  KeepAliveLink? _cacheLink;

  @override
  Future<List<HeroSlideDto>> build() async {
    final dataSource = ref.watch(heroSlidesApiDataSourceProvider);
    _cacheLink?.close();
    _cacheLink = ref.keepAlive();
    _freshnessTimer?.cancel();
    _freshnessTimer = Timer(homeDataFreshness, () {
      _cacheLink?.close();
      _cacheLink = null;
      ref.invalidateSelf();
    });
    ref.onDispose(() {
      _freshnessTimer?.cancel();
      _freshnessTimer = null;
      _cacheLink?.close();
      _cacheLink = null;
    });

    return dataSource.getHeroSlides();
  }

  Future<void> refresh() {
    return _refreshInFlight ??= _reload().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<void> _reload() async {
    ref.invalidateSelf();
    await future;
  }
}
