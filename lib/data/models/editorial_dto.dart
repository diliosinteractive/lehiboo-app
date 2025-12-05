import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'editorial_dto.freezed.dart';
part 'editorial_dto.g.dart';

@freezed
class EditorialPostDto with _$EditorialPostDto {
  const factory EditorialPostDto({
    required int id,
    required String title,
    required String slug,
    required String excerpt,
    required String content,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
  }) = _EditorialPostDto;

  factory EditorialPostDto.fromJson(Map<String, dynamic> json) => _$EditorialPostDtoFromJson(json);
}
