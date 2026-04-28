import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/mappers/event_question_mapper.dart';
import '../../../events/domain/entities/event_question.dart';
import '../../domain/repositories/user_questions_repository.dart';
import '../datasources/user_questions_api_datasource.dart';

class UserQuestionsRepositoryImpl implements UserQuestionsRepository {
  final UserQuestionsApiDataSource _dataSource;

  UserQuestionsRepositoryImpl(this._dataSource);

  @override
  Future<QuestionsPage> getMyQuestions({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dataSource.getMyQuestions(
      page: page,
      perPage: perPage,
    );
    return EventQuestionMapper.pageFromDto(response);
  }
}

final userQuestionsRepositoryProvider = Provider<UserQuestionsRepository>((ref) {
  final dataSource = ref.watch(userQuestionsApiDataSourceProvider);
  return UserQuestionsRepositoryImpl(dataSource);
});
