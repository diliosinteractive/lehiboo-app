import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    if (data is Map<String, dynamic>) {
      final reviews = (data['data'] as List<dynamic>?)
              ?.map((e) => ReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      PaginationMetaDto? meta;
      if (data['meta'] is Map<String, dynamic>) {
        meta = PaginationMetaDto.fromJson(data['meta'] as Map<String, dynamic>);
      }
      return ReviewsResponseDto(data: reviews, meta: meta);
    }
    return const ReviewsResponseDto();
  }

  /// GET /events/{slug}/reviews/stats
  Future<ReviewStatsDto> getEventReviewStats(String eventSlug) async {
    final response = await _dio.get('/events/$eventSlug/reviews/stats');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final statsData = data['data'] ?? data;
      return ReviewStatsDto.fromJson(statsData as Map<String, dynamic>);
    }
    return const ReviewStatsDto();
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
    if (data is Map<String, dynamic>) {
      final reviews = (data['data'] as List<dynamic>?)
              ?.map((e) => UserReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      PaginationMetaDto? meta;
      if (data['meta'] is Map<String, dynamic>) {
        meta = PaginationMetaDto.fromJson(data['meta'] as Map<String, dynamic>);
      }
      return UserReviewsResponseDto(data: reviews, meta: meta);
    }
    return const UserReviewsResponseDto();
  }

  /// GET /user/reviews/pending-count
  Future<int> getPendingCount() async {
    final response = await _dio.get('/user/reviews/pending-count');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      // Spec : `{ "count": N, "pendingCount": N }`
      final count = data['count'] ?? data['pendingCount'] ?? data['pending_count'];
      if (count is int) return count;
      if (count is String) return int.tryParse(count) ?? 0;
      if (count is double) return count.toInt();
    }
    return 0;
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
    final reviewJson = (data['review'] ?? data['data'] ?? data)
        as Map<String, dynamic>;
    return ReviewDto.fromJson(reviewJson);
  }

  VoteCountsDto _readVoteCounts(dynamic data) {
    if (data is Map<String, dynamic>) {
      try {
        return VoteCountsDto.fromJson(data);
      } catch (e) {
        debugPrint('VoteCountsDto.fromJson failed, returning zeros: $e');
      }
    }
    return const VoteCountsDto();
  }
}
