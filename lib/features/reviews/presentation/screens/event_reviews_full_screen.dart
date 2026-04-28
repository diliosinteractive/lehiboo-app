import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../core/widgets/feedback/hb_feedback.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_enums.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/reviews_providers.dart';
import '../widgets/can_review_message.dart';
import '../widgets/event_reviews_section.dart';
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
        _error = 'Impossible de charger les avis.';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    setState(() => _isLoadingMore = true);
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
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
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
      featureName: 'laisser un avis',
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
      featureName: 'signaler un avis',
    );
    if (!allowed || !mounted) return;
    await ReportReviewSheet.show(context, reviewUuid: review.uuid);
  }

  Future<void> _handleVote(String uuid, bool isHelpful) async {
    final reviewIndex = _items.indexWhere((r) => r.uuid == uuid);
    if (reviewIndex == -1) return;

    final original = _items[reviewIndex];

    // Optimistic update
    int helpful = original.helpfulCount;
    int notHelpful = original.notHelpfulCount;
    if (original.userVote == isHelpful) {
      // Same vote → unvote
      if (isHelpful) {
        helpful = (helpful - 1).clamp(0, helpful);
      } else {
        notHelpful = (notHelpful - 1).clamp(0, notHelpful);
      }
      setState(() {
        _items[reviewIndex] = original.copyWith(
          helpfulCount: helpful,
          notHelpfulCount: notHelpful,
          userVote: null,
        );
      });
      await ref.read(reviewsActionsProvider.notifier).unvoteReview(
            reviewUuid: uuid,
            eventSlug: widget.eventSlug,
          );
    } else {
      // Switch or new vote
      if (original.userVote == true) {
        helpful = (helpful - 1).clamp(0, helpful);
      } else if (original.userVote == false) {
        notHelpful = (notHelpful - 1).clamp(0, notHelpful);
      }
      if (isHelpful) {
        helpful++;
      } else {
        notHelpful++;
      }
      setState(() {
        _items[reviewIndex] = original.copyWith(
          helpfulCount: helpful,
          notHelpfulCount: notHelpful,
          userVote: isHelpful,
        );
      });
      // If switching, unvote first
      if (original.userVote != null) {
        await ref.read(reviewsActionsProvider.notifier).unvoteReview(
              reviewUuid: uuid,
              eventSlug: widget.eventSlug,
            );
      }
      await ref.read(reviewsActionsProvider.notifier).voteReview(
            reviewUuid: uuid,
            isHelpful: isHelpful,
            eventSlug: widget.eventSlug,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(eventReviewStatsProvider(widget.eventSlug));
    final canReviewAsync = ref.watch(canReviewProvider(widget.eventSlug));

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Tous les avis'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: HbColors.textPrimary,
      ),
      floatingActionButton: canReviewAsync.maybeWhen(
        data: (r) => r is CanReviewAllowed
            ? FloatingActionButton.extended(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _handleWriteReview();
                },
                backgroundColor: HbColors.brandPrimary,
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                label: const Text(
                  'Écrire un avis',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : null,
        orElse: () => null,
      ),
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
            SliverToBoxAdapter(
              child: canReviewAsync.maybeWhen(
                data: (r) => r is CanReviewDenied
                    ? Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: CanReviewMessage(denied: r),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
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
                  label: 'Tous',
                  onTap: () =>
                      _changeQuery((q) => q.copyWith(rating: null)),
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
                label: const Text('Vérifiés'),
                onSelected: (v) =>
                    _changeQuery((q) => q.copyWith(verifiedOnly: v)),
                selectedColor:
                    HbColors.brandPrimary.withValues(alpha: 0.15),
                checkmarkColor: HbColors.brandPrimary,
              ),
              const SizedBox(width: 6),
              FilterChip(
                selected: _query.featuredOnly,
                label: const Text('Mis en avant'),
                onSelected: (v) =>
                    _changeQuery((q) => q.copyWith(featuredOnly: v)),
                selectedColor:
                    HbColors.brandPrimary.withValues(alpha: 0.15),
                checkmarkColor: HbColors.brandPrimary,
              ),
              const Spacer(),
              PopupMenuButton<ReviewSortBy>(
                tooltip: 'Trier',
                icon: const Icon(Icons.sort, color: HbColors.textPrimary),
                onSelected: (v) =>
                    _changeQuery((q) => q.copyWith(sortBy: v)),
                itemBuilder: (_) => ReviewSortBy.values
                    .map((v) => PopupMenuItem(
                          value: v,
                          child: Row(
                            children: [
                              if (_query.sortBy == v)
                                const Icon(Icons.check,
                                    size: 16,
                                    color: HbColors.brandPrimary),
                              if (_query.sortBy == v)
                                const SizedBox(width: 6),
                              Text(v.displayLabel),
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
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: HbEmptyState(
          icon: Icons.rate_review_outlined,
          title: 'Aucun avis',
          message: 'Aucun avis ne correspond aux filtres sélectionnés.',
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _items.length) {
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
              ),
            );
          },
          childCount: _items.length + (_isLoadingMore ? 1 : 0),
        ),
      ),
    );
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
          color: selected
              ? HbColors.brandPrimary
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? HbColors.brandPrimary
                : Colors.grey.shade300,
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
