import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/domain/entities/event_question.dart';
import '../../data/repositories/user_questions_repository_impl.dart';
import '../../domain/repositories/user_questions_repository.dart';

const int kUserQuestionsPageSize = 15;

class UserQuestionsListController
    extends StateNotifier<AsyncValue<QuestionsPage>> {
  final UserQuestionsRepository _repo;

  UserQuestionsListController(this._repo)
      : super(const AsyncValue.loading()) {
    _loadFirstPage();
  }

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

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
    if (current == null || !current.hasMore) return;
    if (_isLoadingMore) return;

    _isLoadingMore = true;
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
        ),
      );
    } catch (_) {
      // Silent fail — l'utilisateur peut retenter en scrollant.
    } finally {
      _isLoadingMore = false;
    }
  }
}

final userQuestionsListControllerProvider = StateNotifierProvider.autoDispose<
    UserQuestionsListController, AsyncValue<QuestionsPage>>((ref) {
  final repo = ref.watch(userQuestionsRepositoryProvider);
  return UserQuestionsListController(repo);
});
