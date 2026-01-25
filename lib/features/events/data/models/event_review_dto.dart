import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_review_dto.freezed.dart';
part 'event_review_dto.g.dart';

/// Response pour la liste des avis
@freezed
class EventReviewsResponseDto with _$EventReviewsResponseDto {
  const factory EventReviewsResponseDto({
    @Default([]) List<EventReviewDto> data,
    MetaDto? meta,
  }) = _EventReviewsResponseDto;

  factory EventReviewsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EventReviewsResponseDtoFromJson(json);
}

/// Statistiques des avis
@freezed
class ReviewStatsDto with _$ReviewStatsDto {
  const factory ReviewStatsDto({
    @JsonKey(name: 'total_reviews', fromJson: _parseInt) @Default(0) int totalReviews,
    @JsonKey(name: 'totalReviews', fromJson: _parseInt) @Default(0) int totalReviewsCamel,
    @JsonKey(name: 'average_rating', fromJson: _parseDouble) @Default(0) double averageRating,
    @JsonKey(name: 'averageRating', fromJson: _parseDouble) @Default(0) double averageRatingCamel,
    @JsonKey(name: 'verified_count', fromJson: _parseInt) @Default(0) int verifiedCount,
    @JsonKey(name: 'verifiedCount', fromJson: _parseInt) @Default(0) int verifiedCountCamel,
    @Default({}) Map<String, int> distribution,
    @Default({}) Map<String, int> percentages,
  }) = _ReviewStatsDto;

  factory ReviewStatsDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatsDtoFromJson(json);
}

/// Un avis individuel
@freezed
class EventReviewDto with _$EventReviewDto {
  const factory EventReviewDto({
    required String uuid,
    @JsonKey(fromJson: _parseInt) @Default(0) int rating,
    @JsonKey(fromJson: _parseStringOrNull) String? title,
    @JsonKey(fromJson: _parseString) @Default('') String comment,
    @JsonKey(name: 'helpful_count', fromJson: _parseInt) @Default(0) int helpfulCount,
    @JsonKey(name: 'helpfulCount', fromJson: _parseInt) @Default(0) int helpfulCountCamel,
    @JsonKey(name: 'not_helpful_count', fromJson: _parseInt) @Default(0) int notHelpfulCount,
    @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt) @Default(0) int notHelpfulCountCamel,
    @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool) @Default(false) bool isVerifiedPurchase,
    @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool) @Default(false) bool isVerifiedPurchaseCamel,
    @JsonKey(name: 'is_featured', fromJson: _parseBool) @Default(false) bool isFeatured,
    @JsonKey(name: 'isFeatured', fromJson: _parseBool) @Default(false) bool isFeaturedCamel,
    ReviewAuthorDto? author,
    ReviewResponseDto? response,
    @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull) bool? userVote,
    @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull) bool? userVoteCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: _parseString) @Default('') String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: _parseString) @Default('') String createdAtFormattedCamel,
  }) = _EventReviewDto;

  factory EventReviewDto.fromJson(Map<String, dynamic> json) =>
      _$EventReviewDtoFromJson(json);
}

/// Auteur d'un avis
@freezed
class ReviewAuthorDto with _$ReviewAuthorDto {
  const factory ReviewAuthorDto({
    @JsonKey(fromJson: _parseString) @Default('') String name,
    @JsonKey(fromJson: _parseStringOrNull) String? avatar,
    @JsonKey(fromJson: _parseString) @Default('') String initials,
  }) = _ReviewAuthorDto;

  factory ReviewAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewAuthorDtoFromJson(json);
}

/// Réponse de l'organisateur à un avis
@freezed
class ReviewResponseDto with _$ReviewResponseDto {
  const factory ReviewResponseDto({
    required String uuid,
    @JsonKey(fromJson: _parseString) @Default('') String response,
    @JsonKey(name: 'organization_name', fromJson: _parseString) @Default('') String organizationName,
    @JsonKey(name: 'organizationName', fromJson: _parseString) @Default('') String organizationNameCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: _parseString) @Default('') String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: _parseString) @Default('') String createdAtFormattedCamel,
  }) = _ReviewResponseDto;

  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseDtoFromJson(json);
}

/// Metadata de pagination
@freezed
class MetaDto with _$MetaDto {
  const factory MetaDto({
    @JsonKey(name: 'current_page', fromJson: _parseInt) @Default(1) int currentPage,
    @JsonKey(name: 'last_page', fromJson: _parseInt) @Default(1) int lastPage,
    @JsonKey(name: 'per_page', fromJson: _parseInt) @Default(15) int perPage,
    @JsonKey(fromJson: _parseInt) @Default(0) int total,
  }) = _MetaDto;

  factory MetaDto.fromJson(Map<String, dynamic> json) =>
      _$MetaDtoFromJson(json);
}

// Parsing helpers
String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? _parseStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false;
}

bool? _parseBoolOrNull(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    if (value.toLowerCase() == 'true' || value == '1') return true;
    if (value.toLowerCase() == 'false' || value == '0') return false;
  }
  return null;
}
