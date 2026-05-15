import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../providers/filter_provider.dart';
import '../utils/search_l10n.dart';
import '../../domain/models/event_filter.dart';
import '../../../events/data/models/event_reference_data_dto.dart';
import '../../../events/data/models/search_suggestions_dto.dart';
import '../../../home/presentation/providers/home_providers.dart';
import 'filter_shared_components.dart';

/// Airbnb-style full screen search page with accordion panels
///
/// Design inspiré directement des screenshots Airbnb :
/// - Page plein écran SANS bottom nav bar (expérience modale immersive)
/// - Header avec titre "Recherche" et bouton fermer
/// - Volets avec animations fluides alignés sur le tiroir web /events
/// - Scroll automatique vers le bloc ouvert
/// - Footer fixe avec "Tout effacer" et "Rechercher"
class AirbnbSearchSheet extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onSearch;

  const AirbnbSearchSheet({
    super.key,
    this.onClose,
    this.onSearch,
  });

  /// Show the search sheet as a full-screen modal (hides bottom nav)
  static Future<void> show(BuildContext context) {
    // Hide system UI overlays for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return AirbnbSearchSheet(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSearch: () {
              Navigator.of(context).pop();
              context.push('/search');
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  ConsumerState<AirbnbSearchSheet> createState() => _AirbnbSearchSheetState();
}

class _AirbnbSearchSheetState extends ConsumerState<AirbnbSearchSheet>
    with TickerProviderStateMixin {
  static const int _wherePanel = 0;
  static const int _whenPanel = 1;
  static const int _whatPanel = 2;
  static const int _searchPanel = 3;
  static const int _audiencePanel = 4;
  static const int _pricePanel = 5;
  static const int _availabilityPanel = 6;
  static const int _refinePanel = 7;
  static const int _panelCount = 8;

  int _expandedPanel = _wherePanel;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final List<GlobalKey> _panelKeys =
      List<GlobalKey>.generate(_panelCount, (_) => GlobalKey());

  late AnimationController _animationController;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(eventFilterProvider).searchQuery;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _expandPanel(int index) {
    setState(() => _expandedPanel = index);

    // Scroll vers le panel ouvert après l'animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _panelKeys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      }
    });
  }

  int get _activeFilterCount {
    final filter = ref.read(eventFilterProvider);
    final publicFilters =
        selectedPublicAudienceFilters(filter.targetAudienceSlugs);
    int count = 0;
    if (filter.searchQuery.isNotEmpty) count++;
    if (filter.dateFilterType != null || filter.startDate != null) count++;
    if (filter.citySlug != null) count++;
    if (filter.latitude != null) count++;
    count += filter.categoriesSlugs.length;
    count += filter.targetAudienceSlugs.length;
    count += filter.tagsSlugs.length;
    count += filter.thematiquesSlugs.length;
    count += filter.specialEventSlugs.length;
    count += filter.emotionSlugs.length;
    if (filter.eventTagSlug != null) count++;
    if (filter.availableOnly) count++;
    if (filter.locationType != null) count++;
    if (filter.priceFilterType != null && !filter.onlyFree) count++;
    if (filter.familyFriendly && !publicFilters.contains('family')) count++;
    if (filter.onlyFree) count++;
    if (filter.accessiblePMR && !publicFilters.contains('pmr')) count++;
    if (filter.onlineOnly) count++;
    return count;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    final locationDisabled = context.l10n.searchLocationDisabled;
    final permissionDenied = context.l10n.searchPermissionDenied;
    final locationSettingsRequired =
        context.l10n.searchLocationSettingsRequired;
    final locationNotFound = context.l10n.searchLocationNotFound;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError(locationDisabled);
        return;
      }

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

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final filterNotifier = ref.read(eventFilterProvider.notifier);
      filterNotifier.setLocation(position.latitude, position.longitude, 20);
      filterNotifier.clearCity();
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
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: HbColors.surfaceLight,
      body: Stack(
        children: [
          // Scrollable content with accordion panels
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  _buildHeader(topPadding),

                  // Accordion panels
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(16, 8, 16, 120 + bottomPadding),
                    child: Column(
                      children: [
                        // Panel 0: Où ?
                        _AccordionPanel(
                          key: _panelKeys[_wherePanel],
                          title: context.l10n.homeSearchWhere,
                          subtitle: _getWhereSubtitle(filter),
                          icon: Icons.location_on,
                          isExpanded: _expandedPanel == _wherePanel,
                          onTap: () => _expandPanel(_wherePanel),
                          child: _WhereContent(
                            filter: filter,
                            isLoadingLocation: _isLoadingLocation,
                            onLocationTap: _getCurrentLocation,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Panel 1: Quand ?
                        _AccordionPanel(
                          key: _panelKeys[_whenPanel],
                          title: context.l10n.homeSearchWhen,
                          subtitle: _getWhenSubtitle(filter),
                          icon: Icons.calendar_today,
                          isExpanded: _expandedPanel == _whenPanel,
                          onTap: () => _expandPanel(_whenPanel),
                          child: _WhenContent(filter: filter),
                        ),

                        const SizedBox(height: 12),

                        // Panel 2: Quoi ?
                        _AccordionPanel(
                          key: _panelKeys[_whatPanel],
                          title: context.l10n.homeSearchWhat,
                          subtitle: _getWhatSubtitle(filter),
                          icon: Icons.category,
                          isExpanded: _expandedPanel == _whatPanel,
                          onTap: () => _expandPanel(_whatPanel),
                          child: _WhatContent(filter: filter),
                        ),

                        const SizedBox(height: 12),

                        _AccordionPanel(
                          key: _panelKeys[_searchPanel],
                          title: context.l10n.searchTitle,
                          subtitle: _getSearchSubtitle(filter),
                          icon: Icons.search,
                          isExpanded: _expandedPanel == _searchPanel,
                          onTap: () => _expandPanel(_searchPanel),
                          child: _buildSearchInput(filter, filterNotifier),
                        ),

                        const SizedBox(height: 12),

                        _AccordionPanel(
                          key: _panelKeys[_audiencePanel],
                          title: context.l10n.searchForWhom,
                          subtitle: _getAudienceSubtitle(filter),
                          icon: Icons.people,
                          isExpanded: _expandedPanel == _audiencePanel,
                          onTap: () => _expandPanel(_audiencePanel),
                          child: _AudienceContent(filter: filter),
                        ),

                        const SizedBox(height: 12),

                        _AccordionPanel(
                          key: _panelKeys[_pricePanel],
                          title: context.l10n.searchSectionBudget,
                          subtitle: _getPriceSubtitle(filter),
                          icon: Icons.euro,
                          isExpanded: _expandedPanel == _pricePanel,
                          onTap: () => _expandPanel(_pricePanel),
                          child: _PriceContent(filter: filter),
                        ),

                        const SizedBox(height: 12),

                        _AccordionPanel(
                          key: _panelKeys[_availabilityPanel],
                          title: context.l10n.searchAvailabilityPanelTitle,
                          subtitle: filter.availableOnly
                              ? context.l10n.searchAvailablePlaces
                              : context.l10n.searchAllActivities,
                          icon: Icons.event_available,
                          isExpanded: _expandedPanel == _availabilityPanel,
                          onTap: () => _expandPanel(_availabilityPanel),
                          child: _AvailabilityContent(filter: filter),
                        ),

                        const SizedBox(height: 12),

                        _AccordionPanel(
                          key: _panelKeys[_refinePanel],
                          title: context.l10n.searchRefineTitle,
                          subtitle: _getRefineSubtitle(filter),
                          icon: Icons.tune,
                          isExpanded: _expandedPanel == _refinePanel,
                          onTap: () => _expandPanel(_refinePanel),
                          child: _RefineContent(filter: filter),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FilterFooterWithClear(
              buttonText: context.l10n.searchAction,
              buttonIcon: Icons.search,
              activeFilterCount: _activeFilterCount,
              hasFilters: filter.hasActiveFilters,
              bottomPadding: bottomPadding,
              onPressed: widget.onSearch ?? () {},
              onClear: () {
                filterNotifier.resetAll();
                _searchController.clear();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double topPadding) {
    return Container(
      color: HbColors.surfaceLight,
      padding: EdgeInsets.fromLTRB(8, topPadding + 8, 16, 12),
      child: Row(
        children: [
          // Close button (style Airbnb - cercle avec bordure)
          IconButton(
            onPressed: widget.onClose,
            icon: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.black87),
            ),
          ),

          const Spacer(),

          // Titre centré
          Text(
            context.l10n.searchTitle,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const Spacer(),

          // Placeholder pour équilibrer le layout
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildSearchInput(
    EventFilter filter,
    EventFilterNotifier filterNotifier,
  ) {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        filterNotifier.setSearchQuery(value);
        setState(() {});
      },
      onSubmitted: (_) => widget.onSearch?.call(),
      decoration: InputDecoration(
        hintText: context.l10n.searchHintEventOrOrganization,
        prefixIcon: const Icon(Icons.search, color: HbColors.brandPrimary),
        suffixIcon: filter.searchQuery.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close, color: Colors.grey.shade500),
                onPressed: () {
                  _searchController.clear();
                  filterNotifier.clearSearchQuery();
                  setState(() {});
                },
              ),
        filled: true,
        fillColor: HbColors.surfaceInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    );
  }

  String _getWhereSubtitle(EventFilter filter) {
    if (filter.latitude != null) {
      return context.searchAroundMeLabel(filter.radiusKm);
    }
    if (filter.cityName != null) {
      return context.searchCityRadiusLabel(
        filter.cityName!,
        filter.effectiveCityRadiusKm,
      );
    }
    return context.l10n.searchAnywhere;
  }

  String _getWhenSubtitle(EventFilter filter) {
    final dateLabel = context.searchDateFilterLabelOrNull(filter);
    if (dateLabel != null) return dateLabel;
    if (filter.startDate != null) {
      final formatter = context.appDateFormat('d MMM', enPattern: 'MMM d');
      if (filter.endDate != null && filter.startDate != filter.endDate) {
        return '${formatter.format(filter.startDate!)} - ${formatter.format(filter.endDate!)}';
      }
      return formatter.format(filter.startDate!);
    }
    return context.l10n.searchAnytime;
  }

  String _getWhatSubtitle(EventFilter filter) {
    if (filter.categoriesSlugs.length == 1) {
      return context.l10n.searchCategorySingular;
    }
    if (filter.categoriesSlugs.isNotEmpty) {
      return context.l10n.searchCategoriesCount(filter.categoriesSlugs.length);
    }
    return context.l10n.searchAnyActivityType;
  }

  String _getSearchSubtitle(EventFilter filter) {
    if (filter.searchQuery.trim().isEmpty) {
      return context.l10n.searchSearchSubtitleDefault;
    }
    return '"${filter.searchQuery.trim()}"';
  }

  String _getAudienceSubtitle(EventFilter filter) {
    if (filter.targetAudienceSlugs.length == 1) {
      return context.l10n.searchAudienceSingular;
    }
    if (filter.targetAudienceSlugs.isNotEmpty) {
      return context.l10n
          .searchAudiencesCount(filter.targetAudienceSlugs.length);
    }
    return context.l10n.searchAllAudiences;
  }

  String _getPriceSubtitle(EventFilter filter) {
    if (filter.onlyFree || filter.priceFilterType == PriceFilterType.free) {
      return context.l10n.commonFree;
    }
    if (filter.priceFilterType == PriceFilterType.paid ||
        filter.priceFilterType == PriceFilterType.range) {
      if (filter.priceFilterType == PriceFilterType.range) {
        return '${filter.priceMin.toInt()}€ - ${filter.priceMax.toInt()}€${filter.priceMax >= 500 ? '+' : ''}';
      }
      return context.l10n.searchPricePaid;
    }
    return context.l10n.searchAll;
  }

  String _getRefineSubtitle(EventFilter filter) {
    var count = 0;
    count += filter.tagsSlugs.length;
    if (filter.eventTagSlug != null && filter.tagsSlugs.isEmpty) count++;
    count += filter.thematiquesSlugs.length;
    count += filter.emotionSlugs.length;
    count += filter.specialEventSlugs.length;
    if (filter.locationType != null) count++;
    if (count == 0) return context.l10n.searchRefineSubtitleDefault;
    return count == 1
        ? context.l10n.searchFilterSingular
        : context.l10n.searchFiltersCount(count);
  }
}

// =============================================================================
// ACCORDION PANEL - Panel accordéon avec animation
// =============================================================================

class _AccordionPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget child;

  const _AccordionPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isExpanded,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isExpanded ? 0.08 : 0.04),
            blurRadius: isExpanded ? 16 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (toujours visible)
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? HbColors.brandPrimary.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isExpanded
                          ? HbColors.brandPrimary
                          : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: isExpanded
                                ? HbColors.brandPrimary
                                : Colors.grey.shade600,
                            fontWeight:
                                isExpanded ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand/collapse indicator
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content (animated)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: child,
            ),
            secondChild: const SizedBox(height: 0, width: double.infinity),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// WHERE CONTENT - Contenu du panel "Où ?"
// =============================================================================

class _WhereContent extends ConsumerStatefulWidget {
  final EventFilter filter;
  final bool isLoadingLocation;
  final VoidCallback onLocationTap;

  const _WhereContent({
    required this.filter,
    required this.isLoadingLocation,
    required this.onLocationTap,
  });

  @override
  ConsumerState<_WhereContent> createState() => _WhereContentState();
}

class _WhereContentState extends ConsumerState<_WhereContent> {
  final TextEditingController _citySearchController = TextEditingController();
  String _cityQuery = '';

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final filter = widget.filter;
    final hasLocation = filter.latitude != null;
    final hasCity = filter.citySlug != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Géolocalisation
        GestureDetector(
          onTap: widget.isLoadingLocation ? null : widget.onLocationTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasLocation
                  ? HbColors.brandPrimary.withValues(alpha: 0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    hasLocation ? HbColors.brandPrimary : Colors.grey.shade200,
                width: hasLocation ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: hasLocation
                        ? HbColors.brandPrimary.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: HbColors.brandPrimary,
                          ),
                        )
                      : Icon(
                          Icons.near_me,
                          color: hasLocation
                              ? HbColors.brandPrimary
                              : Colors.grey.shade600,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.homeSearchNearby,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        hasLocation
                            ? context.searchWithinRadiusLabel(filter.radiusKm)
                            : context.l10n.searchUseCurrentLocation,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLocation)
                  IconButton(
                    onPressed: () => filterNotifier.clearLocation(),
                    icon: Icon(Icons.close,
                        size: 18, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: _citySearchController,
          onChanged: (value) => setState(() => _cityQuery = value.trim()),
          decoration: InputDecoration(
            hintText: context.l10n.searchHintCity,
            prefixIcon: const Icon(Icons.search, color: HbColors.brandPrimary),
            suffixIcon: _cityQuery.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _citySearchController.clear();
                      setState(() => _cityQuery = '');
                    },
                    icon: Icon(Icons.close, color: Colors.grey.shade500),
                  ),
            filled: true,
            fillColor: HbColors.surfaceInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),

        if (hasLocation || hasCity) ...[
          const SizedBox(height: 16),
          Text(
            context.l10n.searchRadiusLabel.replaceAll(':', '').toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [5, 10, 20, 50].map((radius) {
              final selectedRadius = hasCity
                  ? filter.effectiveCityRadiusKm
                  : filter.radiusKm.toInt();
              return SelectableChip(
                label: '$radius km',
                icon: Icons.radar,
                isSelected: selectedRadius == radius,
                onTap: () {
                  if (hasCity) {
                    filterNotifier.setCity(
                      filter.citySlug!,
                      filter.cityName ?? filter.citySlug!,
                      radiusKm: radius.toDouble(),
                    );
                  } else if (filter.latitude != null &&
                      filter.longitude != null) {
                    filterNotifier.setLocation(
                      filter.latitude!,
                      filter.longitude!,
                      radius.toDouble(),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 20),

        // Villes populaires
        Text(
          _cityQuery.isEmpty
              ? context.l10n.searchPopularCities
              : context.l10n.searchResults,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        if (_cityQuery.isNotEmpty && !_shouldShowAutocomplete(_cityQuery))
          _AutocompleteMessage(
            context.searchMinCharactersLabel(
              searchAutocompleteMinQueryLength,
            ),
          )
        else if (_shouldShowAutocomplete(_cityQuery))
          _buildCityAutocompleteResults(filter, filterNotifier)
        else
          _buildPopularCityChips(filter, filterNotifier),
      ],
    );
  }

  Widget _buildPopularCityChips(
    EventFilter filter,
    EventFilterNotifier filterNotifier,
  ) {
    final popularCities = ref.watch(popularCitiesProvider);

    return popularCities.when(
      data: (result) {
        final displayedCities = result.cities.take(6).toList();

        if (displayedCities.isEmpty) {
          return Text(
            context.l10n.searchNoCityFound,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displayedCities.map((city) {
            final isSelected = filter.citySlug == city.slug;
            return SelectableChip(
              label: city.name,
              icon: Icons.location_city,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) {
                  filterNotifier.clearCity();
                } else {
                  filterNotifier.setCity(
                    city.slug,
                    city.name,
                    radiusKm: filter.effectiveCityRadiusKm.toDouble(),
                  );
                  filterNotifier.clearLocation();
                }
              },
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HbColors.brandPrimary,
          ),
        ),
      ),
      error: (_, __) => Text(
        context.l10n.searchCitiesUnavailable,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCityAutocompleteResults(
    EventFilter filter,
    EventFilterNotifier filterNotifier,
  ) {
    final suggestions = ref.watch(
      searchSuggestionsProvider(
        SearchSuggestionsRequest(
          query: _cityQuery,
          types: 'cities',
          limit: 10,
        ),
      ),
    );

    return suggestions.when(
      data: (data) {
        if (data.cities.isEmpty) {
          return _AutocompleteMessage(context.l10n.searchNoCityFound);
        }

        return _SuggestionList(
          children: data.cities.map((city) {
            final isSelected = filter.citySlug == city.slug;
            return _SuggestionTile(
              icon: Icons.location_city,
              label: _labelWithCount(city.label, city.eventsCount),
              isSelected: isSelected,
              onTap: () {
                if (isSelected) {
                  filterNotifier.clearCity();
                } else {
                  filterNotifier.setCity(
                    city.slug,
                    city.label,
                    radiusKm: filter.effectiveCityRadiusKm.toDouble(),
                  );
                  filterNotifier.clearLocation();
                }
              },
            );
          }).toList(),
        );
      },
      loading: () => const _AutocompleteLoading(),
      error: (_, __) =>
          _AutocompleteMessage(context.l10n.searchCitiesUnavailable),
    );
  }
}

// =============================================================================
// WHEN CONTENT - Contenu du panel "Quand ?"
// =============================================================================

class _WhenContent extends ConsumerStatefulWidget {
  final EventFilter filter;

  const _WhenContent({required this.filter});

  @override
  ConsumerState<_WhenContent> createState() => _WhenContentState();
}

class _WhenContentState extends ConsumerState<_WhenContent> {
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final daysUntilSaturday = (DateTime.saturday - today.weekday) % 7;
    final saturday = today.add(Duration(
      days: daysUntilSaturday == 0 && now.weekday != DateTime.saturday
          ? 7
          : daysUntilSaturday,
    ));
    final sunday = saturday.add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick date chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            DateQuickChip(
              label: context.l10n.commonToday,
              subtitle: context
                  .appDateFormat('d MMM', enPattern: 'MMM d')
                  .format(today),
              isSelected: widget.filter.dateFilterType == DateFilterType.today,
              onTap: () {
                if (widget.filter.dateFilterType == DateFilterType.today) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.today);
                }
              },
            ),
            DateQuickChip(
              label: context.l10n.commonTomorrow,
              subtitle: context
                  .appDateFormat('d MMM', enPattern: 'MMM d')
                  .format(tomorrow),
              isSelected:
                  widget.filter.dateFilterType == DateFilterType.tomorrow,
              onTap: () {
                if (widget.filter.dateFilterType == DateFilterType.tomorrow) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.tomorrow);
                }
              },
            ),
            DateQuickChip(
              label: context.l10n.commonThisWeekend,
              subtitle:
                  '${DateFormat('d').format(saturday)}-${context.appDateFormat('d MMM', enPattern: 'MMM d').format(sunday)}',
              isSelected:
                  widget.filter.dateFilterType == DateFilterType.thisWeekend,
              onTap: () {
                if (widget.filter.dateFilterType ==
                    DateFilterType.thisWeekend) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.thisWeekend);
                }
              },
            ),
            DateQuickChip(
              label: context.l10n.searchDateThisMonth,
              isSelected:
                  widget.filter.dateFilterType == DateFilterType.thisMonth,
              onTap: () {
                if (widget.filter.dateFilterType == DateFilterType.thisMonth) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.thisMonth);
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Bouton dates personnalisées
        GestureDetector(
          onTap: () => setState(() => _showCalendar = !_showCalendar),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.filter.dateFilterType == DateFilterType.custom
                  ? HbColors.brandPrimary.withValues(alpha: 0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.filter.dateFilterType == DateFilterType.custom
                    ? HbColors.brandPrimary
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 18,
                  color: widget.filter.dateFilterType == DateFilterType.custom
                      ? HbColors.brandPrimary
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.searchDateCustom,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          widget.filter.dateFilterType == DateFilterType.custom
                              ? HbColors.brandPrimary
                              : Colors.grey.shade700,
                    ),
                  ),
                ),
                Icon(
                  _showCalendar
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),

        // Mini Calendar
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _showCalendar
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: MiniCalendar(
              selectedStartDate: widget.filter.startDate,
              selectedEndDate: widget.filter.endDate,
              onDateSelected: (start, end) {
                filterNotifier.setCustomDateRange(start, end ?? start);
              },
            ),
          ),
          secondChild: const SizedBox(height: 0, width: double.infinity),
        ),
      ],
    );
  }
}

// =============================================================================
// WHAT CONTENT - Contenu du panel "Quoi ?"
// =============================================================================

class _WhatContent extends ConsumerStatefulWidget {
  final EventFilter filter;

  const _WhatContent({required this.filter});

  @override
  ConsumerState<_WhatContent> createState() => _WhatContentState();
}

class _WhatContentState extends ConsumerState<_WhatContent> {
  final TextEditingController _categorySearchController =
      TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _categorySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final referenceData = ref.watch(eventReferenceDataProvider);

    return referenceData.when(
      data: (data) {
        final categories = _filteredCategories(data.categories);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categorySearchController,
              onChanged: (value) => setState(() => _query = value.trim()),
              decoration: InputDecoration(
                hintText: context.l10n.searchHintCategory,
                prefixIcon:
                    const Icon(Icons.search, color: HbColors.brandPrimary),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _categorySearchController.clear();
                          setState(() => _query = '');
                        },
                        icon: Icon(Icons.close, color: Colors.grey.shade500),
                      ),
                filled: true,
                fillColor: HbColors.surfaceInput,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            if (_query.isNotEmpty && !_shouldShowAutocomplete(_query))
              _AutocompleteMessage(
                context.searchMinCharactersLabel(
                  searchAutocompleteMinQueryLength,
                ),
              )
            else if (_shouldShowAutocomplete(_query))
              _buildCategoryAutocompleteResults()
            else if (categories.isEmpty)
              _FilterMessage(context.l10n.searchNoCategoryFound)
            else
              ...categories.map(
                (entry) => _buildCategoryGroup(
                  entry,
                  filterNotifier,
                ),
              ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HbColors.brandPrimary,
          ),
        ),
      ),
      error: (_, __) => Text(
        context.l10n.searchCategoriesUnavailable,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCategoryAutocompleteResults() {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final suggestions = ref.watch(
      searchSuggestionsProvider(
        SearchSuggestionsRequest(
          query: _query,
          types: 'categories',
          limit: 10,
        ),
      ),
    );

    return suggestions.when(
      data: (data) {
        if (data.categories.isEmpty) {
          return _AutocompleteMessage(context.l10n.searchNoCategoryFound);
        }

        return _SuggestionList(
          children: data.categories.map((category) {
            final isSelected =
                widget.filter.categoriesSlugs.contains(category.slug);
            return _SuggestionTile(
              icon: _iconForReference(null, category.slug),
              label: category.label,
              isSelected: isSelected,
              onTap: () => _toggleSuggestionCategory(category, filterNotifier),
            );
          }).toList(),
        );
      },
      loading: () => const _AutocompleteLoading(),
      error: (_, __) => _AutocompleteMessage(
        context.l10n.searchCategoriesUnavailable,
      ),
    );
  }

  List<_CategoryEntry> _filteredCategories(
    List<EventReferenceCategoryDto> categories,
  ) {
    final normalized = _query.toLowerCase();

    return categories
        .where(_categoryHasVisibleEvents)
        .map((category) {
          final visibleChildren =
              category.children.where(_categoryHasVisibleEvents).toList();

          if (normalized.isEmpty) {
            return _CategoryEntry(category, visibleChildren);
          }

          final parentMatches =
              category.name.toLowerCase().contains(normalized) ||
                  category.slug.toLowerCase().contains(normalized);
          final matchingChildren = visibleChildren
              .where(
                (child) =>
                    child.name.toLowerCase().contains(normalized) ||
                    child.slug.toLowerCase().contains(normalized),
              )
              .toList();

          if (parentMatches) return _CategoryEntry(category, visibleChildren);
          if (matchingChildren.isNotEmpty) {
            return _CategoryEntry(category, matchingChildren);
          }
          return null;
        })
        .whereType<_CategoryEntry>()
        .toList();
  }

  bool _categoryHasVisibleEvents(EventReferenceCategoryDto category) {
    final hasOwnEvents =
        category.eventCount == null || category.eventCount! > 0;
    final hasChildEvents = category.children.any(_categoryHasVisibleEvents);
    return hasOwnEvents || hasChildEvents;
  }

  Widget _buildCategoryGroup(
    _CategoryEntry entry,
    EventFilterNotifier filterNotifier,
  ) {
    final category = entry.category;
    final selectedSlugs = widget.filter.categoriesSlugs;
    final fullySelected = _isParentFullySelected(category, entry.children);
    final partiallySelected =
        _isParentPartiallySelected(category, entry.children);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableChip(
            label: category.name,
            icon: _iconForReference(category.icon, category.slug),
            isSelected: fullySelected || partiallySelected,
            onTap: () =>
                _toggleParent(category, entry.children, filterNotifier),
          ),
          if (entry.children.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.children.map((child) {
                  final isSelected = selectedSlugs.contains(category.slug) ||
                      selectedSlugs.contains(child.slug);
                  return SelectableChip(
                    label: child.name,
                    icon: _iconForReference(child.icon, child.slug),
                    isSelected: isSelected,
                    onTap: () => _toggleChild(
                      category,
                      child,
                      entry.children,
                      filterNotifier,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isParentFullySelected(
    EventReferenceCategoryDto parent,
    List<EventReferenceCategoryDto> children,
  ) {
    final selected = widget.filter.categoriesSlugs;
    if (selected.contains(parent.slug)) return true;
    return children.isNotEmpty &&
        children.every((child) => selected.contains(child.slug));
  }

  bool _isParentPartiallySelected(
    EventReferenceCategoryDto parent,
    List<EventReferenceCategoryDto> children,
  ) {
    final selected = widget.filter.categoriesSlugs;
    if (selected.contains(parent.slug) || children.isEmpty) return false;
    final selectedChildren =
        children.where((child) => selected.contains(child.slug)).length;
    return selectedChildren > 0 && selectedChildren < children.length;
  }

  void _toggleParent(
    EventReferenceCategoryDto parent,
    List<EventReferenceCategoryDto> children,
    EventFilterNotifier filterNotifier,
  ) {
    final next = Set<String>.from(widget.filter.categoriesSlugs);
    final fullySelected = _isParentFullySelected(parent, children);
    next.remove(parent.slug);
    for (final child in children) {
      next.remove(child.slug);
    }
    if (!fullySelected) next.add(parent.slug);
    filterNotifier.applyFilters(
      widget.filter.copyWith(categoriesSlugs: next.toList()),
    );
  }

  void _toggleChild(
    EventReferenceCategoryDto parent,
    EventReferenceCategoryDto child,
    List<EventReferenceCategoryDto> siblings,
    EventFilterNotifier filterNotifier,
  ) {
    final next = Set<String>.from(widget.filter.categoriesSlugs);

    if (next.contains(parent.slug)) {
      next.remove(parent.slug);
      for (final sibling in siblings) {
        if (sibling.slug != child.slug) next.add(sibling.slug);
      }
    } else if (next.contains(child.slug)) {
      next.remove(child.slug);
    } else {
      next.add(child.slug);
      if (siblings.isNotEmpty &&
          siblings.every((sibling) => next.contains(sibling.slug))) {
        for (final sibling in siblings) {
          next.remove(sibling.slug);
        }
        next.add(parent.slug);
      }
    }

    filterNotifier.applyFilters(
      widget.filter.copyWith(categoriesSlugs: next.toList()),
    );
  }

  void _toggleSuggestionCategory(
    SearchSuggestionItemDto suggestion,
    EventFilterNotifier filterNotifier,
  ) {
    final match = _findCategoryMatch(suggestion.slug);
    if (match != null && match.category.slug == match.child.slug) {
      _toggleParent(match.category, match.category.children, filterNotifier);
    } else if (match != null) {
      _toggleChild(
        match.category,
        match.child,
        match.category.children,
        filterNotifier,
      );
    } else {
      final next = _toggleSlug(widget.filter.categoriesSlugs, suggestion.slug);
      filterNotifier.applyFilters(
        widget.filter.copyWith(categoriesSlugs: next),
      );
    }
  }

  _CategoryMatch? _findCategoryMatch(String slug) {
    final referenceData = ref.read(eventReferenceDataProvider).valueOrNull;
    final categories = referenceData?.categories ?? const [];
    for (final category in categories) {
      if (category.slug == slug) {
        return _CategoryMatch(category, category);
      }
      for (final child in category.children) {
        if (child.slug == slug) return _CategoryMatch(category, child);
      }
    }
    return null;
  }
}

class _CategoryEntry {
  final EventReferenceCategoryDto category;
  final List<EventReferenceCategoryDto> children;

  const _CategoryEntry(this.category, this.children);
}

class _CategoryMatch {
  final EventReferenceCategoryDto category;
  final EventReferenceCategoryDto child;

  const _CategoryMatch(this.category, this.child);
}

const _fallbackPublicFilters = [
  EventReferencePublicFilterDto(
    key: 'family',
    label: '',
    param: 'public_filters',
    value: 'family',
  ),
  EventReferencePublicFilterDto(
    key: 'pmr',
    label: '',
    param: 'public_filters',
    value: 'pmr',
  ),
  EventReferencePublicFilterDto(
    key: 'group',
    label: '',
    param: 'public_filters',
    value: 'group',
  ),
  EventReferencePublicFilterDto(
    key: 'school',
    label: '',
    param: 'public_filters',
    value: 'school',
  ),
  EventReferencePublicFilterDto(
    key: 'professional',
    label: '',
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

class _AudienceContent extends ConsumerWidget {
  final EventFilter filter;

  const _AudienceContent({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final referenceData = ref.watch(eventReferenceDataProvider);

    return referenceData.when(
      data: (data) {
        final options = _publicFilterOptions(data.publicFilters);
        final selectedKeys =
            selectedPublicAudienceFilters(filter.targetAudienceSlugs);

        if (options.isEmpty) {
          return _FilterMessage(context.l10n.searchNoAudienceAvailable);
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((publicFilter) {
            final value = _publicFilterValue(publicFilter);
            final isSelected = selectedKeys.contains(value);

            return SelectableChip(
              label: _publicFilterLabel(context, publicFilter),
              icon: _publicFilterIcon(value),
              isSelected: isSelected,
              onTap: () => filterNotifier.applyFilters(
                filter.copyWith(
                  targetAudienceSlugs: _toggleSlug(selectedKeys, value),
                  familyFriendly: false,
                  accessiblePMR: false,
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HbColors.brandPrimary,
          ),
        ),
      ),
      error: (_, __) => Text(
        context.l10n.searchAudiencesUnavailable,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _PriceContent extends ConsumerWidget {
  final EventFilter filter;

  const _PriceContent({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final isFree =
        filter.onlyFree || filter.priceFilterType == PriceFilterType.free;
    final isPaid = filter.priceFilterType == PriceFilterType.paid ||
        filter.priceFilterType == PriceFilterType.range;
    final min = filter.priceMin.clamp(1.0, 500.0).toDouble();
    final max = filter.priceMax.clamp(1.0, 500.0).toDouble();
    final range = RangeValues(
      min <= max ? min : 1.0,
      max >= min ? max : 500.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SelectableChip(
              label: context.l10n.searchAll,
              isSelected: !isFree && !isPaid,
              onTap: filterNotifier.clearPriceFilter,
            ),
            SelectableChip(
              label: context.l10n.commonFree,
              icon: Icons.local_offer_outlined,
              isSelected: isFree,
              onTap: () => filterNotifier.setOnlyFree(!isFree),
            ),
            SelectableChip(
              label: context.l10n.searchPricePaid,
              isSelected: isPaid,
              onTap: () {
                if (isPaid) {
                  filterNotifier.clearPriceFilter();
                } else {
                  filterNotifier.setPriceFilter(
                    PriceFilterType.paid,
                    min: 1,
                    max: 500,
                  );
                }
              },
            ),
          ],
        ),
        if (isPaid) ...[
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.searchPriceRangeTitle,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${range.start.toInt()}€ - ${range.end.toInt()}€${range.end >= 500 ? '+' : ''}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: range,
            min: 1,
            max: 500,
            divisions: 50,
            activeColor: HbColors.brandPrimary,
            inactiveColor: Colors.grey.shade200,
            onChanged: (values) {
              filterNotifier.setPriceRange(values.start, values.end);
            },
          ),
        ],
      ],
    );
  }
}

class _AvailabilityContent extends ConsumerWidget {
  final EventFilter filter;

  const _AvailabilityContent({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return ToggleRow(
      title: context.l10n.searchAvailableOnlyTitle,
      subtitle: context.l10n.searchAvailabilitySubtitle,
      icon: Icons.confirmation_number_outlined,
      isSelected: filter.availableOnly,
      onTap: () => filterNotifier.setAvailableOnly(!filter.availableOnly),
    );
  }
}

class _RefineContent extends ConsumerWidget {
  final EventFilter filter;

  const _RefineContent({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final referenceData = ref.watch(eventReferenceDataProvider);
    final selectedEventTags = filter.tagsSlugs.isNotEmpty
        ? filter.tagsSlugs
        : [
            if (filter.eventTagSlug != null) filter.eventTagSlug!,
          ];

    return referenceData.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReferenceMultiSection(
            title: context.l10n.searchSectionEventType.toUpperCase(),
            options: data.eventTags,
            selectedSlugs: selectedEventTags,
            onChanged: (slugs) {
              filterNotifier.setEventTag(null);
              filterNotifier.setTags(slugs);
            },
          ),
          _ReferenceMultiSection(
            title: context.l10n.searchSectionThemes.toUpperCase(),
            options: data.themes,
            selectedSlugs: filter.thematiquesSlugs,
            showCounts: false,
            onChanged: filterNotifier.setThematiques,
          ),
          _ReferenceMultiSection(
            title: context.l10n.searchSectionMood.toUpperCase(),
            options: data.emotions,
            selectedSlugs: filter.emotionSlugs,
            onChanged: filterNotifier.setEmotions,
          ),
          _LocationTypeSection(filter: filter),
          _ReferenceMultiSection(
            title: context.l10n.searchSectionSpecialEvents.toUpperCase(),
            options: data.specialEvents,
            selectedSlugs: filter.specialEventSlugs,
            onChanged: filterNotifier.setSpecialEvents,
          ),
        ],
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HbColors.brandPrimary,
          ),
        ),
      ),
      error: (_, __) => Text(
        context.l10n.searchOptionsUnavailable,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _ReferenceMultiSection extends StatelessWidget {
  final String title;
  final List<EventReferenceOptionDto> options;
  final List<String> selectedSlugs;
  final bool showCounts;
  final ValueChanged<List<String>> onChanged;

  const _ReferenceMultiSection({
    required this.title,
    required this.options,
    required this.selectedSlugs,
    this.showCounts = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(title),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedSlugs.contains(option.slug);
              return SelectableChip(
                label: showCounts
                    ? _labelWithCount(option.name, option.eventCount)
                    : option.name,
                icon: _iconForReference(option.icon, option.slug),
                isSelected: isSelected,
                onTap: () => onChanged(_toggleSlug(selectedSlugs, option.slug)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _LocationTypeSection extends ConsumerWidget {
  final EventFilter filter;

  const _LocationTypeSection({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.l10n.searchSectionLocationType.toUpperCase()),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _locationTypeChip(
                label: context.l10n.searchLocationIndoor,
                icon: Icons.home_work_outlined,
                type: LocationTypeFilter.physical,
                filterNotifier: filterNotifier,
              ),
              _locationTypeChip(
                label: context.l10n.searchLocationOutdoor,
                icon: Icons.park_outlined,
                type: LocationTypeFilter.offline,
                filterNotifier: filterNotifier,
              ),
              _locationTypeChip(
                label: context.l10n.searchLocationMixed,
                icon: Icons.sync_alt,
                type: LocationTypeFilter.hybrid,
                filterNotifier: filterNotifier,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationTypeChip({
    required String label,
    required IconData icon,
    required LocationTypeFilter type,
    required EventFilterNotifier filterNotifier,
  }) {
    final isSelected = filter.locationType == type;
    return SelectableChip(
      label: label,
      icon: icon,
      isSelected: isSelected,
      onTap: () => filterNotifier.setLocationType(isSelected ? null : type),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 1,
      ),
    );
  }
}

bool _shouldShowAutocomplete(String query) {
  return query.trim().length >= searchAutocompleteMinQueryLength;
}

class _SuggestionList extends StatelessWidget {
  final List<Widget> children;

  const _SuggestionList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? HbColors.brandPrimary : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? HbColors.brandPrimary : HbColors.textDark,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 18,
                color: HbColors.brandPrimary,
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterMessage extends StatelessWidget {
  final String message;

  const _FilterMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: GoogleFonts.montserrat(
        fontSize: 13,
        color: Colors.grey.shade600,
      ),
    );
  }
}

class _AutocompleteMessage extends StatelessWidget {
  final String message;

  const _AutocompleteMessage(this.message);

  @override
  Widget build(BuildContext context) => _FilterMessage(message);
}

class _AutocompleteLoading extends StatelessWidget {
  const _AutocompleteLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: HbColors.brandPrimary,
        ),
      ),
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

String _labelWithCount(String label, int? count) {
  if (count == null || count <= 0) return label;
  return '$label ($count)';
}

IconData _iconForReference(String? icon, String slug) {
  final key = '${icon ?? ''} $slug'.toLowerCase();

  if (key.contains('music') || key.contains('concert')) return Icons.music_note;
  if (key.contains('movie') || key.contains('cinema')) return Icons.movie;
  if (key.contains('sport') || key.contains('fitness')) return Icons.sports;
  if (key.contains('restaurant') || key.contains('gastronomie')) {
    return Icons.restaurant;
  }
  if (key.contains('child') || key.contains('famille')) return Icons.child_care;
  if (key.contains('palette') || key.contains('art')) return Icons.palette;
  if (key.contains('school') || key.contains('formation')) return Icons.school;
  if (key.contains('book') || key.contains('litterature')) {
    return Icons.menu_book;
  }
  if (key.contains('park') || key.contains('nature')) return Icons.park;
  if (key.contains('computer') || key.contains('numerique')) {
    return Icons.computer;
  }
  if (key.contains('castle') || key.contains('patrimoine')) return Icons.castle;
  if (key.contains('mood') || key.contains('emotion')) return Icons.mood;
  if (key.contains('celebration') || key.contains('festival')) {
    return Icons.celebration;
  }
  return Icons.local_activity;
}
