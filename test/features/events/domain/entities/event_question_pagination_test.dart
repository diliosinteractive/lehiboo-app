import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/events/domain/repositories/event_questions_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_questions_providers.dart';

void main() {
  test('questions page preserves and explicitly clears load-more errors', () {
    final failure = Exception('next page unavailable');
    final failed = const QuestionsPage(
      currentPage: 1,
      lastPage: 2,
    ).copyWith(loadMoreError: failure);

    expect(failed.loadMoreError, same(failure));
    expect(failed.copyWith().loadMoreError, same(failure));
    expect(failed.copyWith(loadMoreError: null).loadMoreError, isNull);
  });

  test('questions page exposes load-more progress separately', () {
    final loading = const QuestionsPage(
      currentPage: 1,
      lastPage: 2,
    ).copyWith(isLoadingMore: true);

    expect(loading.hasMore, isTrue);
    expect(loading.isLoadingMore, isTrue);
  });

  test('a server-count vote conflict is reconciled without a false error',
      () async {
    final provider = StateNotifierProvider<EventQuestionsActionsController,
        AsyncValue<void>>(
      (ref) => EventQuestionsActionsController(
        const _ServerCountQuestionsRepository(),
        ref,
        ownerSession: ref.watch(authSessionKeyProvider),
      ),
    );
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWithValue('user-1'),
      ],
    );
    addTearDown(container.dispose);

    final updated = await container.read(provider.notifier).toggleHelpful(
          eventSlug: 'event',
          question: const EventQuestion(
            uuid: 'question',
            question: 'Is parking available?',
            helpfulCount: 2,
          ),
        );

    expect(updated, isTrue);
  });
}

class _ServerCountQuestionsRepository implements EventQuestionsRepository {
  const _ServerCountQuestionsRepository();

  @override
  Future<int> markHelpful(String questionUuid) async {
    throw const HelpfulVoteException('already synchronized', serverCount: 3);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
