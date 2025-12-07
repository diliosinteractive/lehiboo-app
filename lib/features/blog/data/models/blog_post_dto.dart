import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_post_dto.freezed.dart';
part 'blog_post_dto.g.dart';

@freezed
class BlogPostDto with _$BlogPostDto {
  const factory BlogPostDto({
    required int id,
    required String title,
    required String slug,
    String? excerpt,
    String? content,
    @JsonKey(name: 'featured_image') BlogImageDto? featuredImage,
    List<BlogCategoryDto>? categories,
    List<BlogTagDto>? tags,
    BlogAuthorDto? author,
    @JsonKey(name: 'published_at') String? publishedAt,
    @JsonKey(name: 'modified_at') String? modifiedAt,
    String? link,
    @JsonKey(name: 'reading_time') int? readingTime,
  }) = _BlogPostDto;

  factory BlogPostDto.fromJson(Map<String, dynamic> json) =>
      _$BlogPostDtoFromJson(json);
}

@freezed
class BlogImageDto with _$BlogImageDto {
  const factory BlogImageDto({
    String? thumbnail,
    String? medium,
    String? large,
    String? full,
  }) = _BlogImageDto;

  factory BlogImageDto.fromJson(Map<String, dynamic> json) =>
      _$BlogImageDtoFromJson(json);
}

@freezed
class BlogCategoryDto with _$BlogCategoryDto {
  const factory BlogCategoryDto({
    required int id,
    required String name,
    required String slug,
  }) = _BlogCategoryDto;

  factory BlogCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$BlogCategoryDtoFromJson(json);
}

@freezed
class BlogTagDto with _$BlogTagDto {
  const factory BlogTagDto({
    required int id,
    required String name,
    required String slug,
  }) = _BlogTagDto;

  factory BlogTagDto.fromJson(Map<String, dynamic> json) =>
      _$BlogTagDtoFromJson(json);
}

@freezed
class BlogAuthorDto with _$BlogAuthorDto {
  const factory BlogAuthorDto({
    required int id,
    required String name,
    String? avatar,
  }) = _BlogAuthorDto;

  factory BlogAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$BlogAuthorDtoFromJson(json);
}

@freezed
class BlogPostsResponseDto with _$BlogPostsResponseDto {
  const factory BlogPostsResponseDto({
    required List<BlogPostDto> posts,
    required BlogPaginationDto pagination,
  }) = _BlogPostsResponseDto;

  factory BlogPostsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BlogPostsResponseDtoFromJson(json);
}

@freezed
class BlogPaginationDto with _$BlogPaginationDto {
  const factory BlogPaginationDto({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'total_items') required int totalItems,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'has_next') @Default(false) bool hasNext,
    @JsonKey(name: 'has_prev') @Default(false) bool hasPrev,
  }) = _BlogPaginationDto;

  factory BlogPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$BlogPaginationDtoFromJson(json);
}
