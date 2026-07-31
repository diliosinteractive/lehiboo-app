import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';

/// Provider for city detail - finds city by slug from the cities list
final cityDetailProvider =
    FutureProvider.family<City?, String>((ref, slug) async {
  final eventRepository = ref.watch(eventRepositoryProvider);
  final cities = await eventRepository.getCities();
  final matches = cities.where((city) => city.slug == slug);

  // `null` is reserved for a successful response that does not contain the
  // requested city. Transport/server failures must remain AsyncError so the
  // UI never mislabels an outage as "City not found".
  return matches.isEmpty ? null : matches.first;
});

const Object _cityLoadMoreErrorUnset = Object();

/// Paginated activities for a city.
///
/// `total` is `meta.total` from the events endpoint — single source of truth
/// for the "X événements disponibles" header. `activities` accumulates across
/// `loadMore()` calls; `page`/`lastPage` track pagination; `isLoadingMore`
/// gates the spinner shown at the bottom of the list during fetches.
class CityActivitiesResult {
  final List<Activity> activities;
  final int total;
  final int page;
  final int lastPage;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const CityActivitiesResult({
    required this.activities,
    required this.total,
    required this.page,
    required this.lastPage,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  bool get hasMore => page < lastPage;

  CityActivitiesResult copyWith({
    List<Activity>? activities,
    int? total,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
    Object? loadMoreError = _cityLoadMoreErrorUnset,
  }) =>
      CityActivitiesResult(
        activities: activities ?? this.activities,
        total: total ?? this.total,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError: identical(loadMoreError, _cityLoadMoreErrorUnset)
            ? this.loadMoreError
            : loadMoreError,
      );
}

class CityActivitiesController
    extends FamilyAsyncNotifier<CityActivitiesResult, String> {
  static const _perPage = 20;

  @override
  Future<CityActivitiesResult> build(String citySlug) async {
    debugPrint('Fetching activities for city: $citySlug');
    final result = await ref.read(eventRepositoryProvider).getEvents(
          location: citySlug,
          page: 1,
          perPage: _perPage,
        );
    debugPrint(
        'Got ${result.events.length}/${result.totalItems} events for city $citySlug (page ${result.currentPage}/${result.totalPages})');
    return CityActivitiesResult(
      activities: EventToActivityMapper.toActivities(result.events),
      total: result.totalItems,
      page: result.currentPage,
      lastPage: result.totalPages,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.loadMoreError != null) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    try {
      final next = await ref.read(eventRepositoryProvider).getEvents(
            location: arg,
            page: current.page + 1,
            perPage: _perPage,
          );
      final newActivities = EventToActivityMapper.toActivities(next.events);
      state = AsyncData(
        current.copyWith(
          activities: [...current.activities, ...newActivities],
          page: next.currentPage,
          lastPage: next.totalPages,
          isLoadingMore: false,
          loadMoreError: null,
        ),
      );
    } catch (e, st) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
      if (kDebugMode) {
        debugPrint('CityActivitiesController.loadMore failed: $e\n$st');
      }
    }
  }

  Future<void> retryLoadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(loadMoreError: null));
    await loadMore();
  }
}

final cityActivitiesProvider = AsyncNotifierProvider.family<
    CityActivitiesController, CityActivitiesResult, String>(
  CityActivitiesController.new,
);

class CityDetailScreen extends ConsumerStatefulWidget {
  final String citySlug;

  const CityDetailScreen({super.key, required this.citySlug});

  @override
  ConsumerState<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends ConsumerState<CityDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(cityActivitiesProvider(widget.citySlug).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityAsyncValue = ref.watch(cityDetailProvider(widget.citySlug));
    final activitiesAsyncValue =
        ref.watch(cityActivitiesProvider(widget.citySlug));

    final l10n = context.l10n;

    return Scaffold(
      body: cityAsyncValue.when(
        data: (city) {
          if (city == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.homeCityNotFound),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.commonBack),
                  ),
                ],
              ),
            );
          }

          final imageUrl = city.imageUrl?.trim();
          final hasImage = imageUrl != null && imageUrl.isNotEmpty;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFFFF601F),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    city.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFFF601F),
                        ),
                      ),
                      if (hasImage)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color:
                                const Color(0xFFFF601F).withValues(alpha: 0.3),
                          ),
                        ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.82),
                            ],
                            stops: const [0, 0.42, 1],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.description ??
                            l10n.homeCityDescriptionFallback(city.name),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      if (activitiesAsyncValue.valueOrNull != null) ...[
                        const SizedBox(height: 8),
                        Builder(
                          builder: (_) {
                            final total = activitiesAsyncValue.value!.total;
                            final plural = total != 1;
                            return Text(
                              plural
                                  ? l10n.homeCityAvailableEvents(total)
                                  : l10n.homeCityAvailableEvent(total),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.homePopularActivities,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => context.push(
                              Uri(
                                path: '/search',
                                queryParameters: {'city': city.slug},
                              ).toString(),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFF601F),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            icon: const Icon(Icons.tune, size: 16),
                            label: Text(
                              l10n.homeFilter,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Activities list from real API
              ..._buildActivitiesSlivers(context, activitiesAsyncValue),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF601F)),
        ),
        error: (err, stack) => _CityLoadError(
          message: ApiResponseHandler.extractError(
            err,
            fallback: l10n.homeCityLoadError,
          ),
          onRetry: () => ref.invalidate(cityDetailProvider(widget.citySlug)),
        ),
      ),
    );
  }

  List<Widget> _buildActivitiesSlivers(
    BuildContext context,
    AsyncValue<CityActivitiesResult> activitiesAsyncValue,
  ) {
    final l10n = context.l10n;
    return activitiesAsyncValue.when(
      data: (result) {
        final activities = result.activities;
        if (activities.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    l10n.homeCityNoActivities,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.48,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => EventCard(
                  activity: activities[index],
                  isCompact: true,
                  fillContainer: true,
                ),
                childCount: activities.length,
              ),
            ),
          ),
          if (result.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF601F)),
                ),
              ),
            ),
          if (result.loadMoreError != null)
            SliverToBoxAdapter(
              child: _CityActivitiesLoadMoreError(
                message: ApiResponseHandler.extractError(
                  result.loadMoreError,
                  fallback: l10n.homeCityActivitiesLoadMoreError,
                ),
                onRetry: () => ref
                    .read(
                      cityActivitiesProvider(widget.citySlug).notifier,
                    )
                    .retryLoadMore(),
              ),
            ),
        ];
      },
      loading: () => const [
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: Color(0xFFFF601F)),
            ),
          ),
        ),
      ],
      error: (err, _) => [
        SliverToBoxAdapter(
          child: _CityActivitiesLoadError(
            message: ApiResponseHandler.extractError(
              err,
              fallback: l10n.homeCityActivitiesLoadError,
            ),
            onRetry: () =>
                ref.invalidate(cityActivitiesProvider(widget.citySlug)),
          ),
        ),
      ],
    );
  }
}

class _CityLoadError extends StatelessWidget {
  const _CityLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_outlined,
                size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.homeCityLoadError,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityActivitiesLoadError extends StatelessWidget {
  const _CityActivitiesLoadError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.event_busy_outlined, size: 42, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            context.l10n.homeCityActivitiesLoadError,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}

class _CityActivitiesLoadMoreError extends StatelessWidget {
  const _CityActivitiesLoadMoreError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}
