import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/event_social_api_datasource.dart';
import '../../data/models/event_review_dto.dart';
import '../../data/models/event_question_dto.dart';

// ============ REVIEWS PROVIDERS ============

/// Provider pour récupérer les avis d'un événement
final eventReviewsProvider = FutureProvider.autoDispose
    .family<EventReviewsResponseDto, EventReviewsParams>((ref, params) async {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return dataSource.getEventReviews(
    params.eventSlug,
    page: params.page,
    perPage: params.perPage,
    rating: params.rating,
    verifiedOnly: params.verifiedOnly,
    featuredOnly: params.featuredOnly,
    sortBy: params.sortBy,
    sortOrder: params.sortOrder,
  );
});

/// Provider pour récupérer les statistiques des avis
final eventReviewStatsProvider = FutureProvider.autoDispose
    .family<ReviewStatsDto, String>((ref, eventSlug) async {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return dataSource.getEventReviewStats(eventSlug);
});

/// Provider pour vérifier si l'utilisateur peut laisser un avis
final canReviewProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, eventSlug) async {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return dataSource.canReview(eventSlug);
});

// ============ QUESTIONS PROVIDERS ============

/// Provider pour récupérer les questions d'un événement
final eventQuestionsProvider = FutureProvider.autoDispose
    .family<EventQuestionsResponseDto, EventQuestionsParams>((ref, params) async {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return dataSource.getEventQuestions(
    params.eventSlug,
    page: params.page,
    perPage: params.perPage,
    answeredOnly: params.answeredOnly,
    unansweredOnly: params.unansweredOnly,
  );
});

/// Provider pour récupérer la question de l'utilisateur connecté
final myQuestionProvider = FutureProvider.autoDispose
    .family<EventQuestionDto?, String>((ref, eventSlug) async {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return dataSource.getMyQuestion(eventSlug);
});

// ============ PARAMETER CLASSES ============

/// Paramètres pour la requête des avis
class EventReviewsParams {
  final String eventSlug;
  final int page;
  final int perPage;
  final int? rating;
  final bool verifiedOnly;
  final bool featuredOnly;
  final String sortBy;
  final String sortOrder;

  const EventReviewsParams({
    required this.eventSlug,
    this.page = 1,
    this.perPage = 15,
    this.rating,
    this.verifiedOnly = false,
    this.featuredOnly = false,
    this.sortBy = 'created_at',
    this.sortOrder = 'desc',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventReviewsParams &&
          runtimeType == other.runtimeType &&
          eventSlug == other.eventSlug &&
          page == other.page &&
          perPage == other.perPage &&
          rating == other.rating &&
          verifiedOnly == other.verifiedOnly &&
          featuredOnly == other.featuredOnly &&
          sortBy == other.sortBy &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      eventSlug.hashCode ^
      page.hashCode ^
      perPage.hashCode ^
      rating.hashCode ^
      verifiedOnly.hashCode ^
      featuredOnly.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode;
}

/// Paramètres pour la requête des questions
class EventQuestionsParams {
  final String eventSlug;
  final int page;
  final int perPage;
  final bool answeredOnly;
  final bool unansweredOnly;

  const EventQuestionsParams({
    required this.eventSlug,
    this.page = 1,
    this.perPage = 15,
    this.answeredOnly = false,
    this.unansweredOnly = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventQuestionsParams &&
          runtimeType == other.runtimeType &&
          eventSlug == other.eventSlug &&
          page == other.page &&
          perPage == other.perPage &&
          answeredOnly == other.answeredOnly &&
          unansweredOnly == other.unansweredOnly;

  @override
  int get hashCode =>
      eventSlug.hashCode ^
      page.hashCode ^
      perPage.hashCode ^
      answeredOnly.hashCode ^
      unansweredOnly.hashCode;
}

// ============ NOTIFIERS POUR LES ACTIONS ============

/// Notifier pour gérer les actions sur les avis (création, votes)
class EventReviewsNotifier extends StateNotifier<AsyncValue<void>> {
  final EventSocialApiDataSource _dataSource;
  final Ref _ref;

  EventReviewsNotifier(this._dataSource, this._ref) : super(const AsyncValue.data(null));

  /// Créer un nouvel avis
  Future<EventReviewDto?> createReview({
    required String eventSlug,
    required int rating,
    String? title,
    required String comment,
  }) async {
    state = const AsyncValue.loading();
    try {
      final review = await _dataSource.createReview(
        eventSlug,
        rating: rating,
        title: title,
        comment: comment,
      );
      state = const AsyncValue.data(null);
      // Invalider les caches pour recharger les données
      _ref.invalidate(eventReviewsProvider);
      _ref.invalidate(eventReviewStatsProvider);
      _ref.invalidate(canReviewProvider);
      return review;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Voter sur un avis (utile/pas utile)
  Future<bool> voteReview(String reviewUuid, {required bool isHelpful}) async {
    try {
      await _dataSource.voteReview(reviewUuid, isHelpful: isHelpful);
      _ref.invalidate(eventReviewsProvider);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retirer le vote sur un avis
  Future<bool> unvoteReview(String reviewUuid) async {
    try {
      await _dataSource.unvoteReview(reviewUuid);
      _ref.invalidate(eventReviewsProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Provider pour le notifier des actions reviews
final eventReviewsNotifierProvider =
    StateNotifierProvider.autoDispose<EventReviewsNotifier, AsyncValue<void>>((ref) {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return EventReviewsNotifier(dataSource, ref);
});

/// Notifier pour gérer les actions sur les questions (création, votes)
class EventQuestionsNotifier extends StateNotifier<AsyncValue<void>> {
  final EventSocialApiDataSource _dataSource;
  final Ref _ref;

  EventQuestionsNotifier(this._dataSource, this._ref) : super(const AsyncValue.data(null));

  /// Poser une nouvelle question
  Future<EventQuestionDto?> createQuestion({
    required String eventSlug,
    required String question,
    String? guestName,
    String? guestEmail,
  }) async {
    state = const AsyncValue.loading();
    try {
      final q = await _dataSource.createQuestion(
        eventSlug,
        question: question,
        guestName: guestName,
        guestEmail: guestEmail,
      );
      state = const AsyncValue.data(null);
      _ref.invalidate(eventQuestionsProvider);
      _ref.invalidate(myQuestionProvider);
      return q;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Marquer une question comme utile
  Future<bool> markHelpful(String questionUuid) async {
    try {
      await _dataSource.markQuestionHelpful(questionUuid);
      _ref.invalidate(eventQuestionsProvider);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retirer le vote utile
  Future<bool> unmarkHelpful(String questionUuid) async {
    try {
      await _dataSource.unmarkQuestionHelpful(questionUuid);
      _ref.invalidate(eventQuestionsProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Provider pour le notifier des actions questions
final eventQuestionsNotifierProvider =
    StateNotifierProvider.autoDispose<EventQuestionsNotifier, AsyncValue<void>>((ref) {
  final dataSource = ref.watch(eventSocialApiDataSourceProvider);
  return EventQuestionsNotifier(dataSource, ref);
});
