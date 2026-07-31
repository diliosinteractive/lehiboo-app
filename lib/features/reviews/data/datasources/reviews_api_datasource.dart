import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../domain/entities/review_enums.dart';
import '../models/can_review_dto.dart';
import '../models/review_dto.dart';
import '../models/user_review_dto.dart';

final reviewsApiDataSourceProvider = Provider<ReviewsApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return ReviewsApiDataSource(dio);
});

/// Datasource pour TOUS les endpoints reviews (cf. docs/REVIEWS_API_MOBILE.md).
class ReviewsApiDataSource {
  final Dio _dio;

  ReviewsApiDataSource(this._dio);

  // ---------------------------------------------------------------------------
  // 1. Routes publiques
  // ---------------------------------------------------------------------------

  /// GET /events/{slug}/reviews — liste paginée des avis approuvés.
  Future<ReviewsResponseDto> getEventReviews(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
    int? rating,
    bool verifiedOnly = false,
    bool featuredOnly = false,
    String sortBy = 'helpful',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
    if (rating != null) queryParams['rating'] = rating;
    if (verifiedOnly) queryParams['verified_only'] = true;
    if (featuredOnly) queryParams['featured_only'] = true;

    final response = await _dio.get(
      '/events/$eventSlug/reviews',
      queryParameters: queryParams,
    );

    final data = response.data;
    final reviews = ApiResponseHandler.extractList(data)
        .map(_parseReviewItem)
        .toList(growable: false);
    final meta = _parsePaginationMeta(data, context: 'event reviews');
    return ReviewsResponseDto(data: reviews, meta: meta);
  }

  /// GET /events/{slug}/reviews/stats
  Future<ReviewStatsDto> getEventReviewStats(String eventSlug) async {
    final response = await _dio.get('/events/$eventSlug/reviews/stats');
    final payload = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );
    _validateReviewStats(payload);
    try {
      return ReviewStatsDto.fromJson(payload);
    } catch (_) {
      throw ApiFormatException('Invalid review stats payload', payload);
    }
  }

  // ---------------------------------------------------------------------------
  // 2. Routes authentifiées
  // ---------------------------------------------------------------------------

  /// GET /events/{slug}/reviews/can-review
  Future<CanReviewDto> canReview(String eventSlug) async {
    final response = await _dio.get('/events/$eventSlug/reviews/can-review');
    final payload = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );
    return CanReviewDto.fromJson(payload);
  }

  /// POST /events/{slug}/reviews
  Future<ReviewDto> createReview(
    String eventSlug, {
    required int rating,
    required String title,
    required String comment,
    String? bookingUuid,
  }) async {
    final body = <String, dynamic>{
      'rating': rating,
      'title': title,
      'comment': comment,
    };
    if (bookingUuid != null) body['booking_uuid'] = bookingUuid;

    final response = await _dio.post(
      '/events/$eventSlug/reviews',
      data: body,
    );
    return _readReviewFromResponse(response.data);
  }

  /// GET /reviews/{uuid}
  Future<ReviewDto> getReview(String reviewUuid) async {
    final response = await _dio.get('/reviews/$reviewUuid');
    return _readReviewFromResponse(response.data);
  }

  /// PUT /reviews/{uuid}
  Future<ReviewDto> updateReview(
    String reviewUuid, {
    int? rating,
    String? title,
    String? comment,
  }) async {
    final body = <String, dynamic>{};
    if (rating != null) body['rating'] = rating;
    if (title != null) body['title'] = title;
    if (comment != null) body['comment'] = comment;

    final response = await _dio.put(
      '/reviews/$reviewUuid',
      data: body,
    );
    return _readReviewFromResponse(response.data);
  }

  /// DELETE /reviews/{uuid}
  Future<void> deleteReview(String reviewUuid) async {
    await _dio.delete('/reviews/$reviewUuid');
  }

  /// POST /reviews/{uuid}/vote
  Future<VoteCountsDto> voteReview(
    String reviewUuid, {
    required bool isHelpful,
  }) async {
    final response = await _dio.post(
      '/reviews/$reviewUuid/vote',
      data: {'is_helpful': isHelpful},
    );
    return _readVoteCounts(response.data);
  }

  /// DELETE /reviews/{uuid}/vote
  Future<VoteCountsDto> unvoteReview(String reviewUuid) async {
    final response = await _dio.delete('/reviews/$reviewUuid/vote');
    return _readVoteCounts(response.data);
  }

  /// POST /reviews/{uuid}/report
  Future<void> reportReview(
    String reviewUuid, {
    required ReportReason reason,
    String? details,
  }) async {
    final body = <String, dynamic>{'reason': reason.apiValue};
    if (details != null && details.isNotEmpty) body['details'] = details;

    await _dio.post('/reviews/$reviewUuid/report', data: body);
  }

  /// GET /user/reviews
  Future<UserReviewsResponseDto> getUserReviews({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      '/user/reviews',
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = response.data;
    final reviews = ApiResponseHandler.extractList(data)
        .map(_parseUserReviewItem)
        .toList(growable: false);
    final meta = _parsePaginationMeta(data, context: 'user reviews');
    return UserReviewsResponseDto(data: reviews, meta: meta);
  }

  /// GET /user/reviews/pending-count
  Future<int> getPendingCount() async {
    final response = await _dio.get('/user/reviews/pending-count');
    final payload = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );
    return _readRequiredInt(
      payload,
      const ['count', 'pendingCount', 'pending_count'],
      fieldDescription: 'pending review count',
    );
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  /// Le backend renvoie `{ "message": "...", "review": {...} }` (cf. spec §2.2).
  /// Fallback sur `data` ou la racine si jamais.
  ReviewDto _readReviewFromResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const ApiFormatException('Expected Map for review response');
    }
    final reviewJson =
        (data['review'] ?? data['data'] ?? data) as Map<String, dynamic>;
    return ReviewDto.fromJson(reviewJson);
  }

  VoteCountsDto _readVoteCounts(dynamic data) {
    final payload = ApiResponseHandler.extractObject(data, unwrapRoot: true);
    _validateRequiredIntAliases(
      payload,
      const ['helpful_count', 'helpfulCount'],
      fieldDescription: 'helpful review vote count',
    );
    _validateRequiredIntAliases(
      payload,
      const ['not_helpful_count', 'notHelpfulCount'],
      fieldDescription: 'not-helpful review vote count',
    );
    try {
      return VoteCountsDto.fromJson(payload);
    } catch (_) {
      throw ApiFormatException('Invalid review vote count payload', payload);
    }
  }

  static ReviewDto _parseReviewItem(dynamic item) {
    if (item is! Map<String, dynamic>) {
      throw ApiFormatException('Expected event review item to be a Map', item);
    }
    try {
      return ReviewDto.fromJson(item);
    } catch (_) {
      throw ApiFormatException('Invalid event review item payload', item);
    }
  }

  static UserReviewDto _parseUserReviewItem(dynamic item) {
    if (item is! Map<String, dynamic>) {
      throw ApiFormatException('Expected user review item to be a Map', item);
    }
    try {
      return UserReviewDto.fromJson(item);
    } catch (_) {
      throw ApiFormatException('Invalid user review item payload', item);
    }
  }

  static PaginationMetaDto? _parsePaginationMeta(
    dynamic data, {
    required String context,
  }) {
    if (data is! Map<String, dynamic> || !data.containsKey('meta')) return null;
    final meta = data['meta'];
    if (meta == null) return null;
    if (meta is! Map<String, dynamic>) {
      throw ApiFormatException(
          'Expected $context pagination meta to be a Map', meta);
    }
    return PaginationMetaDto.fromJson(meta);
  }

  static void _validateReviewStats(Map<String, dynamic> payload) {
    _validateRequiredIntAliases(
      payload,
      const ['total_reviews', 'totalReviews'],
      fieldDescription: 'total review count',
    );
    _validateRequiredNumberAliases(
      payload,
      const ['average_rating', 'averageRating'],
      fieldDescription: 'average review rating',
    );
    _validateRequiredIntAliases(
      payload,
      const ['verified_count', 'verifiedCount'],
      fieldDescription: 'verified review count',
    );
    _validateRequiredNumericMap(payload, 'distribution');
    _validateRequiredNumericMap(payload, 'percentages');
  }

  static int _readRequiredInt(
    Map<String, dynamic> payload,
    List<String> keys, {
    required String fieldDescription,
  }) {
    int? firstValue;
    var found = false;
    for (final key in keys) {
      if (!payload.containsKey(key)) continue;
      found = true;
      final value = _parseStrictInt(payload[key], fieldDescription);
      firstValue ??= value;
    }
    if (!found) {
      throw ApiFormatException('Missing $fieldDescription', payload);
    }
    return firstValue!;
  }

  static void _validateRequiredIntAliases(
    Map<String, dynamic> payload,
    List<String> keys, {
    required String fieldDescription,
  }) {
    _readRequiredInt(
      payload,
      keys,
      fieldDescription: fieldDescription,
    );
  }

  static void _validateRequiredNumberAliases(
    Map<String, dynamic> payload,
    List<String> keys, {
    required String fieldDescription,
  }) {
    var found = false;
    for (final key in keys) {
      if (!payload.containsKey(key)) continue;
      found = true;
      _parseStrictNumber(payload[key], fieldDescription);
    }
    if (!found) {
      throw ApiFormatException('Missing $fieldDescription', payload);
    }
  }

  static void _validateRequiredNumericMap(
    Map<String, dynamic> payload,
    String key,
  ) {
    if (!payload.containsKey(key)) {
      throw ApiFormatException('Missing review stats $key', payload);
    }
    final raw = payload[key];
    if (raw is! Map<String, dynamic>) {
      throw ApiFormatException('Invalid review stats $key', raw);
    }
    for (final value in raw.values) {
      final parsed = _parseStrictNumber(value, 'review stats $key value');
      if (parsed != parsed.truncateToDouble()) {
        throw ApiFormatException('Invalid review stats $key value', value);
      }
    }
  }

  static int _parseStrictInt(dynamic raw, String fieldDescription) {
    if (raw is int) return raw;
    if (raw is double && raw.isFinite && raw == raw.truncateToDouble()) {
      return raw.toInt();
    }
    if (raw is String) {
      final value = int.tryParse(raw.trim());
      if (value != null) return value;
    }
    throw ApiFormatException('Invalid $fieldDescription', raw);
  }

  static double _parseStrictNumber(dynamic raw, String fieldDescription) {
    if (raw is num && raw.isFinite) return raw.toDouble();
    if (raw is String) {
      final value = double.tryParse(raw.trim());
      if (value != null && value.isFinite) return value;
    }
    throw ApiFormatException('Invalid $fieldDescription', raw);
  }
}
