import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/event_question.dart';
import '../../domain/repositories/event_questions_repository.dart';
import '../datasources/event_social_api_datasource.dart';
import '../mappers/event_question_mapper.dart';

class EventQuestionsRepositoryImpl implements EventQuestionsRepository {
  final EventSocialApiDataSource _dataSource;

  EventQuestionsRepositoryImpl(this._dataSource);

  @override
  Future<QuestionsPage> getQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dataSource.getEventQuestions(
      eventSlug,
      page: page,
      perPage: perPage,
    );
    return EventQuestionMapper.pageFromDto(response);
  }

  @override
  Future<EventQuestion?> getMyQuestion(String eventSlug) async {
    final dto = await _dataSource.getMyQuestion(eventSlug);
    if (dto == null) return null;
    return EventQuestionMapper.fromDto(dto);
  }

  @override
  Future<EventQuestion> createQuestion(String eventSlug, String text) async {
    try {
      final dto = await _dataSource.createQuestion(eventSlug, question: text);
      return EventQuestionMapper.fromDto(dto);
    } on DioException catch (e) {
      final error = _mapCreateError(e);
      if (error != null) throw error;
      rethrow;
    }
  }

  @override
  Future<int> markHelpful(String questionUuid) async {
    try {
      return await _dataSource.markQuestionHelpful(questionUuid);
    } on DioException catch (e) {
      throw _toVoteException(e);
    }
  }

  @override
  Future<int> unmarkHelpful(String questionUuid) async {
    try {
      return await _dataSource.unmarkQuestionHelpful(questionUuid);
    } on DioException catch (e) {
      throw _toVoteException(e);
    }
  }

  Exception? _mapCreateError(DioException e) {
    if (e.response?.statusCode != 422) return null;
    final data = e.response?.data;
    if (data is! Map) return null;

    final message = data['message']?.toString() ?? '';
    if (message.toLowerCase().contains('already submitted')) {
      return DuplicateQuestionException(message);
    }

    final errors = data['errors'];
    if (errors is Map && errors['question'] is List) {
      final list = (errors['question'] as List)
          .map((e) => e.toString())
          .toList(growable: false);
      return QuestionValidationException(list);
    }

    return null;
  }

  HelpfulVoteException _toVoteException(DioException e) {
    final data = e.response?.data;
    String message = 'Impossible de voter pour le moment.';
    int? serverCount;

    if (data is Map) {
      if (data['message'] is String) {
        message = data['message'] as String;
      }
      final raw = data['helpful_count'] ?? data['helpfulCount'];
      if (raw is int) {
        serverCount = raw;
      } else if (raw is String) {
        serverCount = int.tryParse(raw);
      } else if (raw is double) {
        serverCount = raw.toInt();
      }
    }

    debugPrint('HelpfulVote error ($message), serverCount=$serverCount');
    return HelpfulVoteException(message, serverCount: serverCount);
  }
}
