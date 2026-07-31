import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../core/widgets/feedback/hb_feedback.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review.dart';
// review_enums.dart fournit ReviewSortBy + CanReviewReason
import '../../domain/entities/review_enums.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/reviews_providers.dart';
import '../widgets/can_review_message.dart';
import '../widgets/event_reviews_section.dart';
import '../widgets/my_review_block.dart';
import '../widgets/report_review_sheet.dart';
import '../widgets/review_card.dart';
import '../widgets/write_review_sheet.dart';

/// Écran complet des avis d'un événement avec filtres et pagination.
class EventReviewsFullScreen extends ConsumerStatefulWidget {
  final String eventSlug;
  final String? eventTitle;

  const EventReviewsFullScreen({
    super.key,
    required this.eventSlug,
    this.eventTitle,
  });

  @override
  ConsumerState<EventReviewsFullScreen> createState() =>
      _EventReviewsFullScreenState();
}

class _EventReviewsFullScreenState
    extends ConsumerState<EventReviewsFullScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Review> _items = [];

  ReviewsQuery _query = const ReviewsQuery(perPage: 10);
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  String? _loadMoreError;
  final Set<String> _pendingVoteUuids = <String>{};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFirstPage();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _loadMoreError = null;
    });
    try {
      final repo = ref.read(reviewsRepositoryProvider);
      final page = await repo.getEventReviews(
        widget.eventSlug,
        query: _query.copyWith(page: 1),
      );
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.items);
        _query = _query.copyWith(page: page.meta.currentPage);
        _hasMore = page.meta.hasMore;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = context.l10n.organizerReviewsLoadError;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading || _loadMoreError != null) {
      return;
    }
    setState(() {
      _isLoadingMore = true;
      _loadMoreError = null;
    });
    try {
      final repo = ref.read(reviewsRepositoryProvider);
      final next = await repo.getEventReviews(
        widget.eventSlug,
        query: _query.copyWith(page: _query.page + 1),
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(next.items);
        _query = _query.copyWith(page: next.meta.currentPage);
        _hasMore = next.meta.hasMore;
        _isLoadingMore = false;
        _loadMoreError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = false;
        _loadMoreError = ApiResponseHandler.extractError(
          error,
          fallback: context.l10n.reviewsUserLoadMoreError,
        );
      });
    }
  }

  void _changeQuery(ReviewsQuery Function(ReviewsQuery) update) {
    setState(() => _query = update(_query.copyWith(page: 1)));
    _loadFirstPage();
  }

  Future<void> _handleWriteReview() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureWriteReview,
    );
    if (!allowed || !mounted) return;
    final created = await WriteReviewSheet.show(
      context,
      eventSlug: widget.eventSlug,
      eventTitle: widget.eventTitle ?? '',
    );
    if (created != null) _loadFirstPage();
  }

  Future<void> _handleReport(Review review) async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureReportReview,
    );
    if (!allowed || !mounted) return;
    await ReportReviewSheet.show(context, reviewUuid: review.uuid);
  }

  Future<void> _handleVote(String uuid, bool isHelpful) async {
    if (_pendingVoteUuids.contains(uuid)) return;

    final reviewIndex = _items.indexWhere((r) => r.uuid == uuid);
    if (reviewIndex == -1) return;

    final original = _items[reviewIndex];
    // ReviewCard intentionally locks an existing vote. Keep this guard at the
    // mutation boundary too, so stale/double callbacks cannot issue a second
    // request.
    if (original.userVote != null) return;

    setState(() {
      _pendingVoteUuids.add(uuid);
      _items[reviewIndex] = original.copyWith(
        helpfulCount: original.helpfulCount + (isHelpful ? 1 : 0),
        notHelpfulCount: original.notHelpfulCount + (isHelpful ? 0 : 1),
        userVote: isHelpful,
      );
    });

    final voteFailureFallback = context.l10n.reviewsVoteFailed;
    ReviewActionResult<VoteCounts> result;
    try {
      result = await ref.read(reviewsActionsProvider.notifier).voteReview(
            reviewUuid: uuid,
            isHelpful: isHelpful,
            eventSlug: widget.eventSlug,
          );
    } catch (error) {
      result = ReviewActionFailure(
        ApiResponseHandler.extractError(
          error,
          fallback: voteFailureFallback,
        ),
        error,
      );
    }

    if (!mounted) return;
    final currentIndex = _items.indexWhere((review) => review.uuid == uuid);
    setState(() {
      _pendingVoteUuids.remove(uuid);
      if (currentIndex == -1) return;
      switch (result) {
        case ReviewActionSuccess(value: final counts):
          _items[currentIndex] = _items[currentIndex].copyWith(
            helpfulCount: counts.helpfulCount,
            notHelpfulCount: counts.notHelpfulCount,
            userVote: isHelpful,
          );
        case ReviewActionFailure():
          _items[currentIndex] = original;
      }
    });

    if (result case ReviewActionFailure(message: final message)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: HbColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(eventReviewStatsProvider(widget.eventSlug));
    final canReviewAsync = ref.watch(canReviewProvider(widget.eventSlug));
    final explicitCanReview = !canReviewAsync.isLoading &&
            !canReviewAsync.hasError &&
            canReviewAsync.hasValue
        ? canReviewAsync.valueOrNull
        : null;
    final canWriteReview = explicitCanReview is CanReviewAllowed;

    // Avis utilisateur déjà laissé : on l'affiche en tête, sauf s'il est déjà
    // dans la liste publique (status approved → doublon).
    final myReview = explicitCanReview is CanReviewDenied
        ? explicitCanReview.existingReview
        : null;
    final myInList =
        myReview != null && _items.any((r) => r.uuid == myReview.uuid);
    final myReviewToShow = myInList ? null : myReview;

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.l10n.reviewsAllTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: HbColors.textPrimary,
      ),
      // Eligibility must be explicit. Loading/error/denied states never expose
      // a write action because they do not prove that no review exists.
      floatingActionButton: canWriteReview
          ? FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.lightImpact();
                _handleWriteReview();
              },
              backgroundColor: HbColors.brandPrimary,
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              label: Text(
                context.l10n.reviewsWriteReviewAction,
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: RefreshIndicator(
        color: HbColors.brandPrimary,
        onRefresh: _loadFirstPage,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: statsAsync.when(
                  loading: () => const SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: HbColors.brandPrimary,
                      ),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (stats) {
                    if (!stats.hasReviews) return const SizedBox.shrink();
                    return ReviewStatsCard(stats: stats);
                  },
                ),
              ),
            ),
            if (myReviewToShow != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MyReviewBlock(
                    review: myReviewToShow,
                    eventSlug: widget.eventSlug,
                    eventTitle: widget.eventTitle ?? '',
                    onChanged: _loadFirstPage,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: canReviewAsync.when(
                skipLoadingOnRefresh: false,
                skipLoadingOnReload: false,
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(context.l10n.reviewsEligibilityChecking),
                    ],
                  ),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CanReviewLoadError(
                    error: error,
                    onRetry: () => ref.invalidate(
                      canReviewProvider(widget.eventSlug),
                    ),
                  ),
                ),
                data: (r) {
                  // Si on affiche déjà le bloc "Votre avis", ne pas redire
                  // "vous avez déjà laissé un avis" en dessous.
                  if (r is CanReviewDenied &&
                      r.reason != CanReviewReason.alreadyReviewed) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CanReviewMessage(denied: r),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            SliverToBoxAdapter(child: _buildFiltersBar()),
            _buildList(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _RatingChip(
                  selected: _query.rating == null,
                  label: context.l10n.reviewsAllRatingsFilter,
                  onTap: () => _changeQuery((q) => q.copyWith(rating: null)),
                ),
                const SizedBox(width: 6),
                ...[5, 4, 3, 2, 1].map((star) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _RatingChip(
                      selected: _query.rating == star,
                      label: '$star ★',
                      onTap: () =>
                          _changeQuery((q) => q.copyWith(rating: star)),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilterChip(
                selected: _query.verifiedOnly,
                label: Text(context.l10n.reviewsVerifiedFilter),
                onSelected: (v) =>
                    _changeQuery((q) => q.copyWith(verifiedOnly: v)),
                selectedColor: HbColors.brandPrimary.withValues(alpha: 0.15),
                checkmarkColor: HbColors.brandPrimary,
              ),
              const SizedBox(width: 6),
              FilterChip(
                selected: _query.featuredOnly,
                label: Text(context.l10n.reviewsFeaturedFilter),
                onSelected: (v) =>
                    _changeQuery((q) => q.copyWith(featuredOnly: v)),
                selectedColor: HbColors.brandPrimary.withValues(alpha: 0.15),
                checkmarkColor: HbColors.brandPrimary,
              ),
              const Spacer(),
              PopupMenuButton<ReviewSortBy>(
                tooltip: context.l10n.reviewsSortTooltip,
                icon: const Icon(Icons.sort, color: HbColors.textPrimary),
                onSelected: (v) => _changeQuery((q) => q.copyWith(sortBy: v)),
                itemBuilder: (_) => ReviewSortBy.values
                    .map((v) => PopupMenuItem(
                          value: v,
                          child: Row(
                            children: [
                              if (_query.sortBy == v)
                                const Icon(Icons.check,
                                    size: 16, color: HbColors.brandPrimary),
                              if (_query.sortBy == v) const SizedBox(width: 6),
                              Text(_sortLabel(context, v)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading && _items.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
      );
    }
    if (_error != null && _items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: HbErrorView(message: _error!, onRetry: _loadFirstPage),
      );
    }
    if (_items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: HbEmptyState(
          icon: Icons.rate_review_outlined,
          title: context.l10n.reviewsNoReviewsTitle,
          message: context.l10n.reviewsNoFilteredResults,
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _items.length) {
              if (_loadMoreError != null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _loadMoreError!,
                        textAlign: TextAlign.center,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _loadMoreError = null);
                          _loadMore();
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(context.l10n.commonRetry),
                      ),
                    ],
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child:
                      CircularProgressIndicator(color: HbColors.brandPrimary),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(
                review: _items[index],
                onVote: _handleVote,
                onReport: () => _handleReport(_items[index]),
                isVotePending: _pendingVoteUuids.contains(_items[index].uuid),
              ),
            );
          },
          childCount: _items.length +
              (_isLoadingMore || _loadMoreError != null ? 1 : 0),
        ),
      ),
    );
  }

  String _sortLabel(BuildContext context, ReviewSortBy sortBy) {
    switch (sortBy) {
      case ReviewSortBy.helpful:
        return context.l10n.reviewsSortMostHelpful;
      case ReviewSortBy.rating:
        return context.l10n.reviewsSortRating;
      case ReviewSortBy.createdAt:
        return context.l10n.reviewsSortNewest;
    }
  }
}

class _RatingChip extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _RatingChip({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? HbColors.brandPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? HbColors.brandPrimary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : HbColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
