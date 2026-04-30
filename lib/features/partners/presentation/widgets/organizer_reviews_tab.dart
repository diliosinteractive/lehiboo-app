import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../../reviews/data/models/review_dto.dart';
import '../providers/organizer_reviews_providers.dart';
import 'organizer_review_row.dart';

/// "Avis" tab — histogram header + paginated list of reviews aggregated
/// across the organizer's events.
///
/// Spec §6ter, §6quater
class OrganizerReviewsTab extends ConsumerStatefulWidget {
  final String organizerIdentifier;

  const OrganizerReviewsTab({super.key, required this.organizerIdentifier});

  @override
  ConsumerState<OrganizerReviewsTab> createState() =>
      _OrganizerReviewsTabState();
}

class _OrganizerReviewsTabState extends ConsumerState<OrganizerReviewsTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      ref
          .read(organizerReviewsControllerProvider(widget.organizerIdentifier)
              .notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(
      organizerReviewsStatsFutureProvider(widget.organizerIdentifier),
    );
    final listAsync = ref.watch(
      organizerReviewsControllerProvider(widget.organizerIdentifier),
    );

    return listAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: HbColors.brandPrimary),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Impossible de charger les avis.',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ),
      data: (state) {
        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          // +1 for the histogram header, +1 for the load-more spinner when active
          itemCount:
              1 + state.items.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, index) {
            if (index == 0) return const SizedBox.shrink();
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[100],
              indent: 20,
              endIndent: 20,
            );
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              return _HistogramHeader(statsAsync: statsAsync);
            }
            final reviewIndex = index - 1;
            if (reviewIndex == state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: HbColors.brandPrimary,
                  ),
                ),
              );
            }
            return OrganizerReviewRow(review: state.items[reviewIndex]);
          },
        );
      },
    );
  }
}

class _HistogramHeader extends StatelessWidget {
  final AsyncValue<ReviewStatsDto> statsAsync;

  const _HistogramHeader({required this.statsAsync});

  @override
  Widget build(BuildContext context) {
    return statsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (stats) {
        final total = stats.totalReviews > 0
            ? stats.totalReviews
            : stats.totalReviewsCamel;
        final average = stats.averageRating > 0
            ? stats.averageRating
            : stats.averageRatingCamel;
        final verified = stats.verifiedCount > 0
            ? stats.verifiedCount
            : stats.verifiedCountCamel;

        if (total == 0) {
          return const _NoReviewsState();
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hero rating block
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        average.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textPrimary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          for (int i = 1; i <= 5; i++)
                            Icon(
                              i <= average.round()
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 16,
                              color: HbColors.brandPrimary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sur $total ${total > 1 ? "avis" : "avis"}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      if (verified > 0)
                        Text(
                          'dont $verified ${verified > 1 ? "achats vérifiés" : "achat vérifié"}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Distribution(
                      distribution: stats.distribution,
                      percentages: stats.percentages,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Distribution extends StatelessWidget {
  final Map<String, int> distribution;
  final Map<String, int> percentages;

  const _Distribution({
    required this.distribution,
    required this.percentages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int rating = 5; rating >= 1; rating--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _DistributionRow(
              rating: rating,
              count: distribution['$rating'] ?? 0,
              percentage: percentages['$rating'] ?? 0,
            ),
          ),
      ],
    );
  }
}

class _DistributionRow extends StatelessWidget {
  final int rating;
  final int count;
  final int percentage;

  const _DistributionRow({
    required this.rating,
    required this.count,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            '$rating',
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
          ),
        ),
        const Icon(Icons.star_rounded, size: 12, color: HbColors.brandPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 6, color: Colors.grey[200]),
                FractionallySizedBox(
                  widthFactor: (percentage / 100).clamp(0, 1).toDouble(),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: HbColors.brandPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 28,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

class _NoReviewsState extends StatelessWidget {
  const _NoReviewsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined,
                size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Aucun avis pour le moment",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Soyez parmi les premiers à laisser un avis sur l'un de ses événements.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
