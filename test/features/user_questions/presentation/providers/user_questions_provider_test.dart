import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/user_questions/data/repositories/user_questions_repository_impl.dart';
import 'package:lehiboo/features/user_questions/domain/repositories/user_questions_repository.dart';
import 'package:lehiboo/features/user_questions/presentation/providers/user_questions_provider.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'user-a');

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
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      userQuestionsListControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await _flush();
    final controller =
        container.read(userQuestionsListControllerProvider.notifier);
    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .items
          .single
          .uuid,
      'q1',
    );

    await controller.loadMore();

    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .loadMoreError,
      isNotNull,
    );
    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .items
          .single
          .uuid,
      'q1',
    );

    repository.failSecondPage = false;
    await controller.retryLoadMore();

    final page =
        container.read(userQuestionsListControllerProvider).requireValue;
    expect(page.loadMoreError, isNull);
    expect(
      page.items.map((item) => item.uuid),
      ['q1', 'q2'],
    );
    expect(page.hasMore, isFalse);
  });

  test('account switch clears user questions and ignores late responses',
      () async {
    final repository = _ControlledUserQuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      userQuestionsListControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    expect(repository.requests, hasLength(1));
    _setAccount(container, 'user-b');
    await _flush();

    expect(
        container.read(userQuestionsListControllerProvider).isLoading, isTrue);
    expect(
      container.read(userQuestionsListControllerProvider).valueOrNull,
      isNull,
    );
    expect(repository.requests, hasLength(2));

    repository.requests[1].completer.complete(_page('question-b'));
    await _flush();
    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .items
          .single
          .uuid,
      'question-b',
    );

    repository.requests[0].completer.complete(_page('question-a'));
    await _flush();
    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .items
          .single
          .uuid,
      'question-b',
    );

    _setAccount(container, null);
    await _flush();
    expect(
      container.read(userQuestionsListControllerProvider).requireValue.items,
      isEmpty,
    );
    expect(repository.requests, hasLength(2));
  });

  test('rapid A to B to A creates a fresh blank questions controller',
      () async {
    final repository = _ControlledUserQuestionsRepository();
    late _MutableAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _MutableAuthNotifier(ref);
          return auth;
        }),
        userQuestionsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      userQuestionsListControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final firstAController =
        container.read(userQuestionsListControllerProvider.notifier);
    expect(repository.requests, hasLength(1));

    // Deliberately do not yield between these transitions. A provider keyed
    // only by the final account-id string could otherwise collapse back to A.
    auth.setAccount('user-b');
    auth.setAccount('user-a');

    final secondAController =
        container.read(userQuestionsListControllerProvider.notifier);
    expect(identical(secondAController, firstAController), isFalse);
    expect(
        container.read(userQuestionsListControllerProvider).isLoading, isTrue);
    expect(
      container.read(userQuestionsListControllerProvider).valueOrNull,
      isNull,
    );
    expect(repository.requests, hasLength(2));

    repository.requests[0].completer.complete(_page('stale-first-a'));
    await _flush();
    expect(
      container.read(userQuestionsListControllerProvider).valueOrNull,
      isNull,
    );

    repository.requests[1].completer.complete(_page('current-second-a'));
    await _flush();
    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .items
          .single
          .uuid,
      'current-second-a',
    );
  });

  test('refresh supersedes an older user-question pagination response',
      () async {
    final repository = _ControlledUserQuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      userQuestionsListControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    repository.requests.single.completer.complete(
      const QuestionsPage(
        items: [EventQuestion(uuid: 'first', question: 'first')],
        currentPage: 1,
        lastPage: 2,
        total: 2,
      ),
    );
    await _flush();

    final controller =
        container.read(userQuestionsListControllerProvider.notifier);
    final loadMore = controller.loadMore();
    final refresh = controller.refresh();
    expect(repository.requests, hasLength(3));

    repository.requests[2].completer.complete(_page('refreshed'));
    await refresh;
    repository.requests[1].completer.complete(
      const QuestionsPage(
        items: [EventQuestion(uuid: 'stale', question: 'stale')],
        currentPage: 2,
        lastPage: 2,
        total: 2,
      ),
    );
    await loadMore;

    expect(
      container
          .read(userQuestionsListControllerProvider)
          .requireValue
          .items
          .single
          .uuid,
      'refreshed',
    );
  });
}

ProviderContainer _container(UserQuestionsRepository repository) =>
    ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_accountIdProvider),
        ),
        userQuestionsRepositoryProvider.overrideWithValue(repository),
      ],
    );

void _setAccount(ProviderContainer container, String? accountId) {
  container.read(_accountIdProvider.notifier).state = accountId;
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

QuestionsPage _page(String uuid) => QuestionsPage(
      items: [EventQuestion(uuid: uuid, question: uuid)],
      total: 1,
    );

class _UserQuestionsRequest {
  _UserQuestionsRequest(this.page);

  final int page;
  final Completer<QuestionsPage> completer = Completer<QuestionsPage>();
}

class _ControlledUserQuestionsRepository implements UserQuestionsRepository {
  final List<_UserQuestionsRequest> requests = [];

  @override
  Future<QuestionsPage> getMyQuestions({int page = 1, int perPage = 15}) {
    final request = _UserQuestionsRequest(page);
    requests.add(request);
    return request.completer.future;
  }
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _authentication = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authentication.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    setAccount('user-a');
  }

  void setAccount(String accountId) {
    state = AuthState(
      status: AuthStatus.authenticated,
      user: HbUser(
        id: accountId,
        email: '$accountId@example.test',
        displayName: accountId,
      ),
    );
  }
}
