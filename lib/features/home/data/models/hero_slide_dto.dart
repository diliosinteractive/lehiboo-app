import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero_slide_dto.freezed.dart';
part 'hero_slide_dto.g.dart';

/// One slide in the home-screen hero carousel.
///
/// Spec: docs/HERO_SLIDES_MOBILE_SPEC.md §1. The endpoint returns rows
/// already in display order (`sort_order` asc, `created_at` asc as
/// tie-breaker), so the carousel renders the array as-is. We only
/// consume the four stable fields the spec commits to in §5; `id`,
/// `is_active`, `created_at`, `updated_at`, and the camelCase aliases
/// are intentionally ignored.
@freezed
class HeroSlideDto with _$HeroSlideDto {
  const factory HeroSlideDto({
    @Default('') String uuid,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'alt_text') @Default('') String altText,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _HeroSlideDto;

  factory HeroSlideDto.fromJson(Map<String, dynamic> json) =>
      _$HeroSlideDtoFromJson(json);
}
