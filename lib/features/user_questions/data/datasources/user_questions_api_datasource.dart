import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../events/data/models/event_question_dto.dart';

final userQuestionsApiDataSourceProvider =
    Provider<UserQuestionsApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return UserQuestionsApiDataSource(dio);
});

/// DataSource pour les endpoints user-scopés liés aux Questions.
///
/// Cible `GET /user/questions` (spec `docs/USER_QUESTIONS_API.md`).
class UserQuestionsApiDataSource {
  final Dio _dio;

  UserQuestionsApiDataSource(this._dio);

  /// Liste paginée des questions de l'utilisateur authentifié, tous événements
  /// et tous statuts confondus. Tri figé `created_at DESC`.
  Future<EventQuestionsResponseDto> getMyQuestions({
    int page = 1,
    int perPage = 15,
  }) async {
    debugPrint('=== UserQuestionsApiDataSource.getMyQuestions ===');

    final response = await _dio.get(
      '/user/questions',
      queryParameters: <String, dynamic>{
        'page': page,
        'per_page': perPage,
      },
    );

    final data = response.data;
    final questions = ApiResponseHandler.extractList(data)
        .map(_parseQuestionItem)
        .toList(growable: false);
    final meta = _parseQuestionsMeta(data);

    return EventQuestionsResponseDto(data: questions, meta: meta);
  }

  static EventQuestionDto _parseQuestionItem(dynamic item) {
    if (item is! Map<String, dynamic>) {
      throw ApiFormatException('Expected user question item to be a Map', item);
    }
    try {
      return EventQuestionDto.fromJson(item);
    } catch (_) {
      throw ApiFormatException('Invalid user question item payload', item);
    }
  }

  static MetaPaginationDto? _parseQuestionsMeta(dynamic data) {
    if (data is! Map<String, dynamic> || !data.containsKey('meta')) return null;
    final meta = data['meta'];
    if (meta == null) return null;
    if (meta is! Map<String, dynamic>) {
      throw ApiFormatException(
        'Expected user question pagination meta to be a Map',
        meta,
      );
    }
    return MetaPaginationDto.fromJson(meta);
  }
}
