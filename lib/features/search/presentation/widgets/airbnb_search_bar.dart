import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../providers/filter_provider.dart';
import '../utils/search_l10n.dart';
import '../../domain/models/event_filter.dart';
import '../../../events/data/models/event_reference_data_dto.dart';

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
    final referenceData = ref.watch(eventReferenceDataProvider).valueOrNull;

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
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
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
                    color: HbColors.brandPrimary,
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
                        _getSearchTitle(context, filter),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: HbColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getSearchSubtitle(
                          context,
                          filter,
                          referenceData?.categories ?? const [],
                        ),
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
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                // Filter button
                GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: activeChips.isNotEmpty
                                  ? HbColors.brandPrimary
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: activeChips.isNotEmpty ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            size: 18,
                            color: activeChips.isNotEmpty
                                ? HbColors.brandPrimary
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
                                color: HbColors.brandPrimary,
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
        const QuickFilterChips(),
      ],
    );
  }

  String _getSearchTitle(BuildContext context, EventFilter filter) {
    if (filter.searchQuery.isNotEmpty) {
      return filter.searchQuery;
    }
    if (filter.cityName != null) {
      return filter.cityName!;
    }
    if (filter.latitude != null && filter.longitude != null) {
      return context.l10n.searchAroundMe;
    }
    return context.l10n.searchSearchActivityTitle;
  }

  String _getSearchSubtitle(BuildContext context, EventFilter filter,
      List<EventReferenceCategoryDto> categories) {
    final parts = <String>[];

    // 1. Où (Where) - Only if not already in Title
    bool locationInTitle = filter.cityName != null ||
        (filter.latitude != null && filter.longitude != null);
    if (!locationInTitle) {
      // If no location filter is set, we can say "Où ?" or just skip it to keep it short.
      // User asked to "Add Where".
      parts.add(context.l10n.homeSearchWhere);
    }

    // 2. Quand (When)
    final dateLabel = context.searchDateFilterLabelOrNull(filter);
    if (dateLabel != null) {
      parts.add(dateLabel);
    } else {
      parts.add(context.l10n.homeSearchWhen);
    }

    // 3. Quoi (What)
    final whatParts = <String>[];

    // Categories
    for (final slug in filter.categoriesSlugs) {
      final categoryName = _findReferenceCategoryName(categories, slug);
      if (categoryName != null) whatParts.add(categoryName);
    }

    if (whatParts.isNotEmpty) {
      if (whatParts.length > 2) {
        parts.add(context.l10n.homeSearchCategoryCount(whatParts.length));
      } else {
        parts.add(whatParts.join(", "));
      }
    } else {
      parts.add(context.l10n.homeSearchWhat);
    }

    return parts.join(" • ");
  }
}

String? _findReferenceCategoryName(
  List<EventReferenceCategoryDto> categories,
  String slug,
) {
  for (final category in categories) {
    if (category.slug == slug) return category.name;
    for (final child in category.children) {
      if (child.slug == slug) return child.name;
    }
  }
  return null;
}

List<EventReferenceCategoryDto> _flattenReferenceCategories(
  List<EventReferenceCategoryDto> categories,
) {
  return [
    for (final category in categories) ...[
      category,
      ...category.children,
    ],
  ];
}

const _fallbackPublicFilters = [
  EventReferencePublicFilterDto(
    key: 'family',
    label: 'En famille',
    param: 'public_filters',
    value: 'family',
  ),
  EventReferencePublicFilterDto(
    key: 'pmr',
    label: 'Accessible PMR',
    param: 'public_filters',
    value: 'pmr',
  ),
  EventReferencePublicFilterDto(
    key: 'group',
    label: 'En groupe',
    param: 'public_filters',
    value: 'group',
  ),
  EventReferencePublicFilterDto(
    key: 'school',
    label: 'Groupe scolaire',
    param: 'public_filters',
    value: 'school',
  ),
  EventReferencePublicFilterDto(
    key: 'professional',
    label: 'Professionnel',
    param: 'public_filters',
    value: 'professional',
  ),
];

List<EventReferencePublicFilterDto> _publicFilterOptions(
  List<EventReferencePublicFilterDto> filters,
) {
  final options = filters.where((filter) {
    return publicAudienceFilterKeys.contains(_publicFilterValue(filter));
  }).toList();
  if (options.isEmpty) return _fallbackPublicFilters;

  final order = {
    for (var i = 0; i < publicAudienceFilterKeys.length; i++)
      publicAudienceFilterKeys.elementAt(i): i,
  };
  options.sort((a, b) {
    final aOrder =
        order[_publicFilterValue(a)] ?? publicAudienceFilterKeys.length;
    final bOrder =
        order[_publicFilterValue(b)] ?? publicAudienceFilterKeys.length;
    return aOrder.compareTo(bOrder);
  });

  return options;
}

String _publicFilterValue(EventReferencePublicFilterDto filter) {
  return filter.value.isNotEmpty ? filter.value : filter.key;
}

IconData _publicFilterIcon(String key) {
  switch (key) {
    case 'family':
      return Icons.family_restroom;
    case 'pmr':
      return Icons.accessible;
    case 'group':
      return Icons.groups;
    case 'school':
      return Icons.school;
    case 'professional':
      return Icons.business_center;
    default:
      return Icons.people;
  }
}

String _publicFilterLabel(
  BuildContext context,
  EventReferencePublicFilterDto filter,
) {
  return switch (_publicFilterValue(filter)) {
    'family' => context.l10n.searchFamilyTitle,
    'pmr' => context.l10n.searchAccessiblePmr,
    'group' => context.l10n.searchAudienceGroup,
    'school' => context.l10n.searchAudienceSchoolGroup,
    'professional' => context.l10n.searchAudienceProfessional,
    _ => filter.label,
  };
}

/// Quick filter chips below search bar
class QuickFilterChips extends ConsumerWidget {
  const QuickFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final selectedPublicFilters =
        selectedPublicAudienceFilters(filter.targetAudienceSlugs);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Date filters
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
            label: context.l10n.commonThisWeekend,
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
            label: context.l10n.commonFree,
            isSelected: filter.onlyFree,
            icon: Icons.local_offer,
            onTap: () => filterNotifier.setOnlyFree(!filter.onlyFree),
          ),
          const SizedBox(width: 8),
          _QuickFilterChip(
            label: context.l10n.searchFamilyTitle,
            isSelected: selectedPublicFilters.contains('family'),
            icon: Icons.family_restroom,
            onTap: () => filterNotifier.applyFilters(
              filter.copyWith(
                targetAudienceSlugs:
                    _toggleSlug(selectedPublicFilters, 'family'),
                familyFriendly: false,
                accessiblePMR: false,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _QuickFilterChip(
            label: context.l10n.searchOnline,
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
          color: isSelected ? HbColors.brandPrimary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? HbColors.brandPrimary
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HbColors.brandPrimary.withValues(alpha: 0.3),
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
            color: Colors.black.withValues(alpha: 0.05),
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
                hintText: context.l10n.searchHintEventOrOrganization,
                prefixIcon:
                    const Icon(Icons.search, color: HbColors.brandPrimary),
                filled: true,
                fillColor: HbColors.surfaceInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  label: context.l10n.homeSearchWhere
                      .replaceAll(' ?', '')
                      .replaceAll('?', ''),
                  icon: Icons.location_on,
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: context.l10n.homeSearchWhen
                      .replaceAll(' ?', '')
                      .replaceAll('?', ''),
                  icon: Icons.calendar_today,
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _TabButton(
                  label: context.l10n.homeSearchWhat
                      .replaceAll(' ?', '')
                      .replaceAll('?', ''),
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
                bottom: MediaQuery.of(context).padding.bottom + 16),
            child: Row(
              children: [
                // Clear filters
                if (filter.hasActiveFilters)
                  TextButton(
                    onPressed: () {
                      filterNotifier.resetAll();
                      _searchController.clear();
                    },
                    child: Text(
                      context.l10n.searchClearFilters,
                      style: const TextStyle(
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
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: HbColors.brandPrimary.withValues(alpha: 0.4),
                  ),
                  icon: const Icon(Icons.search, size: 20),
                  label: Text(
                    context.l10n.searchAction,
                    style: const TextStyle(
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
            color: isSelected
                ? HbColors.brandPrimary.withValues(alpha: 0.1)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? HbColors.brandPrimary : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? HbColors.brandPrimary : Colors.grey[700],
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
    final locationDisabled = context.l10n.searchLocationDisabled;
    final permissionDenied = context.l10n.searchPermissionDenied;
    final locationSettingsRequired =
        context.l10n.searchLocationSettingsRequired;
    final locationNotFound = context.l10n.searchLocationNotFound;

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError(locationDisabled);
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError(permissionDenied);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError(locationSettingsRequired);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      // Update filter with location
      final filterNotifier = ref.read(eventFilterProvider.notifier);
      filterNotifier.setLocation(
          position.latitude, position.longitude, _selectedRadius);
      filterNotifier.clearCity(); // Clear city when using geolocation
    } catch (e) {
      _showError(locationNotFound);
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
    final filter = ref.watch(eventFilterProvider);
    final hasLocation = filter.latitude != null && filter.longitude != null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Global Search is now above tabs

          // Geolocation button
          Text(
            context.l10n.searchMyPosition,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: HbColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Geolocation button
          GestureDetector(
            onTap: _isLoadingLocation ? null : _getCurrentLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: hasLocation ? HbColors.brandPrimary : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasLocation
                      ? HbColors.brandPrimary
                      : Colors.grey.shade300,
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
                      color: hasLocation ? Colors.white : HbColors.brandPrimary,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    hasLocation
                        ? context.searchAroundMeLabel(filter.radiusKm)
                        : context.l10n.searchAroundMe,
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
            Text(
              context.l10n.searchRadiusLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: HbColors.textTertiary,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? HbColors.brandPrimary.withValues(alpha: 0.15)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? HbColors.brandPrimary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '${radius.toInt()} km',
                      style: TextStyle(
                        color: isSelected
                            ? HbColors.brandPrimary
                            : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
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
          Text(
            context.l10n.searchPopularCities,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: HbColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
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
          color: isSelected ? HbColors.brandPrimary : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
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
          Text(
            context.l10n.searchChoosePeriod,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: HbColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DateFilterChip(
                label: context.l10n.commonToday,
                type: DateFilterType.today,
                isSelected: filter.dateFilterType == DateFilterType.today,
                onTap: () => filterNotifier.setDateFilter(DateFilterType.today),
              ),
              _DateFilterChip(
                label: context.l10n.commonTomorrow,
                type: DateFilterType.tomorrow,
                isSelected: filter.dateFilterType == DateFilterType.tomorrow,
                onTap: () =>
                    filterNotifier.setDateFilter(DateFilterType.tomorrow),
              ),
              _DateFilterChip(
                label: context.l10n.searchDateThisWeek,
                type: DateFilterType.thisWeek,
                isSelected: filter.dateFilterType == DateFilterType.thisWeek,
                onTap: () =>
                    filterNotifier.setDateFilter(DateFilterType.thisWeek),
              ),
              _DateFilterChip(
                label: context.l10n.commonThisWeekend,
                type: DateFilterType.thisWeekend,
                isSelected: filter.dateFilterType == DateFilterType.thisWeekend,
                onTap: () =>
                    filterNotifier.setDateFilter(DateFilterType.thisWeekend),
              ),
              _DateFilterChip(
                label: context.l10n.searchDateThisMonth,
                type: DateFilterType.thisMonth,
                isSelected: filter.dateFilterType == DateFilterType.thisMonth,
                onTap: () =>
                    filterNotifier.setDateFilter(DateFilterType.thisMonth),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Custom date picker button
          OutlinedButton.icon(
            onPressed: () => _showDateRangePicker(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: HbColors.brandPrimary,
              side: const BorderSide(color: HbColors.brandPrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.date_range, size: 18),
            label: Text(context.l10n.searchDateCustom),
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
              primary: HbColors.brandPrimary,
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
          color: isSelected ? HbColors.brandPrimary : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
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
    final referenceData = ref.watch(eventReferenceDataProvider);

    return referenceData.when(
      data: (data) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories
            if (data.categories.isNotEmpty) ...[
              Text(
                context.l10n.searchSectionCategories,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: HbColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _CategoriesFilter(
                categories: _flattenReferenceCategories(data.categories),
                selectedSlugs: filter.categoriesSlugs,
                onChanged: (slug) => filterNotifier.toggleCategory(slug),
              ),
              const SizedBox(height: 24),
            ],

            // Thematiques
            Text(
              context.l10n.searchSectionThemes,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: HbColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            if (data.themes.isEmpty)
              Text(context.l10n.searchNoThemeAvailable)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.themes.map((theme) {
                  return _ThematiqueChip(
                    name: theme.name,
                    slug: theme.slug,
                    icon: Icons.label_outline,
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            // Price filter
            Text(
              context.l10n.searchSectionBudget,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: HbColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _PriceChip(
                  label: context.l10n.commonFree,
                  isSelected: filter.onlyFree,
                  onTap: () => filterNotifier.setOnlyFree(!filter.onlyFree),
                ),
                const SizedBox(width: 8),
                _PriceChip(
                  label: context.l10n.searchPricePaid,
                  isSelected: filter.priceFilterType == PriceFilterType.paid,
                  onTap: () =>
                      filterNotifier.setPriceFilter(PriceFilterType.paid),
                ),
                const SizedBox(width: 8),
                _PriceChip(
                  label: context.l10n.searchAll,
                  isSelected:
                      filter.priceFilterType == null && !filter.onlyFree,
                  onTap: () => filterNotifier.clearPriceFilter(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Audience
            Text(
              context.l10n.searchSectionAudience,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: HbColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _PublicFilterChips(
              filters: data.publicFilters,
              selectedKeys: filter.targetAudienceSlugs,
              onChanged: (keys) => filterNotifier.applyFilters(
                filter.copyWith(
                  targetAudienceSlugs: keys,
                  familyFriendly: false,
                  accessiblePMR: false,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Format
            Text(
              context.l10n.searchSectionFormat,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: HbColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterToggleChip(
                  label: context.l10n.searchOnline,
                  icon: Icons.videocam,
                  isSelected: filter.onlineOnly,
                  onTap: () => filterNotifier.setOnlineOnly(!filter.onlineOnly),
                ),
                _FilterToggleChip(
                  label: context.l10n.searchInPerson,
                  icon: Icons.location_on,
                  isSelected: filter.inPersonOnly,
                  onTap: () =>
                      filterNotifier.setInPersonOnly(!filter.inPersonOnly),
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HbColors.brandPrimary,
          ),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l10n.searchLoadError),
      ),
    );
  }
}

class _CategoriesFilter extends StatefulWidget {
  final List<EventReferenceCategoryDto> categories;
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
              if (c.icon!.contains('music')) {
                iconData = Icons.music_note;
              } else if (c.icon!.contains('movie')) {
                iconData = Icons.movie;
              } else if (c.icon!.contains('sport')) {
                iconData = Icons.sports;
              } else if (c.icon!.contains('restaurant')) {
                iconData = Icons.restaurant;
              } else if (c.icon!.contains('child')) {
                iconData = Icons.child_care;
              } else if (c.icon!.contains('palette')) {
                iconData = Icons.palette;
              } else if (c.icon!.contains('school')) {
                iconData = Icons.school;
              } else if (c.icon!.contains('book')) {
                iconData = Icons.menu_book;
              } else if (c.icon!.contains('park')) {
                iconData = Icons.park;
              } else if (c.icon!.contains('computer')) {
                iconData = Icons.computer;
              } else if (c.icon!.contains('castle')) {
                iconData = Icons.castle;
              } else if (c.icon!.contains('fitness')) {
                iconData = Icons.fitness_center;
              }
            }

            return GestureDetector(
              onTap: () => widget.onChanged(c.slug),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? HbColors.brandPrimary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? HbColors.brandPrimary
                        : Colors.grey.shade300,
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
                    _isExpanded
                        ? context.l10n.searchShowLess
                        : context.l10n.searchShowMoreWithCount(hiddenCount),
                    style: const TextStyle(
                      color: HbColors.brandPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: HbColors.brandPrimary,
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
          color: isSelected ? HbColors.brandPrimary : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
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

class _PublicFilterChips extends StatelessWidget {
  final List<EventReferencePublicFilterDto> filters;
  final List<String> selectedKeys;
  final ValueChanged<List<String>> onChanged;

  const _PublicFilterChips({
    required this.filters,
    required this.selectedKeys,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = _publicFilterOptions(filters);
    final selectedPublicKeys = selectedPublicAudienceFilters(selectedKeys);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((filter) {
        final value = _publicFilterValue(filter);
        final isSelected = selectedPublicKeys.contains(value);

        return _FilterToggleChip(
          label: _publicFilterLabel(context, filter),
          icon: _publicFilterIcon(value),
          isSelected: isSelected,
          onTap: () => onChanged(_toggleSlug(selectedPublicKeys, value)),
        );
      }).toList(),
    );
  }
}

List<String> _toggleSlug(List<String> selectedSlugs, String slug) {
  final next = List<String>.from(selectedSlugs);
  if (next.contains(slug)) {
    next.remove(slug);
  } else {
    next.add(slug);
  }
  return next;
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
          color: isSelected ? HbColors.brandPrimary : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
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
          color: isSelected ? HbColors.brandPrimary : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
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
