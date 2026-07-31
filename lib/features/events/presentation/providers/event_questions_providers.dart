import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/datasources/event_social_api_datasource.dart';
import '../../data/repositories/event_questions_repository_impl.dart';
import '../../domain/entities/event_question.dart';
import '../../domain/repositories/event_questions_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

final eventQuestionsRepositoryProvider = Provider<EventQuestionsRepository>((
  ref,
) {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return EventQuestionsRepositoryImpl(dataSource);
});

// ─────────────────────────────────────────────────────────────────────────────
// Preview (event detail screen) — page 1, 5 items
// ─────────────────────────────────────────────────────────────────────────────

const int kQuestionsPreviewSize = 5;

/// Account-neutral snapshots retained across auth transitions. Every question
/// is sanitized before caching so another account can never inherit
/// `userVoted`, while the public Q&A content remains available during reload.
final _questionsPreviewPublicCacheProvider =
    StateProvider.family<QuestionsPage?, String>((ref, eventSlug) => null);

final _questionsListPublicCacheProvider =
    StateProvider.family<QuestionsPage?, String>((ref, eventSlug) => null);

final eventQuestionsPreviewProvider = StateNotifierProvider.autoDispose
    .family<EventQuestionsPreviewController, AsyncValue<QuestionsPage>, String>(
  (ref, eventSlug) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    final repo = ref.watch(eventQuestionsRepositoryProvider);
    return EventQuestionsPreviewController(
      repo,
      ref,
      eventSlug: eventSlug,
      ownerSession: ownerSession,
      publicSnapshot: ref.read(
        _questionsPreviewPublicCacheProvider(eventSlug),
      ),
    );
  },
);

class EventQuestionsPreviewController
    extends StateNotifier<AsyncValue<QuestionsPage>> {
  EventQuestionsPreviewController(
    this._repo,
    this._ref, {
    required String eventSlug,
    required AuthSessionKey ownerSession,
    required QuestionsPage? publicSnapshot,
  })  : _eventSlug = eventSlug,
        _ownerSession = ownerSession,
        super(_loadingWithPublicSnapshot(publicSnapshot)) {
    unawaited(_load());
  }

  final EventQuestionsRepository _repo;
  final Ref _ref;
  final String _eventSlug;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;

  bool get _ownsSessionContext =>
      mounted && identical(_ref.read(authSessionKeyProvider), _ownerSession);

  Future<void> _load() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsSessionContext) return;

    state = _loadingWithPublicSnapshot(state.valueOrNull);
    try {
      final page = await _repo.getQuestions(
        _eventSlug,
        page: 1,
        perPage: kQuestionsPreviewSize,
      );
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      _ref
          .read(_questionsPreviewPublicCacheProvider(_eventSlug).notifier)
          .state = _withoutPersonalizedVotes(page);
      state = AsyncValue.data(page);
    } catch (error, stackTrace) {
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();
}

// ─────────────────────────────────────────────────────────────────────────────
// My question (spec §5.2)
// ─────────────────────────────────────────────────────────────────────────────

final myQuestionProvider = StateNotifierProvider.autoDispose
    .family<MyQuestionController, AsyncValue<EventQuestion?>, String>(
  (ref, eventSlug) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    final repo = ref.watch(eventQuestionsRepositoryProvider);
    return MyQuestionController(
      repo,
      ref,
      eventSlug: eventSlug,
      ownerSession: ownerSession,
    );
  },
);

class MyQuestionController extends StateNotifier<AsyncValue<EventQuestion?>> {
  MyQuestionController(
    this._repo,
    this._ref, {
    required String eventSlug,
    required AuthSessionKey ownerSession,
  })  : _eventSlug = eventSlug,
        _ownerSession = ownerSession,
        super(
          ownerSession.accountId == null
              ? const AsyncValue.data(null)
              : const AsyncValue.loading(),
        ) {
    if (ownerSession.accountId != null) unawaited(_load());
  }

  final EventQuestionsRepository _repo;
  final Ref _ref;
  final String _eventSlug;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;

  bool get _ownsActiveSession =>
      mounted &&
      _ownerSession.accountId != null &&
      identical(_ref.read(authSessionKeyProvider), _ownerSession);

  Future<void> _load() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsActiveSession) return;

    state = const AsyncValue.loading();
    try {
      final question = await _repo.getMyQuestion(_eventSlug);
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(question);
    } catch (error, stackTrace) {
      if (!_ownsActiveSession || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();
}

// ─────────────────────────────────────────────────────────────────────────────
// List controller (dedicated full screen) — pagination + refresh
// ─────────────────────────────────────────────────────────────────────────────

const int kQuestionsPageSize = 10;

class EventQuestionsListController
    extends StateNotifier<AsyncValue<QuestionsPage>> {
  final EventQuestionsRepository _repo;
  final Ref _ref;
  final String _eventSlug;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;

  EventQuestionsListController(
    this._repo,
    this._ref,
    this._eventSlug, {
    required AuthSessionKey ownerSession,
    required QuestionsPage? publicSnapshot,
  })  : _ownerSession = ownerSession,
        super(_loadingWithPublicSnapshot(publicSnapshot)) {
    unawaited(_loadFirstPage());
  }

  bool get _ownsSessionContext =>
      mounted && identical(_ref.read(authSessionKeyProvider), _ownerSession);

  Future<void> _loadFirstPage() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsSessionContext) return;
    state = _loadingWithPublicSnapshot(state.valueOrNull);
    try {
      final page = await _repo.getQuestions(
        _eventSlug,
        page: 1,
        perPage: kQuestionsPageSize,
      );
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      _cachePublicPage(page);
      state = AsyncValue.data(page);
    } catch (e, st) {
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadFirstPage();
  }

  Future<void> loadMore() async {
    if (!_ownsSessionContext) return;
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
      final next = await _repo.getQuestions(
        _eventSlug,
        page: current.currentPage + 1,
        perPage: kQuestionsPageSize,
      );
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      final combined = current.copyWith(
        items: [...current.items, ...next.items],
        currentPage: next.currentPage,
        lastPage: next.lastPage,
        total: next.total,
        isLoadingMore: false,
        loadMoreError: null,
      );
      _cachePublicPage(combined);
      state = AsyncValue.data(combined);
    } catch (error) {
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<void> retryLoadMore() async {
    if (!_ownsSessionContext) return;
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore) return;
    state = AsyncValue.data(current.copyWith(loadMoreError: null));
    await loadMore();
  }

  /// Mutation locale (appelée par l'actions controller après un toggle).
  void applyVoteUpdate(
    String uuid,
    int helpfulCount,
    bool userVoted, {
    bool cachePublicSnapshot = true,
  }) {
    if (!_ownsSessionContext) return;
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.items
        .map((q) => q.uuid == uuid
            ? q.copyWith(helpfulCount: helpfulCount, userVoted: userVoted)
            : q)
        .toList(growable: false);

    final next = current.copyWith(items: updated);
    if (cachePublicSnapshot) _cachePublicPage(next);
    state = AsyncValue.data(next);
  }

  void _cachePublicPage(QuestionsPage page) {
    if (!_ownsSessionContext) return;
    _ref.read(_questionsListPublicCacheProvider(_eventSlug).notifier).state =
        _withoutPersonalizedVotes(page);
  }
}

final eventQuestionsListControllerProvider = StateNotifierProvider.autoDispose
    .family<EventQuestionsListController, AsyncValue<QuestionsPage>, String>((
  ref,
  eventSlug,
) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repo = ref.watch(eventQuestionsRepositoryProvider);
  return EventQuestionsListController(
    repo,
    ref,
    eventSlug,
    ownerSession: ownerSession,
    publicSnapshot: ref.read(_questionsListPublicCacheProvider(eventSlug)),
  );
});

AsyncValue<QuestionsPage> _loadingWithPublicSnapshot(
  QuestionsPage? publicSnapshot,
) {
  if (publicSnapshot == null) return const AsyncValue.loading();
  return const AsyncLoading<QuestionsPage>().copyWithPrevious(
    AsyncValue.data(_withoutPersonalizedVotes(publicSnapshot)),
    isRefresh: false,
  );
}

QuestionsPage _withoutPersonalizedVotes(QuestionsPage page) => page.copyWith(
      items: page.items
          .map((question) => question.copyWith(userVoted: false))
          .toList(growable: false),
      isLoadingMore: false,
      loadMoreError: null,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Actions controller (create + toggle helpful, optimistic UI)
// ─────────────────────────────────────────────────────────────────────────────

/// Résultat typé de `createQuestion` pour que l'UI puisse afficher les messages
/// appropriés sans exposer les exceptions.
sealed class CreateQuestionResult {
  const CreateQuestionResult();
}

class CreateQuestionSuccess extends CreateQuestionResult {
  final EventQuestion question;
  const CreateQuestionSuccess(this.question);
}

class CreateQuestionValidationFailure extends CreateQuestionResult {
  final String errorMessage;
  const CreateQuestionValidationFailure(this.errorMessage);
}

class CreateQuestionAlreadyExists extends CreateQuestionResult {
  const CreateQuestionAlreadyExists();
}

class CreateQuestionFailure extends CreateQuestionResult {
  final String errorMessage;
  const CreateQuestionFailure(this.errorMessage);
}

class EventQuestionsActionsController extends StateNotifier<AsyncValue<void>> {
  final EventQuestionsRepository _repo;
  final Ref _ref;
  final AuthSessionKey _ownerSession;
  final Set<String> _inFlightVotes = <String>{};

  EventQuestionsActionsController(
    this._repo,
    this._ref, {
    required AuthSessionKey ownerSession,
  })  : _ownerSession = ownerSession,
        super(const AsyncValue.data(null));

  bool get _ownsSessionContext =>
      mounted && identical(_ref.read(authSessionKeyProvider), _ownerSession);

  bool get _ownsActiveSession =>
      _ownerSession.accountId != null && _ownsSessionContext;

  Future<CreateQuestionResult> createQuestion({
    required String eventSlug,
    required String text,
  }) async {
    final trimmed = text.trim();
    final l10n = cachedAppLocalizations();
    if (trimmed.length < 10) {
      return CreateQuestionValidationFailure(l10n.eventQuestionMinLength);
    }
    if (trimmed.length > 1000) {
      return CreateQuestionValidationFailure(l10n.eventQuestionTooLong);
    }
    if (!_ownsActiveSession) {
      return CreateQuestionFailure(l10n.eventQuestionSubmitFailed);
    }

    state = const AsyncValue.loading();
    try {
      final question = await _repo.createQuestion(eventSlug, trimmed);
      if (!_ownsActiveSession) {
        return CreateQuestionFailure(l10n.eventQuestionSubmitFailed);
      }
      state = const AsyncValue.data(null);
      debugPrint('[QA] createQuestion OK → uuid=${question.uuid}');
      // On n'invalide PAS ici — c'est le parent qui déclenche le refresh
      // APRÈS la fermeture du sheet, pour que le loader soit bien visible
      // dans la section Q&A.
      return CreateQuestionSuccess(question);
    } on DuplicateQuestionException {
      if (!_ownsActiveSession) {
        return CreateQuestionFailure(l10n.eventQuestionSubmitFailed);
      }
      state = const AsyncValue.data(null);
      debugPrint('[QA] createQuestion → already exists');
      return const CreateQuestionAlreadyExists();
    } on QuestionValidationException catch (e) {
      if (!_ownsActiveSession) {
        return CreateQuestionFailure(l10n.eventQuestionSubmitFailed);
      }
      state = const AsyncValue.data(null);
      final errorMessage =
          e.errors.isNotEmpty ? e.errors.first : l10n.eventQuestionInvalid;
      debugPrint('[QA] createQuestion validation: $errorMessage');
      return CreateQuestionValidationFailure(errorMessage);
    } catch (e, st) {
      if (!_ownsActiveSession) {
        return CreateQuestionFailure(l10n.eventQuestionSubmitFailed);
      }
      state = AsyncValue.error(e, st);
      debugPrint('[QA] createQuestion FAILED: $e');
      return CreateQuestionFailure(
        ApiResponseHandler.extractError(
          e,
          fallback: l10n.eventQuestionSubmitFailed,
        ),
      );
    }
  }

  /// Refresh de toutes les vues Q&A d'un event. À appeler après une
  /// soumission réussie, ou manuellement via un pull-to-refresh.
  ///
  /// `invalidate` recreates each account-scoped controller, which starts a
  /// fresh request without allowing an older controller to publish into it.
  void refreshAll(String eventSlug) {
    if (!_ownsSessionContext) return;
    _ref.invalidate(myQuestionProvider(eventSlug));
    _ref.invalidate(eventQuestionsPreviewProvider(eventSlug));
    _ref.invalidate(eventQuestionsListControllerProvider(eventSlug));
  }

  /// Toggle optimiste (spec §5.3).
  ///
  /// Si [listController] est fourni, il sera mis à jour localement pour refléter
  /// l'état optimiste puis corrigé avec la valeur serveur. Sinon, la preview
  /// sera invalidée après succès.
  Future<bool> toggleHelpful({
    required String eventSlug,
    required EventQuestion question,
    EventQuestionsListController? listController,
  }) async {
    if (!_ownsActiveSession) return false;
    // A second tap while the same vote is already syncing is not a failure;
    // silently coalesce it instead of showing a misleading error toast.
    if (_inFlightVotes.contains(question.uuid)) return true;

    final wasVoted = question.userVoted;
    final oldCount = question.helpfulCount;
    final optimisticCount =
        wasVoted ? (oldCount - 1).clamp(0, 1 << 31) : oldCount + 1;
    final optimisticVoted = !wasVoted;

    listController?.applyVoteUpdate(
      question.uuid,
      optimisticCount,
      optimisticVoted,
      cachePublicSnapshot: false,
    );

    _inFlightVotes.add(question.uuid);
    try {
      final serverCount = wasVoted
          ? await _repo.unmarkHelpful(question.uuid)
          : await _repo.markHelpful(question.uuid);
      if (!_ownsActiveSession) return false;
      listController?.applyVoteUpdate(
        question.uuid,
        serverCount,
        optimisticVoted,
      );
      if (listController == null) {
        _ref.invalidate(eventQuestionsPreviewProvider(eventSlug));
      }
      return true;
    } on HelpfulVoteException catch (e) {
      if (!_ownsActiveSession) return false;
      // Désync avec serveur : si le count serveur est fourni, on l'utilise.
      // Sinon on rollback à l'état initial.
      if (e.serverCount != null) {
        listController?.applyVoteUpdate(
          question.uuid,
          e.serverCount!,
          !wasVoted, // Le serveur a accepté le nouvel état, on le garde
        );
        if (listController == null) {
          _ref.invalidate(eventQuestionsPreviewProvider(eventSlug));
        }
        return true;
      }
      listController?.applyVoteUpdate(question.uuid, oldCount, wasVoted);
      return false;
    } catch (_) {
      if (!_ownsActiveSession) return false;
      listController?.applyVoteUpdate(question.uuid, oldCount, wasVoted);
      return false;
    } finally {
      _inFlightVotes.remove(question.uuid);
    }
  }
}

/// Non-autoDispose: le controller est consommé via `ref.read(...)` depuis des
/// routes Navigator séparées (bottom sheet). Un `autoDispose` le détruirait
/// pendant les `await` API car aucun widget ne le watch → crash.
final eventQuestionsActionsProvider =
    StateNotifierProvider<EventQuestionsActionsController, AsyncValue<void>>((
  ref,
) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final repo = ref.watch(eventQuestionsRepositoryProvider);
  return EventQuestionsActionsController(
    repo,
    ref,
    ownerSession: ownerSession,
  );
});
