import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/hero_slide_dto.dart';

final heroSlidesApiDataSourceProvider =
    Provider<HeroSlidesApiDataSource>((ref) {
  return HeroSlidesApiDataSource(ref.read(dioProvider));
});

/// Public, read-only data source for the home-screen hero carousel.
///
/// Spec: docs/HERO_SLIDES_MOBILE_SPEC.md.
///
/// `GET /hero-slides` requires no auth and returns rows already sorted
/// by the server. Errors collapse to an empty list so the home screen
/// can fall back to the static hero image cleanly — the carousel
/// "never visibly fails."
class HeroSlidesApiDataSource {
  final Dio _dio;

  HeroSlidesApiDataSource(this._dio);

  Future<List<HeroSlideDto>> getHeroSlides() async {
    try {
      final response = await _dio.get('/hero-slides');
      return ApiResponseHandler.extractList(response.data)
          .whereType<Map<String, dynamic>>()
          .map(HeroSlideDto.fromJson)
          .toList(growable: false);
    } catch (e) {
      debugPrint('HeroSlides error: ${ApiResponseHandler.extractError(e)}');
      return const [];
    }
  }
}
