import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/event_question_dto.dart';

final eventSocialApiDataSourceProvider =
    Provider<EventSocialApiDataSource>((ref) {
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
    final questions = ApiResponseHandler.extractList(data)
        .map(_parseQuestionItem)
        .toList(growable: false);
    final meta = _parseQuestionsMeta(data);

    return EventQuestionsResponseDto(data: questions, meta: meta);
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
    final questionData =
        (data['question'] ?? data['data'] ?? data) as Map<String, dynamic>;
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
    final payload = ApiResponseHandler.extractObject(data, unwrapRoot: true);
    return _readRequiredInt(
      payload,
      const ['helpful_count', 'helpfulCount'],
      fieldDescription: 'question helpful count',
    );
  }

  static EventQuestionDto _parseQuestionItem(dynamic item) {
    if (item is! Map<String, dynamic>) {
      throw ApiFormatException('Expected question item to be a Map', item);
    }
    try {
      return EventQuestionDto.fromJson(item);
    } catch (_) {
      throw ApiFormatException('Invalid question item payload', item);
    }
  }

  static MetaPaginationDto? _parseQuestionsMeta(dynamic data) {
    if (data is! Map<String, dynamic> || !data.containsKey('meta')) return null;
    final meta = data['meta'];
    if (meta == null) return null;
    if (meta is! Map<String, dynamic>) {
      throw ApiFormatException(
          'Expected question pagination meta to be a Map', meta);
    }
    return MetaPaginationDto.fromJson(meta);
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

  /// Récupère la question de l'utilisateur connecté pour un événement
  Future<EventQuestionDto?> getMyQuestion(String eventSlug) async {
    try {
      final response = await _dio.get('/events/$eventSlug/my-question');
      if (response.statusCode == 204 || response.statusCode == 404) {
        return null;
      }

      final data = response.data;
      if (data is Map<String, dynamic> &&
          data.containsKey('data') &&
          data['data'] == null) {
        return null;
      }

      final payload = ApiResponseHandler.extractObject(data);
      return EventQuestionDto.fromJson(payload);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404 ||
          error.response?.statusCode == 204) {
        return null;
      }
      debugPrint('Error getting myQuestion: $error');
      rethrow;
    }
  }
}
