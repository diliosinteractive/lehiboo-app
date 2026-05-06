import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/hero_slides_api_datasource.dart';
import '../../data/models/hero_slide_dto.dart';

/// Home-screen hero carousel feed.
///
/// Spec: docs/HERO_SLIDES_MOBILE_SPEC.md §2 — caching is `keepAlive`
/// + manual refresh hooked into the home screen's pull-to-refresh,
/// matching the existing `mobileAppConfigProvider` pattern. The
/// underlying datasource collapses errors into `[]`, so the UI always
/// observes either a populated list or an empty list (no AsyncError
/// branch at this layer) — the home falls back to its static hero
/// image on empty.
final heroSlidesProvider = AutoDisposeAsyncNotifierProvider<
    HeroSlidesNotifier, List<HeroSlideDto>>(HeroSlidesNotifier.new);

class HeroSlidesNotifier extends AutoDisposeAsyncNotifier<List<HeroSlideDto>> {
  @override
  Future<List<HeroSlideDto>> build() async {
    final dataSource = ref.watch(heroSlidesApiDataSourceProvider);
    final result = await dataSource.getHeroSlides();
    ref.keepAlive();
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
