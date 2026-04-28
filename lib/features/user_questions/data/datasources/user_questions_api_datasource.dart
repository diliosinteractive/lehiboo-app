import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
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

    if (data is Map<String, dynamic>) {
      final questions = (data['data'] as List<dynamic>?)
              ?.map((e) => EventQuestionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      MetaPaginationDto? meta;
      if (data['meta'] != null) {
        meta = MetaPaginationDto.fromJson(data['meta'] as Map<String, dynamic>);
      }

      return EventQuestionsResponseDto(data: questions, meta: meta);
    }

    return const EventQuestionsResponseDto();
  }
}
