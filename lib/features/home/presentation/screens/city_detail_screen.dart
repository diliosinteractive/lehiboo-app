import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';

/// Provider for city detail - finds city by slug from the cities list
final cityDetailProvider =
    FutureProvider.family<City?, String>((ref, slug) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  try {
    final citiesDto = await eventRepository.getCities();
    // Find city by slug
    final cityDto = citiesDto.firstWhere(
      (c) => c.slug == slug,
      orElse: () => throw Exception('City not found'),
    );

    return City(
      id: cityDto.id.toString(),
      name: cityDto.name,
      slug: cityDto.slug,
      eventCount: cityDto.eventCount,
      imageUrl: _getCityImageUrl(cityDto.name),
    );
  } catch (e) {
    debugPrint('Error getting city by slug: $e');
    return null;
  }
});

/// Get a placeholder image URL for a city
String _getCityImageUrl(String cityName) {
  final cityImages = {
    'california':
        'https://images.unsplash.com/photo-1449034446853-66c86144b0ad?w=400',
    'paris':
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
    'lyon':
        'https://images.unsplash.com/photo-1524397057410-1e775ed476f3?w=400',
    'marseille':
        'https://images.unsplash.com/photo-1589394760766-91f2a2db1d6f?w=400',
    'bordeaux':
        'https://images.unsplash.com/photo-1565018054866-968e244671af?w=400',
    'toulouse':
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    'nantes':
        'https://images.unsplash.com/photo-1588431379983-d4aefc8db5b0?w=400',
    'nice':
        'https://images.unsplash.com/photo-1491166617655-0723a0999cfc?w=400',
    'strasbourg':
        'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400',
    'montpellier':
        'https://images.unsplash.com/photo-1597418680155-3c28a6a6bbef?w=400',
  };

  final lowerName = cityName.toLowerCase();
  return cityImages[lowerName] ??
      'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400';
}

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

  const CityActivitiesResult({
    required this.activities,
    required this.total,
    required this.page,
    required this.lastPage,
    this.isLoadingMore = false,
  });

  bool get hasMore => page < lastPage;

  CityActivitiesResult copyWith({
    List<Activity>? activities,
    int? total,
    int? page,
    int? lastPage,
    bool? isLoadingMore,
  }) =>
      CityActivitiesResult(
        activities: activities ?? this.activities,
        total: total ?? this.total,
        page: page ?? this.page,
        lastPage: lastPage ?? this.lastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

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
        ),
      );
    } catch (e, st) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      if (kDebugMode) {
        debugPrint('CityActivitiesController.loadMore failed: $e\n$st');
      }
    }
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

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFFFF601F),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(city.name),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (city.imageUrl != null)
                        Image.network(
                          city.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFFF601F).withOpacity(0.3),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
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
        error: (err, stack) =>
            Center(child: Text(l10n.homeErrorWithMessage(err.toString()))),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(l10n.homeErrorWithMessage(err.toString())),
            ),
          ),
        ),
      ],
    );
  }
}
