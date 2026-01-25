import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/ai_chat/presentation/providers/chat_engagement_provider.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../widgets/airbnb_search_bar.dart';
import '../widgets/airbnb_search_sheet.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/save_search_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? categorySlug;
  final String? city;
  final bool autoOpenFilter;

  const SearchScreen({
    super.key,
    this.categorySlug,
    this.city,
    this.autoOpenFilter = false,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initialize filters if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterNotifier = ref.read(eventFilterProvider.notifier);
      if (widget.categorySlug != null || widget.city != null) {
        filterNotifier.resetAll();
      }
      
      if (widget.categorySlug != null) {
        filterNotifier.addCategory(widget.categorySlug!);
      }
      if (widget.city != null) {
        final cityName = widget.city![0].toUpperCase() + widget.city!.substring(1);
        filterNotifier.setCity(widget.city!, cityName);
      }

      // Auto open filter bottom sheet if requested
      if (widget.autoOpenFilter) {
        _showSearchBottomSheet();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final filteredEventsState = ref.read(filteredEventsProvider);
      filteredEventsState.whenData((data) {
        if (data.hasMore) {
          // Debounce/Throttle could be added here if needed, but repository can handle concurrent calls
          // or we can check a local loading flag. For now, rely on repo/provider stability.
          // Better: Check if we are already fetching? The provider is AsyncNotifier, 
          // but we don't have an explicit "isLoadingMore" exposed easily in the 'data' part 
          // unless we add it to state. 
          // We'll trust the logic: if we are at bottom, request next page.
          // The provider build logic handles page increments.
          
          // Wait, we need to only trigger if NOT already loading.
          // The AsyncValue.isLoading is true when fetching.
          if (!filteredEventsState.isLoading) {
             ref.read(eventFilterProvider.notifier).nextPage();
          }
        }
      });
    }
  }

  void _showSearchBottomSheet() {
    // Ouvre le composant Airbnb-style plein écran unifié
    AirbnbSearchSheet.show(context);
  }

  Future<void> _saveCurrentSearch(BuildContext context, {bool isAlert = false}) async {
    final filter = ref.read(eventFilterProvider);

    // Show the new SaveSearchSheet modal
    final result = await SaveSearchSheet.show(
      context,
      filter: filter,
    );

    if (result == null) return; // User cancelled

    // Call API via provider with explicit push/email params
    await ref.read(alertsProvider.notifier).createAlert(
      name: result.name,
      filter: filter,
      enablePush: result.enablePush,
      enableEmail: result.enableEmail,
    );

    if (mounted) {
      final hasNotifications = result.enablePush || result.enableEmail;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hasNotifications
              ? 'Alerte "${result.name}" créée avec notifications !'
              : 'Recherche "${result.name}" enregistrée !'),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showCreateAlertDialog(BuildContext context) {
    // We can reuse the same logic, passing isAlert: true
    _saveCurrentSearch(context, isAlert: true);
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = ref.watch(filteredEventsProvider);
    final filter = ref.watch(eventFilterProvider);

    return Scaffold(

      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Floating App Bar with Search
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 220, // Increased to fit chips and padding
              collapsedHeight: 220,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/');
                                }
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const Text(
                              'Rechercher',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            // Save Search Button
                            if (filter.hasActiveFilters)
                              Consumer(
                                builder: (context, ref, child) {
                                  final alertsAsync = ref.watch(alertsProvider);
                                  
                                  // Determine if saved
                                  // We handle loading/error gracefully by just assuming false if not loaded
                                  final isAlreadySaved = alertsAsync.maybeWhen(
                                    data: (alerts) {
                                      final notifier = ref.read(alertsProvider.notifier);
                                      return notifier.isFilterSaved(filter);
                                    },
                                    orElse: () => false,
                                  );

                                  if (isAlreadySaved) {
                                    return OutlinedButton(
                                      onPressed: null, // Disable button if already saved
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        side: BorderSide(color: Colors.grey[400]!, width: 1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        backgroundColor: Colors.grey[100],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.bookmark, size: 18, color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Recherche\nenregistrée',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              height: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return OutlinedButton(
                                    onPressed: () => _saveCurrentSearch(context),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      side: const BorderSide(color: Color(0xFFFF601F), width: 1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      backgroundColor: const Color(0xFFFF601F).withOpacity(0.05),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.bookmark_border, size: 18, color: Color(0xFFFF601F)),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Sauvegarder\nma recherche',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Color(0xFFFF601F),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            height: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Compact Search Bar
                      // - onTap: ouvre Airbnb-style (3 panneaux)
                      // - onFilterTap: ouvre bottom sheet avec TOUTES les options détaillées
                      AirbnbSearchBar(
                        onTap: _showSearchBottomSheet,
                        onFilterTap: () => showFilterBottomSheet(context),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
            
            // Results section
             filteredEvents.when(
                data: (paginatedData) {
                  final activities = paginatedData.activities;
                  
                  if (activities.isEmpty) {
                    // Trigger Smart AI Bubble
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                       ref.read(chatEngagementProvider.notifier).onSearchEmpty();
                    });

                    return SliverFillRemaining(
                      child: _EmptyResults(
                        hasFilters: filter.hasActiveFilters,
                        onClearFilters: () {
                          ref.read(eventFilterProvider.notifier).resetAll();
                        },
                        onCreateAlert: () => _showCreateAlertDialog(context),
                      ),
                    );
                  }
                  return SliverMainAxisGroup(
                    slivers: _buildResultsSlivers(
                      activities: activities,
                      hasMore: paginatedData.hasMore,
                      filter: filter,
                      context: context,
                      ref: ref,
                    ),
                  );
                },
                loading: () {
                   // If we have data (previous state), show it with loading at bottom
                   // But AsyncNotifier.when default handling often shows loading immediately entirely.
                   // We need to handle 'skipLoadingOnReload: true' or check if value exists.
                   
                   // Actually, if we are scrolling (pagination), we want to show the list AND the loader.
                   // AsyncValue.when(skipLoadingOnReload: true) is not available directly on the method but 
                   // we can check .hasValue.
                   
                   final previousData = filteredEvents.valueOrNull;
                   if (previousData != null && previousData.activities.isNotEmpty) {
                      return SliverMainAxisGroup(
                        slivers: _buildResultsSlivers(
                          activities: previousData.activities,
                          hasMore: true, // If loading, assumption is likely true or just show spinner
                          isLoadingMore: true,
                          filter: filter,
                          context: context,
                          ref: ref,
                        ),
                      );
                   }
                
                   return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF601F),
                      ),
                    ),
                  );
                },
                error: (error, _) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Erreur: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(filteredEventsProvider),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  List<Widget> _buildResultsSlivers({
    required List<dynamic> activities,
    required bool hasMore,
    bool isLoadingMore = false,
    required EventFilter filter,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return [
      // Results header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${activities.length} résultat${activities.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              // Sort button
              GestureDetector(
                onTap: () => _showSortOptions(context, ref, filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        _getSortLabel(filter.sortBy),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
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
      // Results grid
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.50,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => EventCard(
              activity: activities[index],
              isCompact: true,
            ),
            childCount: activities.length,
          ),
        ),
      ),
      
      // Loading indicator or "Alert Me" button
      if (hasMore || isLoadingMore) 
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(
                 color: Color(0xFFFF601F),
              ),
            ),
          ),
        )
      else
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: Column(
              children: [
                const Text(
                  "C'est tout pour le moment !",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showCreateAlertDialog(context),
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('M\'alerter des nouveautés'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Bottom padding
              ],
            ),
          ),
        ),
    ];
  }

  String _getSortLabel(SortOption sortBy) {
    switch (sortBy) {
      case SortOption.relevance:
        return 'Pertinence';
      case SortOption.dateAsc:
        return 'Date';
      case SortOption.dateDesc:
        return 'Date (desc)';
      case SortOption.priceAsc:
        return 'Prix';
      case SortOption.priceDesc:
        return 'Prix (desc)';
      case SortOption.popularity:
        return 'Popularité';
      case SortOption.distance:
        return 'Distance';
    }
  }

  void _showSortOptions(BuildContext context, WidgetRef ref, EventFilter filter) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Trier par',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _SortOption(
              label: 'Pertinence',
              icon: Icons.auto_awesome,
              isSelected: filter.sortBy == SortOption.relevance,
              onTap: () {
                filterNotifier.setSortOption(SortOption.relevance);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Date (plus proche)',
              icon: Icons.calendar_today,
              isSelected: filter.sortBy == SortOption.dateAsc,
              onTap: () {
                filterNotifier.setSortOption(SortOption.dateAsc);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Prix (croissant)',
              icon: Icons.arrow_upward,
              isSelected: filter.sortBy == SortOption.priceAsc,
              onTap: () {
                filterNotifier.setSortOption(SortOption.priceAsc);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Prix (décroissant)',
              icon: Icons.arrow_downward,
              isSelected: filter.sortBy == SortOption.priceDesc,
              onTap: () {
                filterNotifier.setSortOption(SortOption.priceDesc);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Popularité',
              icon: Icons.trending_up,
              isSelected: filter.sortBy == SortOption.popularity,
              onTap: () {
                filterNotifier.setSortOption(SortOption.popularity);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;
  final VoidCallback? onCreateAlert;

  const _EmptyResults({
    required this.hasFilters,
    required this.onClearFilters,
    this.onCreateAlert,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.search_off,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters
                  ? 'Aucun résultat pour ces filtres'
                  : 'Commencez votre recherche',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              hasFilters
                  ? 'Essayez de modifier ou supprimer certains filtres pour voir plus de résultats.'
                  : 'Utilisez la barre de recherche ci-dessus pour trouver des activités.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 24),
              // Créer une alerte
              if (onCreateAlert != null) ...[
                ElevatedButton.icon(
                  onPressed: onCreateAlert,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('M\'alerter des nouveaux événements'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A), // Bleu foncé
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              OutlinedButton.icon(
                onPressed: onClearFilters,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF601F),
                  side: const BorderSide(color: Color(0xFFFF601F)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.clear),
                label: const Text('Effacer les filtres'),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFFF601F) : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFFFF601F) : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFFFF601F))
          : null,
      onTap: onTap,
    );
  }
}
