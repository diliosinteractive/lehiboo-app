import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/event_question_dto.dart';

final eventSocialApiDataSourceProvider = Provider<EventSocialApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return EventSocialApiDataSource(dio);
});

/// DataSource pour les features Q&A des événements.
///
/// Note : la partie Reviews a été déplacée vers
/// [lib/features/reviews/data/datasources/reviews_api_datasource.dart].
class EventSocialApiDataSource {
  final Dio _dio;

  EventSocialApiDataSource(this._dio);

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

    // Spec §2.1 : la réponse est `{ message, question: {...} }`.
    // Fallback sur `data` ou la racine pour robustesse si le backend change.
    final data = response.data as Map<String, dynamic>;
    final questionData = (data['question'] ?? data['data'] ?? data)
        as Map<String, dynamic>;
    return EventQuestionDto.fromJson(questionData);
  }

  /// Marque une question comme utile.
  /// Retourne le `helpful_count` renvoyé par le serveur (source de vérité).
  Future<int> markQuestionHelpful(String questionUuid) async {
    debugPrint('=== EventSocialApiDataSource.markQuestionHelpful ===');

    final response = await _dio.post('/questions/$questionUuid/helpful');
    return _parseHelpfulCount(response.data);
  }

  /// Retire le vote utile d'une question.
  /// Retourne le `helpful_count` renvoyé par le serveur.
  Future<int> unmarkQuestionHelpful(String questionUuid) async {
    debugPrint('=== EventSocialApiDataSource.unmarkQuestionHelpful ===');

    final response = await _dio.delete('/questions/$questionUuid/helpful');
    return _parseHelpfulCount(response.data);
  }

  static int _parseHelpfulCount(dynamic data) {
    if (data is! Map) return 0;
    final raw = data['helpful_count'] ?? data['helpfulCount'];
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw) ?? 0;
    if (raw is double) return raw.toInt();
    return 0;
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
