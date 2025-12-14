import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../../../thematiques/presentation/providers/thematiques_provider.dart';
import '../../../home/presentation/providers/home_providers.dart';

/// Airbnb-style search bar widget
class AirbnbSearchBar extends ConsumerStatefulWidget {
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  const AirbnbSearchBar({
    super.key,
    this.isExpanded = false,
    this.onTap,
    this.onFilterTap,
  });

  @override
  ConsumerState<AirbnbSearchBar> createState() => _AirbnbSearchBarState();
}

class _AirbnbSearchBarState extends ConsumerState<AirbnbSearchBar> {
  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(eventFilterProvider);
    final activeChips = ref.watch(activeFilterChipsProvider);
    final filterOptions = ref.watch(filterOptionsProvider);

    return Column(
      children: [
        // Main search bar
        GestureDetector(
          onTap: widget.onTap ?? () => context.push('/search'),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Search icon
                Container(
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFFFF601F),
                    size: 24,
                  ),
                ),
                // Search text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getSearchTitle(filter),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getSearchSubtitle(filter, filterOptions.thematiques, filterOptions.categories),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                // Filter button
                GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: activeChips.isNotEmpty
                                  ? const Color(0xFFFF601F)
                                  : Colors.grey.withOpacity(0.3),
                              width: activeChips.isNotEmpty ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            size: 18,
                            color: activeChips.isNotEmpty
                                ? const Color(0xFFFF601F)
                                : Colors.grey[700],
                          ),
                        ),
                        if (activeChips.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF601F),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '${activeChips.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
        // Quick filter chips
        const SizedBox(height: 16),
        QuickFilterChips(),
      ],
    );
  }

  String _getSearchTitle(EventFilter filter) {
    if (filter.searchQuery.isNotEmpty) {
      return filter.searchQuery;
    }
    if (filter.cityName != null) {
      return filter.cityName!;
    }
    if (filter.latitude != null && filter.longitude != null) {
      return "Autour de moi";
    }
    return "Rechercher une activité";
  }

  String _getSearchSubtitle(EventFilter filter, List<dynamic> thematiques, List<EventCategoryInfo> categories) {
    final parts = <String>[];

    // 1. Où (Where) - Only if not already in Title
    bool locationInTitle = filter.cityName != null || (filter.latitude != null && filter.longitude != null);
    if (!locationInTitle) {
       // If no location filter is set, we can say "Où ?" or just skip it to keep it short. 
       // User asked to "Add Where".
       parts.add("Où ?");
    }

    // 2. Quand (When)
    if (filter.dateFilterLabel != null) {
      parts.add(filter.dateFilterLabel!);
    } else {
      parts.add("Quand ?");
    }

    // 3. Quoi (What)
    final whatParts = <String>[];
    
    // Categories
    for (final slug in filter.categoriesSlugs) {
      final match = categories.where((c) => c.slug == slug).firstOrNull;
      if (match != null) whatParts.add(match.name);
    }
    
    // Thematiques
    for (final slug in filter.thematiquesSlugs) {
      // thematiques list might be generic dynamic or DTO, casting safely
      // Assuming it has .slug and .name properties if it's the DTO list
      try {
        final match = thematiques.where((t) => t.slug == slug).firstOrNull;
        if (match != null) whatParts.add(match.name);
      } catch (e) {
        // Fallback if dynamic lookup fails
         whatParts.add(slug);
      }
    }

    // Audience / Format / Price (optional to add to "Quoi")
    if (filter.familyFriendly) whatParts.add("Famille");
    if (filter.accessiblePMR) whatParts.add("PMR");
    if (filter.onlineOnly) whatParts.add("En ligne");
    if (filter.onlyFree) whatParts.add("Gratuit");

    if (whatParts.isNotEmpty) {
       if (whatParts.length > 2) {
         parts.add("${whatParts.length} filtres");
       } else {
         parts.add(whatParts.join(", "));
       }
    } else {
      parts.add("Quoi ?");
    }

    return parts.join(" • ");
  }
}

/// Quick filter chips below search bar
class QuickFilterChips extends ConsumerWidget {
  const QuickFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Date filters
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
            label: "Demain",
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
            label: "Ce week-end",
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
            label: "Gratuit",
            isSelected: filter.onlyFree,
            icon: Icons.local_offer,
            onTap: () => filterNotifier.setOnlyFree(!filter.onlyFree),
          ),
          const SizedBox(width: 8),
          _QuickFilterChip(
            label: "Famille",
            isSelected: filter.familyFriendly,
            icon: Icons.family_restroom,
            onTap: () => filterNotifier.setFamilyFriendly(!filter.familyFriendly),
          ),
          const SizedBox(width: 8),
          _QuickFilterChip(
            label: "En ligne",
            isSelected: filter.onlineOnly,
            icon: Icons.videocam,
            onTap: () => filterNotifier.setOnlineOnly(!filter.onlineOnly),
          ),
        ],
      ),
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const _QuickFilterChip({
    required this.label,
    required this.isSelected,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF601F).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expanded search bar for the search screen
class ExpandedSearchBar extends ConsumerStatefulWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onCancel;

  const ExpandedSearchBar({
    super.key,
    this.onSearch,
    this.onCancel,
  });

  @override
  ConsumerState<ExpandedSearchBar> createState() => _ExpandedSearchBarState();
}

class _ExpandedSearchBarState extends ConsumerState<ExpandedSearchBar> {
  final _searchController = TextEditingController();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(eventFilterProvider);
    _searchController.text = filter.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        // We remove shadow/border as it might be inside a bottom sheet now
        // or keep it if we want the 'card' look.
        // Let's keep it subtle or remove if it conflicts.
        // Assuming user wants a clean sheet, but let's stick to existing style
        // but maybe lighter shadow?
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max, // Changed to max to fill space
        children: [
          // Global Search Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Recherchez une ville, une activité...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF601F)),
                filled: true,
                fillColor: const Color(0xFFF5F5F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          filterNotifier.setSearchQuery('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                filterNotifier.setSearchQuery(value);
                setState(() {});
              },
            ),
          ),
          
          // Tab bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _TabButton(
                  label: 'Où',
                  icon: Icons.location_on,
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: 'Quand',
                  icon: Icons.calendar_today,
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _TabButton(
                  label: 'Quoi',
                  icon: Icons.category,
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Content based on selected tab
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildTabContent(),
              ),
            ),
          ),
          // Search button
          Container(
            padding: EdgeInsets.only(
              left: 16, 
              right: 16, 
              top: 16, 
              bottom: MediaQuery.of(context).padding.bottom + 16
            ),
            child: Row(
              children: [
                // Clear filters
                if (filter.hasActiveFilters)
                  TextButton(
                    onPressed: () {
                       filterNotifier.resetAll();
                       _searchController.clear();
                    },
                    child: const Text(
                      'Effacer tout',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                // Search button
                ElevatedButton.icon(
                  onPressed: () {
                    // Search query is already updated via onChanged
                    widget.onSearch?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF601F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFFFF601F).withOpacity(0.4),
                  ),
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text(
                    'Rechercher',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const _WhereTab();
      case 1:
        return const _WhenTab();
      case 2:
        return const _WhatTab();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF601F).withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFFFF601F) : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFFF601F) : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Where" tab content
class _WhereTab extends ConsumerStatefulWidget {
  const _WhereTab();

  @override
  ConsumerState<_WhereTab> createState() => _WhereTabState();
}

class _WhereTabState extends ConsumerState<_WhereTab> {
  bool _isLoadingLocation = false;
  double _selectedRadius = 20.0;

  final List<double> _radiusOptions = [5, 10, 20, 50, 100];

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Les services de localisation sont désactivés');
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Permission de localisation refusée');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Permission de localisation refusée définitivement. Activez-la dans les paramètres.');
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Update filter with location
      final filterNotifier = ref.read(eventFilterProvider.notifier);
      filterNotifier.setLocation(position.latitude, position.longitude, _selectedRadius);
      filterNotifier.clearCity(); // Clear city when using geolocation
    } catch (e) {
      _showError('Impossible d\'obtenir votre position');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[400],
        ),
      );
    }
    setState(() => _isLoadingLocation = false);
  }

  void _updateRadius(double radius) {
    setState(() => _selectedRadius = radius);

    final filter = ref.read(eventFilterProvider);
    if (filter.latitude != null && filter.longitude != null) {
      // Update radius if location is already set
      ref.read(eventFilterProvider.notifier).setLocation(
        filter.latitude!,
        filter.longitude!,
        radius,
      );
    }
  }

  void _clearLocation() {
    ref.read(eventFilterProvider.notifier).clearLocation();
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final filter = ref.watch(eventFilterProvider);
    final hasLocation = filter.latitude != null && filter.longitude != null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Global Search is now above tabs

          // Geolocation button
          const Text(
            'Ma position',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),

          // Geolocation button
          GestureDetector(
            onTap: _isLoadingLocation ? null : _getCurrentLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: hasLocation ? const Color(0xFFFF601F) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasLocation ? const Color(0xFFFF601F) : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoadingLocation)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    )
                  else
                    Icon(
                      Icons.my_location,
                      size: 18,
                      color: hasLocation ? Colors.white : const Color(0xFFFF601F),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    hasLocation
                        ? 'Autour de moi (${filter.radiusKm.toInt()} km)'
                        : 'Autour de moi',
                    style: TextStyle(
                      color: hasLocation ? Colors.white : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasLocation) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _clearLocation,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Radius slider (only show when location is active or loading)
          if (hasLocation || _isLoadingLocation) ...[
            const SizedBox(height: 16),
            const Text(
              'Rayon de recherche',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _radiusOptions.map((radius) {
                final isSelected = _selectedRadius == radius ||
                    (hasLocation && filter.radiusKm == radius);
                return GestureDetector(
                  onTap: () => _updateRadius(radius),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF601F).withOpacity(0.15) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '${radius.toInt()} km',
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFFF601F) : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 20),

          // Popular cities
          const Text(
            'Villes populaires',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CityChip(name: 'Paris', slug: 'paris'),
              _CityChip(name: 'Lyon', slug: 'lyon'),
              _CityChip(name: 'Marseille', slug: 'marseille'),
              _CityChip(name: 'Bordeaux', slug: 'bordeaux'),
              _CityChip(name: 'Toulouse', slug: 'toulouse'),
              _CityChip(name: 'Nantes', slug: 'nantes'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CityChip extends ConsumerWidget {
  final String name;
  final String slug;

  const _CityChip({required this.name, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final isSelected = filter.citySlug == slug;
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          filterNotifier.clearCity();
        } else {
          filterNotifier.setCity(slug, name);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// "When" tab content
class _WhenTab extends ConsumerWidget {
  const _WhenTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez une période',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DateFilterChip(
                label: "Aujourd'hui",
                type: DateFilterType.today,
                isSelected: filter.dateFilterType == DateFilterType.today,
                onTap: () => filterNotifier.setDateFilter(DateFilterType.today),
              ),
              _DateFilterChip(
                label: 'Demain',
                type: DateFilterType.tomorrow,
                isSelected: filter.dateFilterType == DateFilterType.tomorrow,
                onTap: () => filterNotifier.setDateFilter(DateFilterType.tomorrow),
              ),
              _DateFilterChip(
                label: 'Cette semaine',
                type: DateFilterType.thisWeek,
                isSelected: filter.dateFilterType == DateFilterType.thisWeek,
                onTap: () => filterNotifier.setDateFilter(DateFilterType.thisWeek),
              ),
              _DateFilterChip(
                label: 'Ce week-end',
                type: DateFilterType.thisWeekend,
                isSelected: filter.dateFilterType == DateFilterType.thisWeekend,
                onTap: () => filterNotifier.setDateFilter(DateFilterType.thisWeekend),
              ),
              _DateFilterChip(
                label: 'Ce mois',
                type: DateFilterType.thisMonth,
                isSelected: filter.dateFilterType == DateFilterType.thisMonth,
                onTap: () => filterNotifier.setDateFilter(DateFilterType.thisMonth),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Custom date picker button
          OutlinedButton.icon(
            onPressed: () => _showDateRangePicker(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF601F),
              side: const BorderSide(color: Color(0xFFFF601F)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.date_range, size: 18),
            label: const Text('Dates personnalisées'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF601F),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      filterNotifier.setCustomDateRange(picked.start, picked.end);
    }
  }
}

class _DateFilterChip extends StatelessWidget {
  final String label;
  final DateFilterType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateFilterChip({
    required this.label,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// "What" tab content
class _WhatTab extends ConsumerWidget {
  const _WhatTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final filterOptions = ref.watch(filterOptionsProvider);
    final thematiques = ref.watch(thematiquesProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          if (filterOptions.categories.isNotEmpty) ...[
            const Text(
              'Catégories',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 12),
            _CategoriesFilter(
              categories: filterOptions.categories,
              selectedSlugs: filter.categoriesSlugs,
              onChanged: (slug) => filterNotifier.toggleCategory(slug),
            ),
            const SizedBox(height: 24),
          ],

          // Thematiques
          const Text(
            'Thématiques',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          thematiques.when(
            data: (data) {
              if (data.isEmpty) return const Text('Aucune thématique disponible');
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.map((t) {
                  return _ThematiqueChip(
                    name: t.name,
                    slug: t.slug,
                    // Basic icon mapping or default
                    icon: Icons.label_outline, 
                  );
                }).toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Erreur de chargement'),
          ),
          const SizedBox(height: 24),

          // Price filter
          const Text(
            'Budget',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _PriceChip(
                label: 'Gratuit',
                isSelected: filter.onlyFree,
                onTap: () => filterNotifier.setOnlyFree(!filter.onlyFree),
              ),
              const SizedBox(width: 8),
              _PriceChip(
                label: 'Payant',
                isSelected: filter.priceFilterType == PriceFilterType.paid,
                onTap: () => filterNotifier.setPriceFilter(PriceFilterType.paid),
              ),
              const SizedBox(width: 8),
              _PriceChip(
                label: 'Tous',
                isSelected: filter.priceFilterType == null && !filter.onlyFree,
                onTap: () => filterNotifier.clearPriceFilter(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Audience
          const Text(
            'Public',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterToggleChip(
                label: 'En famille',
                icon: Icons.family_restroom,
                isSelected: filter.familyFriendly,
                onTap: () => filterNotifier.setFamilyFriendly(!filter.familyFriendly),
              ),
              _FilterToggleChip(
                label: 'Accessible PMR',
                icon: Icons.accessible,
                isSelected: filter.accessiblePMR,
                onTap: () => filterNotifier.setAccessiblePMR(!filter.accessiblePMR),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Format
          const Text(
            'Format',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterToggleChip(
                label: 'En ligne',
                icon: Icons.videocam,
                isSelected: filter.onlineOnly,
                onTap: () => filterNotifier.setOnlineOnly(!filter.onlineOnly),
              ),
              _FilterToggleChip(
                label: 'En présentiel',
                icon: Icons.location_on,
                isSelected: filter.inPersonOnly,
                onTap: () => filterNotifier.setInPersonOnly(!filter.inPersonOnly),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoriesFilter extends StatefulWidget {
  final List<EventCategoryInfo> categories;
  final List<String> selectedSlugs;
  final ValueChanged<String> onChanged;

  const _CategoriesFilter({
    required this.categories,
    required this.selectedSlugs,
    required this.onChanged,
  });

  @override
  State<_CategoriesFilter> createState() => _CategoriesFilterState();
}

class _CategoriesFilterState extends State<_CategoriesFilter> {
  bool _isExpanded = false;
  static const int _initialLimit = 8;

  @override
  Widget build(BuildContext context) {
    final showAll = _isExpanded || widget.categories.length <= _initialLimit;
    final displayedCategories = showAll 
        ? widget.categories 
        : widget.categories.take(_initialLimit).toList();
    final hiddenCount = widget.categories.length - _initialLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displayedCategories.map((c) {
            final isSelected = widget.selectedSlugs.contains(c.slug);
            
            // Icon mapping
            IconData iconData = Icons.label_outline;
             if (c.icon != null) {
               if (c.icon!.contains('music')) iconData = Icons.music_note;
               else if (c.icon!.contains('movie')) iconData = Icons.movie;
               else if (c.icon!.contains('sport')) iconData = Icons.sports;
               else if (c.icon!.contains('restaurant')) iconData = Icons.restaurant;
               else if (c.icon!.contains('child')) iconData = Icons.child_care;
               else if (c.icon!.contains('palette')) iconData = Icons.palette;
               else if (c.icon!.contains('school')) iconData = Icons.school;
               else if (c.icon!.contains('book')) iconData = Icons.menu_book;
               else if (c.icon!.contains('park')) iconData = Icons.park;
               else if (c.icon!.contains('computer')) iconData = Icons.computer;
               else if (c.icon!.contains('castle')) iconData = Icons.castle;
               else if (c.icon!.contains('fitness')) iconData = Icons.fitness_center;
             }

            return GestureDetector(
              onTap: () => widget.onChanged(c.slug),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF601F) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      c.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.categories.length > _initialLimit) ...[
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Voir moins' : 'Voir plus ($hiddenCount)',
                    style: const TextStyle(
                      color: Color(0xFFFF601F),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFFFF601F),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FilterToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterToggleChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThematiqueChip extends ConsumerWidget {
  final String name;
  final String slug;
  final IconData icon;

  const _ThematiqueChip({
    required this.name,
    required this.slug,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final isSelected = filter.thematiquesSlugs.contains(slug);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return GestureDetector(
      onTap: () => filterNotifier.toggleThematique(slug),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
