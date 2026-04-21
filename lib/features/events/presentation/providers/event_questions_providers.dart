import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final eventQuestionsPreviewProvider = FutureProvider.autoDispose
    .family<QuestionsPage, String>((ref, eventSlug) async {
  final repo = ref.watch(eventQuestionsRepositoryProvider);
  return repo.getQuestions(eventSlug, page: 1, perPage: kQuestionsPreviewSize);
});

// ─────────────────────────────────────────────────────────────────────────────
// My question (spec §5.2)
// ─────────────────────────────────────────────────────────────────────────────

final myQuestionProvider = FutureProvider.autoDispose
    .family<EventQuestion?, String>((ref, eventSlug) async {
  final repo = ref.watch(eventQuestionsRepositoryProvider);
  return repo.getMyQuestion(eventSlug);
});

// ─────────────────────────────────────────────────────────────────────────────
// List controller (dedicated full screen) — pagination + refresh
// ─────────────────────────────────────────────────────────────────────────────

const int kQuestionsPageSize = 10;

class EventQuestionsListController
    extends StateNotifier<AsyncValue<QuestionsPage>> {
  final EventQuestionsRepository _repo;
  final String _eventSlug;

  EventQuestionsListController(this._repo, this._eventSlug)
      : super(const AsyncValue.loading()) {
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    state = const AsyncValue.loading();
    try {
      final page = await _repo.getQuestions(
        _eventSlug,
        page: 1,
        perPage: kQuestionsPageSize,
      );
      state = AsyncValue.data(page);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    try {
      final page = await _repo.getQuestions(
        _eventSlug,
        page: 1,
        perPage: kQuestionsPageSize,
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
      final next = await _repo.getQuestions(
        _eventSlug,
        page: current.currentPage + 1,
        perPage: kQuestionsPageSize,
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
      // Silent fail pour loadMore — on garde la page déjà affichée.
      // L'utilisateur peut retenter en scrollant de nouveau.
    } finally {
      _isLoadingMore = false;
    }
  }

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  /// Mutation locale (appelée par l'actions controller après un toggle).
  void applyVoteUpdate(String uuid, int helpfulCount, bool userVoted) {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.items
        .map((q) => q.uuid == uuid
            ? q.copyWith(helpfulCount: helpfulCount, userVoted: userVoted)
            : q)
        .toList(growable: false);

    state = AsyncValue.data(current.copyWith(items: updated));
  }
}

final eventQuestionsListControllerProvider = StateNotifierProvider.autoDispose
    .family<EventQuestionsListController, AsyncValue<QuestionsPage>, String>((
  ref,
  eventSlug,
) {
  final repo = ref.watch(eventQuestionsRepositoryProvider);
  return EventQuestionsListController(repo, eventSlug);
});

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
  final Set<String> _inFlightVotes = <String>{};

  EventQuestionsActionsController(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  Future<CreateQuestionResult> createQuestion({
    required String eventSlug,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.length < 10) {
      return const CreateQuestionValidationFailure(
        'Votre question doit contenir au moins 10 caractères.',
      );
    }
    if (trimmed.length > 1000) {
      return const CreateQuestionValidationFailure(
        'Votre question est trop longue (1000 caractères max).',
      );
    }

    state = const AsyncValue.loading();
    try {
      final question = await _repo.createQuestion(eventSlug, trimmed);
      state = const AsyncValue.data(null);

      // Refresh toutes les vues Q&A de cet événement (detail section + écran
      // dédié + bloc "Votre question"). La nouvelle question est `pending`,
      // donc elle n'apparaîtra pas dans la liste publique — mais `myQuestion`
      // la renverra et le CTA "Poser" sera masqué.
      _ref.invalidate(myQuestionProvider(eventSlug));
      _ref.invalidate(eventQuestionsPreviewProvider(eventSlug));
      _ref.invalidate(eventQuestionsListControllerProvider(eventSlug));

      return CreateQuestionSuccess(question);
    } on DuplicateQuestionException {
      state = const AsyncValue.data(null);
      _ref.invalidate(myQuestionProvider(eventSlug));
      return const CreateQuestionAlreadyExists();
    } on QuestionValidationException catch (e) {
      state = const AsyncValue.data(null);
      return CreateQuestionValidationFailure(e.firstError);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return const CreateQuestionFailure(
        'Une erreur est survenue lors de l\'envoi de la question.',
      );
    }
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
    if (_inFlightVotes.contains(question.uuid)) return false;

    final wasVoted = question.userVoted;
    final oldCount = question.helpfulCount;
    final optimisticCount =
        wasVoted ? (oldCount - 1).clamp(0, 1 << 31) : oldCount + 1;
    final optimisticVoted = !wasVoted;

    listController?.applyVoteUpdate(
      question.uuid,
      optimisticCount,
      optimisticVoted,
    );

    _inFlightVotes.add(question.uuid);
    try {
      final serverCount = wasVoted
          ? await _repo.unmarkHelpful(question.uuid)
          : await _repo.markHelpful(question.uuid);
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
      // Désync avec serveur : si le count serveur est fourni, on l'utilise.
      // Sinon on rollback à l'état initial.
      if (e.serverCount != null) {
        listController?.applyVoteUpdate(
          question.uuid,
          e.serverCount!,
          !wasVoted, // Le serveur a accepté le nouvel état, on le garde
        );
      } else {
        listController?.applyVoteUpdate(
          question.uuid,
          oldCount,
          wasVoted,
        );
      }
      return false;
    } catch (_) {
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
  final repo = ref.watch(eventQuestionsRepositoryProvider);
  return EventQuestionsActionsController(repo, ref);
});
