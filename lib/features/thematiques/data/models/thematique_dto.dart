import 'package:freezed_annotation/freezed_annotation.dart';

part 'thematique_dto.freezed.dart';
part 'thematique_dto.g.dart';

@freezed
class ThematiqueDto with _$ThematiqueDto {
  const factory ThematiqueDto({
    required int id,
    required String name,
    required String slug,
    String? description,
    String? icon,
    ThematiqueImageDto? image,
    @JsonKey(name: 'event_count') int? eventCount,
  }) = _ThematiqueDto;

  factory ThematiqueDto.fromJson(Map<String, dynamic> json) =>
      _$ThematiqueDtoFromJson(json);
}

@freezed
class ThematiqueImageDto with _$ThematiqueImageDto {
  const factory ThematiqueImageDto({
    int? id,
    String? thumbnail,
    String? medium,
    String? large,
    String? full,
  }) = _ThematiqueImageDto;

  factory ThematiqueImageDto.fromJson(Map<String, dynamic> json) =>
      _$ThematiqueImageDtoFromJson(json);
}

@freezed
class ThematiquesResponseDto with _$ThematiquesResponseDto {
  const factory ThematiquesResponseDto({
    required List<ThematiqueDto> thematiques,
    required int count,
  }) = _ThematiquesResponseDto;

  factory ThematiquesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ThematiquesResponseDtoFromJson(json);
}
