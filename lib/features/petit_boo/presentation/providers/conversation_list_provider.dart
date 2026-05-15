import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/conversation_dto.dart';
import '../../domain/repositories/petit_boo_repository.dart';

enum ConversationListError {
  authRequired,
  loadFailed,
}

/// State for the conversations list
class ConversationListState {
  final List<ConversationDto> conversations;
  final bool isLoading;
  final bool isLoadingMore;
  final ConversationListError? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const ConversationListState({
    this.conversations = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  ConversationListState copyWith({
    List<ConversationDto>? conversations,
    bool? isLoading,
    bool? isLoadingMore,
    ConversationListError? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return ConversationListState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Provider for the conversation list state notifier
final conversationListProvider = StateNotifierProvider.autoDispose<
    ConversationListNotifier, ConversationListState>(
  (ref) {
    final repository = ref.watch(petitBooRepositoryProvider);
    return ConversationListNotifier(repository);
  },
);

/// StateNotifier for managing the list of conversations
class ConversationListNotifier extends StateNotifier<ConversationListState> {
  final PetitBooRepository _repository;

  ConversationListNotifier(this._repository)
      : super(const ConversationListState()) {
    loadConversations();
  }

  /// Load conversations (first page)
  Future<void> loadConversations() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      if (kDebugMode) {
        debugPrint('🦉 ConversationList: Fetching conversations...');
      }

      final result = await _repository.getConversations(
        page: 1,
        perPage: 20,
      );

      if (kDebugMode) {
        debugPrint(
            '🦉 ConversationList: Got ${result.conversations.length} conversations');
        debugPrint(
            '🦉 ConversationList: Page ${result.currentPage}/${result.totalPages}');
      }

      state = state.copyWith(
        conversations: result.conversations,
        isLoading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasMore: result.hasNext,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🦉 ConversationList: Error fetching conversations: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: _getError(e),
      );
    }
  }

  /// Load more conversations (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.getConversations(
        page: state.currentPage + 1,
        perPage: 20,
      );

      state = state.copyWith(
        conversations: [...state.conversations, ...result.conversations],
        isLoadingMore: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasMore: result.hasNext,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: _getError(e),
      );
    }
  }

  /// Refresh the conversations list
  Future<void> refresh() async {
    state = state.copyWith(
      currentPage: 1,
      hasMore: false,
    );
    await loadConversations();
  }

  /// Delete a conversation
  Future<bool> deleteConversation(String uuid) async {
    try {
      await _repository.deleteConversation(uuid);

      // Remove from local list
      state = state.copyWith(
        conversations:
            state.conversations.where((c) => c.uuid != uuid).toList(),
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: _getError(e));
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  ConversationListError _getError(dynamic error) {
    if (error.toString().contains('401')) {
      return ConversationListError.authRequired;
    }
    return ConversationListError.loadFailed;
  }
}

/// Provider for a single conversation detail
final conversationDetailProvider = FutureProvider.autoDispose
    .family<ConversationDto, String>((ref, uuid) async {
  final repository = ref.watch(petitBooRepositoryProvider);
  return repository.getConversation(uuid);
});
