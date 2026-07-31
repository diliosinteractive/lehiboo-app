import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reviews/data/models/review_dto.dart';
import '../../domain/repositories/organizer_repository.dart';

/// Aggregate stats for the histogram at the top of the reviews tab —
/// spec §6quater. Cheap one-shot fetch keyed by organizer identifier.
final organizerReviewsStatsFutureProvider =
    FutureProvider.family<ReviewStatsDto, String>(
  (ref, identifier) async {
    return ref.watch(organizerRepositoryProvider).getReviewsStats(identifier);
  },
);

/// State for the paginated reviews list — spec §6ter.
class OrganizerReviewsState {
  final List<ReviewDto> items;
  final int page;
  final int lastPage;
  final bool isLoadingMore;
  final bool hasLoadMoreError;

  const OrganizerReviewsState({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.isLoadingMore,
    this.hasLoadMoreError = false,
  });

  bool get hasMore => page < lastPage;

  OrganizerReviewsState copyWith({
    List<ReviewDto>? items,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) =>
      OrganizerReviewsState(
        items: items ?? this.items,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
      );
}

class OrganizerReviewsController
    extends FamilyAsyncNotifier<OrganizerReviewsState, String> {
  static const _perPage = 20;

  @override
  Future<OrganizerReviewsState> build(String identifier) async {
    final response = await ref
        .watch(organizerRepositoryProvider)
        .getReviews(identifier, page: 1, perPage: _perPage);
    return _stateFromResponse(response, fallbackPage: 1);
  }

  Future<void> loadMore() => _loadMore();

  Future<void> retryLoadMore() => _loadMore(allowAfterError: true);

  Future<void> _loadMore({bool allowAfterError = false}) async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        (current.hasLoadMoreError && !allowAfterError)) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, hasLoadMoreError: false),
    );

    try {
      final response = await ref
          .read(organizerRepositoryProvider)
          .getReviews(arg, page: current.page + 1, perPage: _perPage);
      final next = _stateFromResponse(response, fallbackPage: current.page + 1);
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          page: next.page,
          lastPage: next.lastPage,
          isLoadingMore: false,
          hasLoadMoreError: false,
        ),
      );
    } catch (e, st) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, hasLoadMoreError: true),
      );
      if (kDebugMode) {
        debugPrint('OrganizerReviewsController.loadMore failed: $e\n$st');
      }
    }
  }

  OrganizerReviewsState _stateFromResponse(
    ReviewsResponseDto response, {
    required int fallbackPage,
  }) {
    // Spec §6ter.4 note: this endpoint uses `meta.current_page` (Laravel's
    // verbose paginator). PaginationMetaDto already maps that correctly.
    final meta = response.meta;
    return OrganizerReviewsState(
      items: response.data,
      page: meta?.currentPage ?? fallbackPage,
      lastPage: meta?.lastPage ?? 1,
      isLoadingMore: false,
      hasLoadMoreError: false,
    );
  }
}

final organizerReviewsControllerProvider = AsyncNotifierProvider.family<
    OrganizerReviewsController, OrganizerReviewsState, String>(
  OrganizerReviewsController.new,
);
