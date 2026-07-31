import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/conversation_dto.dart';
import '../../domain/repositories/petit_boo_repository.dart';

enum ConversationListError {
  authRequired,
  loadFailed,
}

/// State for the conversations list
class ConversationListState {
  static const Object _loadMoreErrorUnset = Object();

  final List<ConversationDto> conversations;
  final bool isLoading;
  final bool isLoadingMore;
  final ConversationListError? error;
  final ConversationListError? loadMoreError;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const ConversationListState({
    this.conversations = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  ConversationListState copyWith({
    List<ConversationDto>? conversations,
    bool? isLoading,
    bool? isLoadingMore,
    ConversationListError? error,
    Object? loadMoreError = _loadMoreErrorUnset,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return ConversationListState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      loadMoreError: identical(loadMoreError, _loadMoreErrorUnset)
          ? this.loadMoreError
          : loadMoreError as ConversationListError?,
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
    final ownerSession = ref.watch(authSessionKeyProvider);
    final accountId = ref.watch(authSessionUserIdProvider);
    final repository =
        accountId == null ? null : ref.watch(petitBooRepositoryProvider);
    return ConversationListNotifier(
      repository,
      ref,
      accountId: accountId,
      ownerSession: ownerSession,
    );
  },
);

/// StateNotifier for managing the list of conversations
class ConversationListNotifier extends StateNotifier<ConversationListState> {
  final PetitBooRepository? _repository;
  final Ref _ref;
  final String? _accountId;
  final AuthSessionKey _ownerSession;
  int _listRequestGeneration = 0;

  ConversationListNotifier(
    this._repository,
    this._ref, {
    required String? accountId,
    required AuthSessionKey ownerSession,
  })  : _accountId = accountId,
        _ownerSession = ownerSession,
        super(const ConversationListState()) {
    if (_isCurrentAccount) {
      loadConversations();
    }
  }

  bool get _isCurrentAccount =>
      mounted &&
      _accountId != null &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession) &&
      _ref.read(authSessionUserIdProvider) == _accountId;

  bool _isCurrentListRequest(int generation) =>
      _isCurrentAccount && generation == _listRequestGeneration;

  /// Load conversations (first page)
  Future<void> loadConversations() async {
    final repository = _repository;
    if (!_isCurrentAccount || repository == null) return;

    // A refresh supersedes any older first-page or pagination response. This
    // also makes repeated pull-to-refresh requests last-request-wins.
    final generation = ++_listRequestGeneration;

    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      error: null,
      loadMoreError: null,
      currentPage: 1,
      hasMore: false,
    );

    try {
      if (kDebugMode) {
        debugPrint('🦉 ConversationList: Fetching conversations...');
      }

      final result = await repository.getConversations(
        page: 1,
        perPage: 20,
      );

      if (!_isCurrentListRequest(generation)) return;

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
      if (!_isCurrentListRequest(generation)) return;

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
    final repository = _repository;
    if (!_isCurrentAccount ||
        repository == null ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore ||
        state.loadMoreError != null) {
      return;
    }

    final generation = ++_listRequestGeneration;
    final nextPage = state.currentPage + 1;
    final existingConversations = state.conversations;
    state = state.copyWith(isLoadingMore: true, loadMoreError: null);

    try {
      final result = await repository.getConversations(
        page: nextPage,
        perPage: 20,
      );

      if (!_isCurrentListRequest(generation)) return;

      state = state.copyWith(
        conversations: [...existingConversations, ...result.conversations],
        isLoadingMore: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasMore: result.hasNext,
        loadMoreError: null,
      );
    } catch (e) {
      if (!_isCurrentListRequest(generation)) return;

      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: _getError(e),
      );
    }
  }

  Future<void> retryLoadMore() async {
    if (!_isCurrentAccount || state.loadMoreError == null) return;
    state = state.copyWith(loadMoreError: null);
    await loadMore();
  }

  /// Refresh the conversations list
  Future<void> refresh() async {
    await loadConversations();
  }

  /// Delete a conversation
  Future<void> deleteConversation(String uuid) async {
    final repository = _repository;
    if (!_isCurrentAccount || repository == null) return;

    try {
      await repository.deleteConversation(uuid);

      if (!_isCurrentAccount) return;

      // Remove from local list
      state = state.copyWith(
        conversations:
            state.conversations.where((c) => c.uuid != uuid).toList(),
      );
    } catch (error, stackTrace) {
      if (!_isCurrentAccount) return;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Clear error
  void clearError() {
    if (!_isCurrentAccount) return;
    state = state.copyWith(error: null);
  }

  ConversationListError _getError(dynamic error) {
    if (error.toString().contains('401')) {
      return ConversationListError.authRequired;
    }
    return ConversationListError.loadFailed;
  }
}

class ConversationHistoryAuthenticationRequiredException implements Exception {
  const ConversationHistoryAuthenticationRequiredException();
}

class ConversationHistoryAccountChangedException implements Exception {
  const ConversationHistoryAccountChangedException();
}

typedef _ConversationDetailKey = ({AuthSessionKey ownerSession, String uuid});

final _accountConversationDetailProvider = FutureProvider.autoDispose
    .family<ConversationDto, _ConversationDetailKey>((ref, key) async {
  if (key.ownerSession.accountId == null ||
      !identical(ref.watch(authSessionKeyProvider), key.ownerSession)) {
    throw const ConversationHistoryAccountChangedException();
  }
  final repository = ref.watch(petitBooRepositoryProvider);
  var isActive = true;
  ref.onDispose(() => isActive = false);

  final conversation = await repository.getConversation(key.uuid);
  if (!isActive ||
      !identical(ref.read(authSessionKeyProvider), key.ownerSession)) {
    throw const ConversationHistoryAccountChangedException();
  }
  return conversation;
});

/// Provider for a single conversation detail.
///
/// The actual request is keyed by both UUID and account. The synchronous
/// wrapper is important: a [FutureProvider] reload can retain its previous
/// value, which would briefly expose the old account's conversation after a
/// logout or account switch.
final conversationDetailProvider = Provider.autoDispose
    .family<AsyncValue<ConversationDto>, String>((ref, uuid) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  if (ownerSession.accountId == null) {
    return AsyncError(
      const ConversationHistoryAuthenticationRequiredException(),
      StackTrace.current,
    );
  }

  return ref.watch(
    _accountConversationDetailProvider(
      (ownerSession: ownerSession, uuid: uuid),
    ),
  );
});
