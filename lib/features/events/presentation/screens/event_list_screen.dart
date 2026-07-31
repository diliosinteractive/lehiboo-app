import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/events/presentation/utils/event_l10n.dart';
import 'package:lehiboo/features/search/presentation/widgets/filter_bottom_sheet.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:lehiboo/features/search/presentation/widgets/save_search_sheet.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';

/// Provider for events list from real API
final eventsListProvider = StateNotifierProvider.family<_EventsListController,
    AsyncValue<List<Activity>>, EventsListParams>((ref, params) {
  // `GET /events` is auth-optional and can return member-only events. The
  // opaque key forces a fresh, blank controller for every session boundary,
  // including a rapid A -> B -> A transition.
  ref.watch(authSessionKeyProvider);
  final repository = ref.watch(eventRepositoryProvider);
  return _EventsListController(repository, params);
});

class _EventsListController extends StateNotifier<AsyncValue<List<Activity>>> {
  _EventsListController(this._eventRepository, this._params)
      : super(const AsyncValue.loading()) {
    _initialLoad = _load();
    unawaited(_initialLoad);
  }

  final EventRepository _eventRepository;
  final EventsListParams _params;
  late final Future<void> _initialLoad;
  int _requestGeneration = 0;

  Future<void> waitForInitialLoad() => _initialLoad;

  Future<void> _load() async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    state = const AsyncValue.loading();

    debugPrint('=== eventsListProvider called ===');
    debugPrint('Params: page=${_params.page}, perPage=${_params.perPage}');
    debugPrint(
      'Search: ${_params.search}, categorySlug: ${_params.categorySlug}, '
      'city: ${_params.city}',
    );
    debugPrint(
      'DateFilter: ${_params.dateFilter}, OnlyFree: ${_params.onlyFree}',
    );

    try {
      debugPrint('Calling eventRepository.getEvents...');
      final result = await _eventRepository.getEvents(
        page: _params.page,
        perPage: _params.perPage,
        search: _params.search,
        categorySlug: _params.categorySlug,
        city: _params.city,
        orderBy: _params.orderBy ?? 'date',
        order: _params.order ?? 'asc',
      );
      if (!mounted || requestGeneration != _requestGeneration) return;

      debugPrint('Got ${result.events.length} events from API');
      debugPrint(
        'Pagination: page ${result.currentPage}/${result.totalPages}, '
        'total: ${result.totalItems}',
      );

      if (result.events.isNotEmpty) {
        debugPrint('First event: ${result.events.first.title}');
      }

      var activities = EventToActivityMapper.toActivities(result.events);
      debugPrint('Mapped to ${activities.length} activities');

      // Apply client-side filters
      if (_params.dateFilter != null) {
        activities = _filterByDate(activities, _params.dateFilter!);
        debugPrint(
          'After date filter (${_params.dateFilter}): '
          '${activities.length} activities',
        );
      }

      if (_params.onlyFree) {
        activities = activities.where((a) => a.isAuthoritativelyFree).toList();
        debugPrint('After free filter: ${activities.length} activities');
      }

      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.data(activities);
    } catch (error, stackTrace) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      debugPrint('Error fetching events: $error');
      debugPrint('Stack trace: $stackTrace');
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

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
      final saturday = today.add(Duration(
          days: daysUntilSaturday == 0 && now.weekday != DateTime.saturday
              ? 7
              : daysUntilSaturday));
      final sunday = saturday.add(const Duration(days: 1));

      return activities.where((a) {
        final slotDate = a.nextSlot?.startDateTime;
        if (slotDate == null) return false;
        final eventDate = DateTime(slotDate.year, slotDate.month, slotDate.day);
        return eventDate.isAtSameMomentAs(saturday) ||
            eventDate.isAtSameMomentAs(sunday);
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
  final ScrollController _scrollController = ScrollController();
  late String? _lastAuthAccountId;
  int _authIdentityGeneration = 0;
  late final ProviderSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _lastAuthAccountId = _authenticatedAccountId(ref.read(authProvider));
    _authSubscription = ref.listenManual<AuthState>(
      authProvider,
      (_, next) {
        final nextAccountId = _authenticatedAccountId(next);
        if (nextAccountId == _lastAuthAccountId) return;
        _lastAuthAccountId = nextAccountId;
        _authIdentityGeneration++;
        _searchController.clear();
      },
    );
    final initialSessionGeneration = _authIdentityGeneration;

    // Initialize category filter from widget parameter if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || initialSessionGeneration != _authIdentityGeneration) {
        return;
      }
      final filterNotifier = ref.read(eventFilterProvider.notifier);

      // If passing specific filters via navigation, reset previous state
      if (widget.categorySlug != null || widget.city != null) {
        filterNotifier.resetAll();
      }

      if (widget.categorySlug != null) {
        filterNotifier.addThematique(widget.categorySlug!);
      }
      if (widget.city != null) {
        // Use slug as name temporarily, or capitalize it
        final cityName =
            widget.city![0].toUpperCase() + widget.city!.substring(1);
        filterNotifier.setCity(widget.city!, cityName);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _authenticatedAccountId(AuthState auth) {
    if (!auth.isAuthenticated) return null;
    final accountId = auth.user?.id.trim();
    return accountId == null || accountId.isEmpty ? null : accountId;
  }

  bool _ownsAuthGeneration(String ownerAccountId, int generation) {
    return _authIdentityGeneration == generation &&
        ref.read(authSessionUserIdProvider) == ownerAccountId;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final filteredEventsState = ref.read(filteredEventsProvider);
      filteredEventsState.whenData((data) {
        if (data.hasMore && !filteredEventsState.isLoading) {
          ref.read(eventFilterProvider.notifier).nextPage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global filter provider
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final eventsAsync = ref.watch(filteredEventsProvider);
    final renderedEventsSession = ref.watch(authSessionKeyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? context.l10n.eventExploreTitle),
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
                hintText: context.l10n.eventSearchHintActivity,
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon:
                    const Icon(Icons.search, color: HbColors.brandPrimary),
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
                        color: filter.hasActiveFilters
                            ? HbColors.brandPrimary
                            : Colors.grey,
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                children: [
                  _QuickFilterChip(
                    label: context.l10n.commonToday,
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
                    label: context.l10n.commonTomorrow,
                    isSelected:
                        filter.dateFilterType == DateFilterType.tomorrow,
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
                    label: context.l10n.commonThisWeekend,
                    isSelected:
                        filter.dateFilterType == DateFilterType.thisWeekend,
                    onTap: () {
                      if (filter.dateFilterType == DateFilterType.thisWeekend) {
                        filterNotifier.clearDateFilter();
                      } else {
                        filterNotifier
                            .setDateFilter(DateFilterType.thisWeekend);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickFilterChip(
                    label: context.l10n.commonFree,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: filter.hasActiveFilters
                            ? HbColors.brandPrimary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: HbColors.brandPrimary, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune,
                              size: 16,
                              color: filter.hasActiveFilters
                                  ? Colors.white
                                  : HbColors.brandPrimary),
                          const SizedBox(width: 6),
                          Text(
                            filter.hasActiveFilters
                                ? context.eventFiltersWithCount(
                                    filter.activeFilterCount)
                                : context.l10n.searchFiltersTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: filter.hasActiveFilters
                                  ? Colors.white
                                  : HbColors.brandPrimary,
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
              data: (paginatedData) {
                final activities = paginatedData.activities;
                final hasMore = paginatedData.hasMore;

                if (activities.isEmpty) {
                  return _buildEmptyState(filter);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredEventsProvider);
                  },
                  color: HbColors.brandPrimary,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: activities.length + 1, // +1 for loader/footer
                    itemBuilder: (context, index) {
                      if (index == activities.length) {
                        // Footer
                        if (hasMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: HbColors.brandPrimary),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              children: [
                                Text(
                                  context.l10n.eventEndOfList,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => _saveCurrentSearch(context,
                                      isAlert: true),
                                  icon: const Icon(
                                      Icons.notifications_active_outlined),
                                  label: Text(
                                    context.l10n.searchAlertNewActivities,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HbColors.accentBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          );
                        }
                      }

                      // Using GridView inside ListView via index mapping is tricky, changed to ListView with cards for simplicity
                      // Or if we want Grid:
                      // Getting a grid inside expanded with infinite scroll:
                      // Actually users usually prefer list or grid. The previous code used GridView.builder.
                      // To keep GridView with infinite scroll loader at bottom:

                      // We can return a tailored item. But GridView itembuilder builds cells.
                      // If we want a loader at the bottom of a grid, the grid needs to span full width.
                      // Easier to use CustomScrollView with SliverGrid and SliverToBoxAdapter for loader.

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EventCard(
                          activity: activities[index],
                          ownerSession: renderedEventsSession,
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () {
                // Handle re-loading with data
                final previousData = eventsAsync.valueOrNull;
                if (previousData != null &&
                    previousData.activities.isNotEmpty) {
                  final activities = previousData.activities;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: activities.length + 1,
                    itemBuilder: (context, index) {
                      if (index == activities.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: CircularProgressIndicator(
                                color: HbColors.brandPrimary),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EventCard(
                          activity: activities[index],
                          ownerSession: renderedEventsSession,
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child:
                      CircularProgressIndicator(color: HbColors.brandPrimary),
                );
              },
              error: (error, stack) => _buildErrorState(
                ApiResponseHandler.extractError(error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCurrentSearch(BuildContext context,
      {bool isAlert = false}) async {
    final initiatingAccountId = ref.read(authSessionUserIdProvider);
    final initiatingGeneration = _authIdentityGeneration;
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureSaveSearch,
    );
    if (!allowed) return;
    if (!context.mounted) return;

    final ownerAccountId = ref.read(authSessionUserIdProvider);
    if (ownerAccountId == null ||
        (initiatingAccountId != null &&
            initiatingAccountId != ownerAccountId) ||
        (initiatingAccountId == null
            ? _authIdentityGeneration != initiatingGeneration + 1
            : _authIdentityGeneration != initiatingGeneration)) {
      return;
    }
    final ownerGeneration = _authIdentityGeneration;

    final filter = ref.read(eventFilterProvider);
    final alertsNotifier = ref.read(alertsProvider.notifier);

    // Show the SaveSearchSheet modal
    final result = await SaveSearchSheet.show(
      context,
      filter: filter,
      ownerAccountId: ownerAccountId,
      isNameAlreadyUsed: alertsNotifier.isNameAlreadyUsed,
    );

    if (result == null ||
        !context.mounted ||
        !_ownsAuthGeneration(ownerAccountId, ownerGeneration) ||
        !identical(ref.read(alertsProvider.notifier), alertsNotifier)) {
      return;
    }

    try {
      await alertsNotifier.createAlert(
        name: result.name,
        filter: filter,
        enablePush: result.enablePush,
        enableEmail: result.enableEmail,
      );
    } catch (error) {
      if (!context.mounted ||
          !_ownsAuthGeneration(ownerAccountId, ownerGeneration) ||
          !identical(ref.read(alertsProvider.notifier), alertsNotifier)) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiResponseHandler.extractError(
              error,
              fallback: context.l10n.searchSaveFailed,
            ),
          ),
          backgroundColor: HbColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (!context.mounted ||
        !_ownsAuthGeneration(ownerAccountId, ownerGeneration) ||
        !identical(ref.read(alertsProvider.notifier), alertsNotifier)) {
      return;
    }
    final hasNotifications = result.enablePush || result.enableEmail;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(hasNotifications
            ? context.l10n.searchSavedAlertCreated(result.name)
            : context.l10n.searchSavedSearchCreated(result.name)),
        backgroundColor: HbColors.accentBlue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
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
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy,
              size: 50,
              color: HbColors.brandPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.eventNoEventsTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filter.hasActiveFilters
                ? context.l10n.eventNoResultsWithFilters
                : context.l10n.eventNoEventsAvailable,
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
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(context.l10n.searchClearFilters),
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
          Text(
            context.l10n.eventGenericErrorTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
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
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.l10n.searchRetry),
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
          color: isSelected ? HbColors.brandPrimary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
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
