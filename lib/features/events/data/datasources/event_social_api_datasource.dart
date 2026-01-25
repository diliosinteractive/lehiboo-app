import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/event_review_dto.dart';
import '../models/event_question_dto.dart';

final eventSocialApiDataSourceProvider = Provider<EventSocialApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return EventSocialApiDataSource(dio);
});

/// DataSource pour les features sociales des événements (Reviews & Q&A)
class EventSocialApiDataSource {
  final Dio _dio;

  EventSocialApiDataSource(this._dio);

  // ============ REVIEWS ============

  /// Récupère la liste des avis approuvés pour un événement
  Future<EventReviewsResponseDto> getEventReviews(
    String eventSlug, {
    int page = 1,
    int perPage = 15,
    int? rating,
    bool verifiedOnly = false,
    bool featuredOnly = false,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    debugPrint('=== EventSocialApiDataSource.getEventReviews ===');
    debugPrint('Event slug: $eventSlug');

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

    // L'API retourne { success: true, data: [...], meta: {...} }
    if (data is Map<String, dynamic>) {
      final reviews = (data['data'] as List<dynamic>?)
          ?.map((e) => EventReviewDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];

      MetaDto? meta;
      if (data['meta'] != null) {
        meta = MetaDto.fromJson(data['meta'] as Map<String, dynamic>);
      }

      return EventReviewsResponseDto(data: reviews, meta: meta);
    }

    return const EventReviewsResponseDto();
  }

  /// Récupère les statistiques des avis pour un événement
  Future<ReviewStatsDto> getEventReviewStats(String eventSlug) async {
    debugPrint('=== EventSocialApiDataSource.getEventReviewStats ===');
    debugPrint('Event slug: $eventSlug');

    final response = await _dio.get('/events/$eventSlug/reviews/stats');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // L'API retourne { success: true, data: {...stats...} }
      final statsData = data['data'] ?? data;
      return ReviewStatsDto.fromJson(statsData as Map<String, dynamic>);
    }

    return const ReviewStatsDto();
  }

  /// Crée un nouvel avis (authentification requise)
  Future<EventReviewDto> createReview(
    String eventSlug, {
    required int rating,
    String? title,
    required String comment,
  }) async {
    debugPrint('=== EventSocialApiDataSource.createReview ===');

    final response = await _dio.post(
      '/events/$eventSlug/reviews',
      data: {
        'rating': rating,
        if (title != null) 'title': title,
        'comment': comment,
      },
    );

    final data = response.data;
    final reviewData = data['data'] ?? data;
    return EventReviewDto.fromJson(reviewData as Map<String, dynamic>);
  }

  /// Vote utile/pas utile sur un avis
  Future<void> voteReview(String reviewUuid, {required bool isHelpful}) async {
    debugPrint('=== EventSocialApiDataSource.voteReview ===');
    debugPrint('Review UUID: $reviewUuid, isHelpful: $isHelpful');

    await _dio.post(
      '/reviews/$reviewUuid/vote',
      data: {'is_helpful': isHelpful},
    );
  }

  /// Retire le vote sur un avis
  Future<void> unvoteReview(String reviewUuid) async {
    debugPrint('=== EventSocialApiDataSource.unvoteReview ===');

    await _dio.delete('/reviews/$reviewUuid/vote');
  }

  /// Vérifie si l'utilisateur peut laisser un avis
  Future<bool> canReview(String eventSlug) async {
    try {
      final response = await _dio.get('/events/$eventSlug/reviews/can-review');
      final data = response.data;
      return data['data']?['can_review'] ?? data['can_review'] ?? false;
    } catch (e) {
      debugPrint('Error checking canReview: $e');
      return false;
    }
  }

  // ============ QUESTIONS ============

  /// Récupère la liste des questions visibles pour un événement
  Future<EventQuestionsResponseDto> getEventQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 15,
    bool answeredOnly = false,
    bool unansweredOnly = false,
  }) async {
    debugPrint('=== EventSocialApiDataSource.getEventQuestions ===');
    debugPrint('Event slug: $eventSlug');

    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (answeredOnly) queryParams['answered_only'] = true;
    if (unansweredOnly) queryParams['unanswered_only'] = true;

    final response = await _dio.get(
      '/events/$eventSlug/questions',
      queryParameters: queryParams,
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final questions = (data['data'] as List<dynamic>?)
          ?.map((e) => EventQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];

      MetaPaginationDto? meta;
      if (data['meta'] != null) {
        meta = MetaPaginationDto.fromJson(data['meta'] as Map<String, dynamic>);
      }

      return EventQuestionsResponseDto(data: questions, meta: meta);
    }

    return const EventQuestionsResponseDto();
  }

  /// Pose une nouvelle question (authentification optionnelle)
  Future<EventQuestionDto> createQuestion(
    String eventSlug, {
    required String question,
    String? guestName,
    String? guestEmail,
  }) async {
    debugPrint('=== EventSocialApiDataSource.createQuestion ===');

    final requestData = <String, dynamic>{
      'question': question,
    };

    // Pour les utilisateurs non connectés
    if (guestName != null) requestData['guest_name'] = guestName;
    if (guestEmail != null) requestData['guest_email'] = guestEmail;

    final response = await _dio.post(
      '/events/$eventSlug/questions',
      data: requestData,
    );

    final data = response.data;
    final questionData = data['data'] ?? data;
    return EventQuestionDto.fromJson(questionData as Map<String, dynamic>);
  }

  /// Marque une question comme utile
  Future<void> markQuestionHelpful(String questionUuid) async {
    debugPrint('=== EventSocialApiDataSource.markQuestionHelpful ===');

    await _dio.post('/questions/$questionUuid/helpful');
  }

  /// Retire le vote utile d'une question
  Future<void> unmarkQuestionHelpful(String questionUuid) async {
    debugPrint('=== EventSocialApiDataSource.unmarkQuestionHelpful ===');

    await _dio.delete('/questions/$questionUuid/helpful');
  }

  /// Récupère la question de l'utilisateur connecté pour un événement
  Future<EventQuestionDto?> getMyQuestion(String eventSlug) async {
    try {
      final response = await _dio.get('/events/$eventSlug/my-question');
      final data = response.data;

      if (data['data'] != null) {
        return EventQuestionDto.fromJson(data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting myQuestion: $e');
      return null;
    }
  }
}
