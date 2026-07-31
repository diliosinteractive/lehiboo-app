import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/events/domain/repositories/event_questions_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_questions_providers.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'user-a');

void main() {
  test('question views replace personalized data on account switch and logout',
      () async {
    final repository = _ControlledQuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final preview = eventQuestionsPreviewProvider('event');
    final mine = myQuestionProvider('event');
    final full = eventQuestionsListControllerProvider('event');
    final previewSubscription = container.listen(
      preview,
      (_, __) {},
      fireImmediately: true,
    );
    final mineSubscription = container.listen(
      mine,
      (_, __) {},
      fireImmediately: true,
    );
    final fullSubscription = container.listen(
      full,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(previewSubscription.close);
    addTearDown(mineSubscription.close);
    addTearDown(fullSubscription.close);

    expect(repository.previewRequests, hasLength(1));
    expect(repository.fullListRequests, hasLength(1));
    expect(repository.myQuestionRequests, hasLength(1));

    _setAccount(container, 'user-b');
    await _flush();

    expect(container.read(preview).isLoading, isTrue);
    expect(container.read(preview).valueOrNull, isNull);
    expect(container.read(full).isLoading, isTrue);
    expect(container.read(full).valueOrNull, isNull);
    expect(container.read(mine).isLoading, isTrue);
    expect(container.read(mine).valueOrNull, isNull);
    expect(repository.previewRequests, hasLength(2));
    expect(repository.fullListRequests, hasLength(2));
    expect(repository.myQuestionRequests, hasLength(2));

    repository.previewRequests[1].completer.complete(
      _page('preview-b', userVoted: true),
    );
    repository.fullListRequests[1].completer.complete(
      _page('full-b', userVoted: true),
    );
    repository.myQuestionRequests[1].complete(_question('mine-b'));
    await _flush();

    expect(container.read(preview).requireValue.items.single.uuid, 'preview-b');
    expect(container.read(preview).requireValue.items.single.userVoted, isTrue);
    expect(container.read(full).requireValue.items.single.uuid, 'full-b');
    expect(container.read(full).requireValue.items.single.userVoted, isTrue);
    expect(container.read(mine).requireValue?.uuid, 'mine-b');

    repository.previewRequests[0].completer.complete(
      _page('preview-a', userVoted: false),
    );
    repository.fullListRequests[0].completer.complete(
      _page('full-a', userVoted: false),
    );
    repository.myQuestionRequests[0].complete(_question('mine-a'));
    await _flush();

    expect(container.read(preview).requireValue.items.single.uuid, 'preview-b');
    expect(container.read(full).requireValue.items.single.uuid, 'full-b');
    expect(container.read(mine).requireValue?.uuid, 'mine-b');

    _setAccount(container, null);
    await _flush();

    expect(container.read(preview).isLoading, isTrue);
    expect(container.read(preview).valueOrNull?.items.single.uuid, 'preview-b');
    expect(
      container.read(preview).valueOrNull?.items.single.userVoted,
      isFalse,
    );
    expect(container.read(full).isLoading, isTrue);
    expect(container.read(full).valueOrNull?.items.single.uuid, 'full-b');
    expect(
      container.read(full).valueOrNull?.items.single.userVoted,
      isFalse,
    );
    expect(container.read(mine), const AsyncValue<EventQuestion?>.data(null));
    expect(repository.myQuestionRequests, hasLength(2));
    expect(repository.previewRequests, hasLength(3));
    expect(repository.fullListRequests, hasLength(3));

    repository.previewRequests[2].completer.complete(
      _page('preview-public', userVoted: false),
    );
    repository.fullListRequests[2].completer.complete(
      _page('full-public', userVoted: false),
    );
    await _flush();

    expect(
      container.read(preview).requireValue.items.single.uuid,
      'preview-public',
    );
    expect(
      container.read(preview).requireValue.items.single.userVoted,
      isFalse,
    );
    expect(container.read(full).requireValue.items.single.uuid, 'full-public');
  });

  test('refresh supersedes an older pagination response', () async {
    final repository = _ControlledQuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final provider = eventQuestionsListControllerProvider('event');
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.fullListRequests.single.completer.complete(
      QuestionsPage(
        items: [_question('page-1')],
        currentPage: 1,
        lastPage: 2,
        total: 2,
      ),
    );
    await _flush();

    final notifier = container.read(provider.notifier);
    final loadingMore = notifier.loadMore();
    expect(repository.fullListRequests, hasLength(2));
    final refreshing = notifier.refresh();
    expect(repository.fullListRequests, hasLength(3));

    repository.fullListRequests[2].completer.complete(
      _page('refreshed', userVoted: false),
    );
    await refreshing;
    expect(
        container.read(provider).requireValue.items.single.uuid, 'refreshed');

    repository.fullListRequests[1].completer.complete(
      QuestionsPage(
        items: [_question('stale-page-2')],
        currentPage: 2,
        lastPage: 2,
        total: 2,
      ),
    );
    await loadingMore;
    expect(
        container.read(provider).requireValue.items.single.uuid, 'refreshed');
  });

  test('old-account vote completion cannot update or roll back the new account',
      () async {
    final repository = _ControlledQuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final listProvider = eventQuestionsListControllerProvider('event');
    final listSubscription = container.listen(
      listProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final actionsSubscription = container.listen(
      eventQuestionsActionsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(listSubscription.close);
    addTearDown(actionsSubscription.close);

    final accountAQuestion = _question(
      'shared-question',
      helpfulCount: 2,
      userVoted: false,
    );
    repository.fullListRequests.single.completer.complete(
      QuestionsPage(items: [accountAQuestion], total: 1),
    );
    await _flush();

    final oldList = container.read(listProvider.notifier);
    final oldActions = container.read(eventQuestionsActionsProvider.notifier);
    final voting = oldActions.toggleHelpful(
      eventSlug: 'event',
      question: accountAQuestion,
      listController: oldList,
    );
    expect(repository.voteRequests, hasLength(1));
    expect(
      container.read(listProvider).requireValue.items.single.helpfulCount,
      3,
    );

    _setAccount(container, 'user-b');
    await _flush();
    expect(container.read(listProvider).isLoading, isTrue);
    expect(
      container.read(listProvider).valueOrNull?.items.single.helpfulCount,
      2,
    );
    expect(
      container.read(listProvider).valueOrNull?.items.single.userVoted,
      isFalse,
    );
    repository.fullListRequests[1].completer.complete(
      QuestionsPage(
        items: [
          _question(
            'shared-question',
            helpfulCount: 7,
            userVoted: false,
          ),
        ],
        total: 1,
      ),
    );
    await _flush();

    repository.voteRequests.single.completeError(StateError('vote failed'));
    expect(await voting, isFalse);
    expect(
      container.read(listProvider).requireValue.items.single.helpfulCount,
      7,
    );
    expect(
      container.read(listProvider).requireValue.items.single.userVoted,
      isFalse,
    );

    expect(
      await oldActions.toggleHelpful(
        eventSlug: 'event',
        question: accountAQuestion,
        listController: oldList,
      ),
      isFalse,
    );
    expect(repository.voteRequests, hasLength(1));

    _setAccount(container, null);
    final anonymousActions =
        container.read(eventQuestionsActionsProvider.notifier);
    expect(
      await anonymousActions.toggleHelpful(
        eventSlug: 'event',
        question: accountAQuestion,
      ),
      isFalse,
    );
    expect(
      await anonymousActions.createQuestion(
        eventSlug: 'event',
        text: 'Is this a valid question?',
      ),
      isA<CreateQuestionFailure>(),
    );
    expect(repository.voteRequests, hasLength(1));
    expect(repository.createCalls, 0);

    await _flush();
    expect(repository.fullListRequests, hasLength(3));
    repository.fullListRequests[2].completer.complete(const QuestionsPage());
  });

  test('A -> B -> A replaces question actions and private my-question state',
      () async {
    final repository = _ControlledQuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final listProvider = eventQuestionsListControllerProvider('event');
    final mineProvider = myQuestionProvider('event');
    final listSubscription = container.listen(
      listProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final mineSubscription = container.listen(
      mineProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final actionsSubscription = container.listen(
      eventQuestionsActionsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(listSubscription.close);
    addTearDown(mineSubscription.close);
    addTearDown(actionsSubscription.close);

    final oldList = container.read(listProvider.notifier);
    final oldActions = container.read(eventQuestionsActionsProvider.notifier);

    _setAccount(container, 'user-b');
    await _flush();
    _setAccount(container, 'user-a');
    await _flush();

    expect(repository.fullListRequests, hasLength(3));
    expect(repository.myQuestionRequests, hasLength(3));
    expect(
      container.read(eventQuestionsActionsProvider.notifier),
      isNot(same(oldActions)),
    );

    repository.myQuestionRequests[0].complete(_question('old-private-a'));
    await _flush();
    expect(container.read(mineProvider).valueOrNull, isNull);

    final staleQuestion = _question('stale-a');
    expect(
      await oldActions.toggleHelpful(
        eventSlug: 'event',
        question: staleQuestion,
        listController: oldList,
      ),
      isFalse,
    );
    expect(repository.voteRequests, isEmpty);

    repository.myQuestionRequests[2].complete(_question('replacement-a'));
    await _flush();
    expect(container.read(mineProvider).requireValue?.uuid, 'replacement-a');
  });
}

ProviderContainer _container(EventQuestionsRepository repository) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_accountIdProvider),
      ),
      eventQuestionsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

void _setAccount(ProviderContainer container, String? accountId) {
  container.read(_accountIdProvider.notifier).state = accountId;
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

QuestionsPage _page(String uuid, {required bool userVoted}) => QuestionsPage(
      items: [_question(uuid, userVoted: userVoted)],
      total: 1,
    );

EventQuestion _question(
  String uuid, {
  int helpfulCount = 0,
  bool userVoted = false,
}) =>
    EventQuestion(
      uuid: uuid,
      question: uuid,
      helpfulCount: helpfulCount,
      userVoted: userVoted,
    );

class _QuestionsRequest {
  _QuestionsRequest({
    required this.page,
    required this.perPage,
  });

  final int page;
  final int perPage;
  final Completer<QuestionsPage> completer = Completer<QuestionsPage>();
}

class _ControlledQuestionsRepository implements EventQuestionsRepository {
  final List<_QuestionsRequest> previewRequests = [];
  final List<_QuestionsRequest> fullListRequests = [];
  final List<Completer<EventQuestion?>> myQuestionRequests = [];
  final List<Completer<int>> voteRequests = [];
  int createCalls = 0;

  @override
  Future<QuestionsPage> getQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
  }) {
    final request = _QuestionsRequest(page: page, perPage: perPage);
    if (perPage == kQuestionsPreviewSize) {
      previewRequests.add(request);
    } else {
      fullListRequests.add(request);
    }
    return request.completer.future;
  }

  @override
  Future<EventQuestion?> getMyQuestion(String eventSlug) {
    final request = Completer<EventQuestion?>();
    myQuestionRequests.add(request);
    return request.future;
  }

  @override
  Future<int> markHelpful(String questionUuid) {
    final request = Completer<int>();
    voteRequests.add(request);
    return request.future;
  }

  @override
  Future<EventQuestion> createQuestion(String eventSlug, String text) {
    createCalls += 1;
    return Future<EventQuestion>.value(_question('created'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
