import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/user_questions/domain/repositories/user_questions_repository.dart';
import 'package:lehiboo/features/user_questions/presentation/providers/user_questions_provider.dart';

class _FakeUserQuestionsRepository implements UserQuestionsRepository {
  bool failSecondPage = true;

  @override
  Future<QuestionsPage> getMyQuestions({int page = 1, int perPage = 15}) async {
    if (page == 1) {
      return const QuestionsPage(
        items: [EventQuestion(uuid: 'q1', question: 'First question')],
        currentPage: 1,
        lastPage: 2,
        total: 2,
      );
    }

    if (failSecondPage) throw Exception('connection failed');

    return const QuestionsPage(
      items: [EventQuestion(uuid: 'q2', question: 'Second question')],
      currentPage: 2,
      lastPage: 2,
      total: 2,
    );
  }
}

void main() {
  test('pagination failure preserves questions and can be retried', () async {
    final repository = _FakeUserQuestionsRepository();
    final controller = UserQuestionsListController(repository);
    addTearDown(controller.dispose);

    await controller.stream.firstWhere((state) => state.hasValue);
    expect(controller.state.valueOrNull!.items.single.uuid, 'q1');

    await controller.loadMore();

    expect(controller.state.valueOrNull!.loadMoreError, isNotNull);
    expect(controller.state.valueOrNull!.items.single.uuid, 'q1');

    repository.failSecondPage = false;
    await controller.retryLoadMore();

    expect(controller.state.valueOrNull!.loadMoreError, isNull);
    expect(
      controller.state.valueOrNull!.items.map((item) => item.uuid),
      ['q1', 'q2'],
    );
    expect(controller.state.valueOrNull!.hasMore, isFalse);
  });
}
