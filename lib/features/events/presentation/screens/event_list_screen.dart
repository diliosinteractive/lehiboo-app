import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/search/presentation/widgets/filter_bottom_sheet.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';

/// Provider for events list from real API
final eventsListProvider = FutureProvider.family<List<Activity>, EventsListParams>((ref, params) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  debugPrint('=== eventsListProvider called ===');
  debugPrint('Params: page=${params.page}, perPage=${params.perPage}');
  debugPrint('Search: ${params.search}, categorySlug: ${params.categorySlug}, city: ${params.city}');
  debugPrint('DateFilter: ${params.dateFilter}, OnlyFree: ${params.onlyFree}');

  try {
    debugPrint('Calling eventRepository.getEvents...');
    final result = await eventRepository.getEvents(
      page: params.page,
      perPage: params.perPage,
      search: params.search,
      categorySlug: params.categorySlug,
      city: params.city,
      orderBy: params.orderBy ?? 'date',
      order: params.order ?? 'asc',
    );

    debugPrint('Got ${result.events.length} events from API');
    debugPrint('Pagination: page ${result.currentPage}/${result.totalPages}, total: ${result.totalItems}');

    if (result.events.isNotEmpty) {
      debugPrint('First event: ${result.events.first.title}');
    }

    var activities = EventToActivityMapper.toActivities(result.events);
    debugPrint('Mapped to ${activities.length} activities');

    // Apply client-side filters
    if (params.dateFilter != null) {
      activities = _filterByDate(activities, params.dateFilter!);
      debugPrint('After date filter (${params.dateFilter}): ${activities.length} activities');
    }

    if (params.onlyFree) {
      activities = activities.where((a) => a.isFree == true).toList();
      debugPrint('After free filter: ${activities.length} activities');
    }

    return activities;
  } catch (e, stackTrace) {
    debugPrint('Error fetching events: $e');
    debugPrint('Stack trace: $stackTrace');
    return [];
  }
});

/// Filter activities by date
List<Activity> _filterByDate(List<Activity> activities, String dateFilter) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  switch (dateFilter) {
    case 'today':
      return activities.where((a) {
        final slotDate = a.nextSlot?.startDateTime;
        if (slotDate == null) return false;
        final eventDate = DateTime(slotDate.year, slotDate.month, slotDate.day);
        return eventDate.isAtSameMomentAs(today);
      }).toList();

    case 'tomorrow':
      return activities.where((a) {
        final slotDate = a.nextSlot?.startDateTime;
        if (slotDate == null) return false;
        final eventDate = DateTime(slotDate.year, slotDate.month, slotDate.day);
        return eventDate.isAtSameMomentAs(tomorrow);
      }).toList();

    case 'weekend':
      // Find next Saturday and Sunday
      final daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
      final saturday = today.add(Duration(days: daysUntilSaturday == 0 && now.weekday != DateTime.saturday ? 7 : daysUntilSaturday));
      final sunday = saturday.add(const Duration(days: 1));

      return activities.where((a) {
        final slotDate = a.nextSlot?.startDateTime;
        if (slotDate == null) return false;
        final eventDate = DateTime(slotDate.year, slotDate.month, slotDate.day);
        return eventDate.isAtSameMomentAs(saturday) || eventDate.isAtSameMomentAs(sunday);
      }).toList();

    default:
      return activities;
  }
}

/// Parameters for events list query
class EventsListParams {
  final int page;
  final int perPage;
  final String? search;
  final String? categorySlug;
  final String? city;
  final String? orderBy;
  final String? order;
  final String? dateFilter; // 'today', 'tomorrow', 'weekend'
  final bool onlyFree;

  const EventsListParams({
    this.page = 1,
    this.perPage = 20,
    this.search,
    this.categorySlug,
    this.city,
    this.orderBy,
    this.order,
    this.dateFilter,
    this.onlyFree = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventsListParams &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          perPage == other.perPage &&
          search == other.search &&
          categorySlug == other.categorySlug &&
          city == other.city &&
          orderBy == other.orderBy &&
          order == other.order &&
          dateFilter == other.dateFilter &&
          onlyFree == other.onlyFree;

  @override
  int get hashCode =>
      page.hashCode ^
      perPage.hashCode ^
      search.hashCode ^
      categorySlug.hashCode ^
      city.hashCode ^
      orderBy.hashCode ^
      order.hashCode ^
      dateFilter.hashCode ^
      onlyFree.hashCode;
}

class EventListScreen extends ConsumerStatefulWidget {
  final String? title;
  final String? filterType;
  final String? categorySlug;
  final String? city;

  const EventListScreen({
    super.key,
    this.title,
    this.filterType,
    this.categorySlug,
    this.city,
  });

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize category filter from widget parameter if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterNotifier = ref.read(eventFilterProvider.notifier);
      if (widget.categorySlug != null) {
        filterNotifier.addThematique(widget.categorySlug!);
      }
      if (widget.city != null) {
        filterNotifier.setCity(widget.city!, widget.city!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global filter provider
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final eventsAsync = ref.watch(filteredEventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(widget.title ?? 'Explorer les événements'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une activité...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF6B35)),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filter.searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          filterNotifier.clearSearchQuery();
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: filter.hasActiveFilters ? const Color(0xFFFF6B35) : Colors.grey,
                      ),
                      onPressed: () => showFilterBottomSheet(context),
                    ),
                  ],
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (value) {
                filterNotifier.setSearchQuery(value);
              },
            ),
          ),
          // Quick filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _QuickFilterChip(
                    label: "Aujourd'hui",
                    isSelected: filter.dateFilterType == DateFilterType.today,
                    onTap: () {
                      if (filter.dateFilterType == DateFilterType.today) {
                        filterNotifier.clearDateFilter();
                      } else {
                        filterNotifier.setDateFilter(DateFilterType.today);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickFilterChip(
                    label: 'Demain',
                    isSelected: filter.dateFilterType == DateFilterType.tomorrow,
                    onTap: () {
                      if (filter.dateFilterType == DateFilterType.tomorrow) {
                        filterNotifier.clearDateFilter();
                      } else {
                        filterNotifier.setDateFilter(DateFilterType.tomorrow);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickFilterChip(
                    label: 'Ce week-end',
                    isSelected: filter.dateFilterType == DateFilterType.thisWeekend,
                    onTap: () {
                      if (filter.dateFilterType == DateFilterType.thisWeekend) {
                        filterNotifier.clearDateFilter();
                      } else {
                        filterNotifier.setDateFilter(DateFilterType.thisWeekend);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickFilterChip(
                    label: 'Gratuit',
                    icon: Icons.local_offer,
                    isSelected: filter.onlyFree,
                    onTap: () {
                      filterNotifier.setOnlyFree(!filter.onlyFree);
                    },
                  ),
                  const SizedBox(width: 8),
                  // Filter button with count badge
                  GestureDetector(
                    onTap: () => showFilterBottomSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: filter.hasActiveFilters ? const Color(0xFFFF6B35) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFFF6B35), width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune, size: 16, color: filter.hasActiveFilters ? Colors.white : const Color(0xFFFF6B35)),
                          const SizedBox(width: 6),
                          Text(
                            filter.hasActiveFilters ? 'Filtres (${filter.activeFilterCount})' : 'Filtres',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: filter.hasActiveFilters ? Colors.white : const Color(0xFFFF6B35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Events list
          Expanded(
            child: eventsAsync.when(
              data: (activities) {
                if (activities.isEmpty) {
                  return _buildEmptyState(filter);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredEventsProvider);
                  },
                  color: const Color(0xFFFF6B35),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.50,
                    ),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                        activity: activities[index],
                        isCompact: true,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
              ),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(EventFilter filter) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy,
              size: 50,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucun événement trouvé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filter.hasActiveFilters
                ? 'Aucun résultat avec les filtres actuels'
                : 'Il n\'y a pas d\'événements disponibles pour le moment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (filter.hasActiveFilters) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                filterNotifier.resetAll();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Effacer les filtres'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Une erreur est survenue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(filteredEventsProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

/// Quick filter chip widget
class _QuickFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
