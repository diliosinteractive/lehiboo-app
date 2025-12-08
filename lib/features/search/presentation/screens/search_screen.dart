import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../widgets/airbnb_search_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/active_filter_chips.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? categorySlug;
  final String? city;

  const SearchScreen({
    super.key,
    this.categorySlug,
    this.city,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  bool _showExpandedSearch = true;

  @override
  void initState() {
    super.initState();
    // Initialize filters if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterNotifier = ref.read(eventFilterProvider.notifier);
      if (widget.categorySlug != null || widget.city != null) {
        filterNotifier.resetAll();
        // If we have initial params, we probably want to see results immediately, 
        // effectively treating this as a results page, so maybe start collapsed?
        // But the user requested "use this module", which implies the tabs interface.
        // Let's keep it expanded by default unless we decide otherwise.
        
        // Actually, if I clicked a specific category, I might expect to see results for it.
        // But if I want to "Use the module", I probably want to tweak filters?
        // Let's stick to simple init for now.
      }
      
      if (widget.categorySlug != null) {
        filterNotifier.addThematique(widget.categorySlug!);
        // If pre-filtered, maybe we don't start expanded?
        setState(() => _showExpandedSearch = false);
      }
      if (widget.city != null) {
        final cityName = widget.city![0].toUpperCase() + widget.city!.substring(1);
        filterNotifier.setCity(widget.city!, cityName);
        setState(() => _showExpandedSearch = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = ref.watch(filteredEventsProvider);
    final activeChips = ref.watch(activeFilterChipsProvider);
    final filter = ref.watch(eventFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      'Rechercher',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Toggle search bar expansion
                  IconButton(
                    onPressed: () {
                      setState(() => _showExpandedSearch = !_showExpandedSearch);
                    },
                    icon: Icon(
                      _showExpandedSearch ? Icons.search_off : Icons.search,
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded search bar
            if (_showExpandedSearch)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ExpandedSearchBar(
                  onSearch: () {
                    setState(() => _showExpandedSearch = false);
                  },
                ),
              ),
            // Active filters chips
            if (!_showExpandedSearch && activeChips.isNotEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 12),
                child: const HorizontalActiveFilterChips(),
              ),
            // Results section
            Expanded(
              child: filteredEvents.when(
                data: (activities) {
                  if (activities.isEmpty) {
                    return _EmptyResults(
                      hasFilters: filter.hasActiveFilters,
                      onClearFilters: () {
                        ref.read(eventFilterProvider.notifier).resetAll();
                      },
                    );
                  }
                  return _ResultsGrid(
                    activities: activities,
                    filter: filter,
                    onFilterTap: () => showFilterBottomSheet(context),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF6B35),
                  ),
                ),
                error: (error, _) => Center(
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
      // Floating filter button
      floatingActionButton: !_showExpandedSearch
          ? FloatingActionButton.extended(
              onPressed: () => showFilterBottomSheet(context),
              backgroundColor: const Color(0xFF222222),
              icon: const Icon(Icons.tune, color: Colors.white),
              label: Text(
                activeChips.isEmpty ? 'Filtres' : 'Filtres (${activeChips.length})',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const _EmptyResults({
    required this.hasFilters,
    required this.onClearFilters,
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
              OutlinedButton.icon(
                onPressed: onClearFilters,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF6B35),
                  side: const BorderSide(color: Color(0xFFFF6B35)),
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

class _ResultsGrid extends ConsumerWidget {
  final List<dynamic> activities;
  final EventFilter filter;
  final VoidCallback onFilterTap;

  const _ResultsGrid({
    required this.activities,
    required this.filter,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
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
                  onTap: () => _showSortOptions(context, ref),
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
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
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

  void _showSortOptions(BuildContext context, WidgetRef ref) {
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
        color: isSelected ? const Color(0xFFFF6B35) : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFFFF6B35) : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFFFF6B35))
          : null,
      onTap: onTap,
    );
  }
}
