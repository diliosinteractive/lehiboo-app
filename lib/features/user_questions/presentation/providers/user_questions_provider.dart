import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../../events/domain/entities/event_question.dart';
import '../../data/repositories/user_questions_repository_impl.dart';
import '../../domain/repositories/user_questions_repository.dart';

const int kUserQuestionsPageSize = 15;

class UserQuestionsListController
    extends StateNotifier<AsyncValue<QuestionsPage>> {
  UserQuestionsListController(
    this._repo,
    this._ref, {
    required String? accountId,
    AuthSessionKey? ownerSession,
  })  : _accountId = accountId,
        _ownerSession = ownerSession,
        super(
          accountId == null
              ? const AsyncValue.data(QuestionsPage())
              : const AsyncValue.loading(),
        ) {
    if (accountId != null) unawaited(_loadFirstPage());
  }

  final UserQuestionsRepository _repo;
  final Ref _ref;
  final String? _accountId;
  final AuthSessionKey? _ownerSession;
  int _requestGeneration = 0;

  bool get _ownsActiveSession =>
      mounted &&
      _accountId != null &&
      (_ownerSession != null
          ? identical(_ref.read(authSessionKeyProvider), _ownerSession)
          : _ref.read(authSessionUserIdProvider) == _accountId);

  Future<void> _loadFirstPage() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsActiveSession) return;
    state = const AsyncValue.loading();
    try {
      final page = await _repo.getMyQuestions(
        page: 1,
        perPage: kUserQuestionsPageSize,
      );
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(page);
    } catch (e, st) {
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _loadFirstPage();

  Future<void> loadMore() async {
    if (!_ownsActiveSession) return;
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.loadMoreError != null) {
      return;
    }

    final requestGeneration = ++_requestGeneration;
    state = AsyncValue.data(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );
    try {
      final next = await _repo.getMyQuestions(
        page: current.currentPage + 1,
        perPage: kUserQuestionsPageSize,
      );
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(
        current.copyWith(
          items: [...current.items, ...next.items],
          currentPage: next.currentPage,
          lastPage: next.lastPage,
          total: next.total,
          isLoadingMore: false,
          loadMoreError: null,
        ),
      );
    } catch (error) {
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      // Preserve the questions already loaded while notifying the UI so the
      // pagination error and its retry action can be displayed.
      state = AsyncValue.data(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<void> retryLoadMore() async {
    if (!_ownsActiveSession) return;
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(loadMoreError: null));
    await loadMore();
  }
}

final userQuestionsListControllerProvider = StateNotifierProvider.autoDispose<
    UserQuestionsListController, AsyncValue<QuestionsPage>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final accountId = ref.watch(authSessionUserIdProvider);
  final repo = ref.watch(userQuestionsRepositoryProvider);
  return UserQuestionsListController(
    repo,
    ref,
    accountId: accountId,
    ownerSession: ownerSession,
  );
});
