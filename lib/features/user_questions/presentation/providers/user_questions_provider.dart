import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/domain/entities/event_question.dart';
import '../../data/repositories/user_questions_repository_impl.dart';
import '../../domain/repositories/user_questions_repository.dart';

const int kUserQuestionsPageSize = 15;

class UserQuestionsListController
    extends StateNotifier<AsyncValue<QuestionsPage>> {
  final UserQuestionsRepository _repo;

  UserQuestionsListController(this._repo) : super(const AsyncValue.loading()) {
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    state = const AsyncValue.loading();
    try {
      final page = await _repo.getMyQuestions(
        page: 1,
        perPage: kUserQuestionsPageSize,
      );
      state = AsyncValue.data(page);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final page = await _repo.getMyQuestions(
        page: 1,
        perPage: kUserQuestionsPageSize,
      );
      state = AsyncValue.data(page);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.loadMoreError != null) {
      return;
    }

    state = AsyncValue.data(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );
    try {
      final next = await _repo.getMyQuestions(
        page: current.currentPage + 1,
        perPage: kUserQuestionsPageSize,
      );
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
      // Preserve the questions already loaded while notifying the UI so the
      // pagination error and its retry action can be displayed.
      state = AsyncValue.data(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<void> retryLoadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(loadMoreError: null));
    await loadMore();
  }
}

final userQuestionsListControllerProvider = StateNotifierProvider.autoDispose<
    UserQuestionsListController, AsyncValue<QuestionsPage>>((ref) {
  final repo = ref.watch(userQuestionsRepositoryProvider);
  return UserQuestionsListController(repo);
});
