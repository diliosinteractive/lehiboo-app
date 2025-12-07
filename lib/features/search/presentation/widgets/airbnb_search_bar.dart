import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';

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
                    color: Color(0xFFFF6B35),
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
                        _getSearchSubtitle(filter),
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
                                  ? const Color(0xFFFF6B35)
                                  : Colors.grey.withOpacity(0.3),
                              width: activeChips.isNotEmpty ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            size: 18,
                            color: activeChips.isNotEmpty
                                ? const Color(0xFFFF6B35)
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
                                color: Color(0xFFFF6B35),
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
    return "Rechercher une activité";
  }

  String _getSearchSubtitle(EventFilter filter) {
    final parts = <String>[];

    if (filter.dateFilterLabel != null) {
      parts.add(filter.dateFilterLabel!);
    } else {
      parts.add("Quand ?");
    }

    if (filter.thematiquesSlugs.isNotEmpty) {
      parts.add("${filter.thematiquesSlugs.length} thématique${filter.thematiquesSlugs.length > 1 ? 's' : ''}");
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
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tab bar
          Container(
            padding: const EdgeInsets.all(8),
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
          // Content based on selected tab
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildTabContent(),
          ),
          // Search button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Clear filters
                if (filter.hasActiveFilters)
                  TextButton(
                    onPressed: () => filterNotifier.resetAll(),
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
                    filterNotifier.setSearchQuery(_searchController.text);
                    widget.onSearch?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text(
                    'Rechercher',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
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
        return _WhereTab(searchController: _searchController);
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
            color: isSelected ? const Color(0xFFFF6B35).withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFFFF6B35) : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[700],
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
  final TextEditingController searchController;

  const _WhereTab({required this.searchController});

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
          // Search input
          TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: 'Recherchez une ville, une activité...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (value) => filterNotifier.setSearchQuery(value),
          ),
          const SizedBox(height: 16),

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
                color: hasLocation ? const Color(0xFFFF6B35) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasLocation ? const Color(0xFFFF6B35) : Colors.grey.shade300,
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
                      color: hasLocation ? Colors.white : const Color(0xFFFF6B35),
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
                      color: isSelected ? const Color(0xFFFF6B35).withOpacity(0.15) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '${radius.toInt()} km',
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[700],
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
          color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
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
              foregroundColor: const Color(0xFFFF6B35),
              side: const BorderSide(color: Color(0xFFFF6B35)),
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
              primary: Color(0xFFFF6B35),
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
          color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
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

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Type d\'activité',
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
              _ThematiqueChip(name: 'Concert', slug: 'concert', icon: Icons.music_note),
              _ThematiqueChip(name: 'Spectacle', slug: 'spectacle', icon: Icons.theater_comedy),
              _ThematiqueChip(name: 'Sport', slug: 'sport', icon: Icons.sports),
              _ThematiqueChip(name: 'Atelier', slug: 'atelier', icon: Icons.build),
              _ThematiqueChip(name: 'Exposition', slug: 'exposition', icon: Icons.museum),
              _ThematiqueChip(name: 'Festival', slug: 'festival', icon: Icons.celebration),
              _ThematiqueChip(name: 'Conférence', slug: 'conference', icon: Icons.mic),
              _ThematiqueChip(name: 'Gastronomie', slug: 'gastronomie', icon: Icons.restaurant),
            ],
          ),
          const SizedBox(height: 20),
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
        ],
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
          color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
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
          color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
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
