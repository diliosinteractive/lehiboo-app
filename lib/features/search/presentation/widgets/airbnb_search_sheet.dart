import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../../../home/presentation/providers/home_providers.dart';
import 'filter_shared_components.dart';

/// Airbnb-style full screen search page with accordion panels
///
/// Design inspiré directement des screenshots Airbnb :
/// - Page plein écran SANS bottom nav bar (expérience modale immersive)
/// - Header avec titre "Recherche" et bouton fermer
/// - 3 volets avec animations fluides (Où, Quand, Quoi)
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
  /// Currently expanded panel: 0 = Où, 1 = Quand, 2 = Quoi
  int _expandedPanel = 0;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _panel0Key = GlobalKey();
  final GlobalKey _panel1Key = GlobalKey();
  final GlobalKey _panel2Key = GlobalKey();

  late AnimationController _animationController;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _expandPanel(int index) {
    setState(() => _expandedPanel = index);

    // Scroll vers le panel ouvert après l'animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = index == 0
          ? _panel0Key
          : index == 1
              ? _panel1Key
              : _panel2Key;
      final context = key.currentContext;
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
    int count = 0;
    if (filter.dateFilterType != null || filter.startDate != null) count++;
    if (filter.citySlug != null) count++;
    if (filter.latitude != null) count++;
    count += filter.categoriesSlugs.length;
    if (filter.familyFriendly) count++;
    if (filter.onlyFree) count++;
    if (filter.accessiblePMR) count++;
    if (filter.onlineOnly) count++;
    return count;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Activez la localisation');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Permission refusée');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Activez la localisation dans les paramètres');
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
      _showError('Position introuvable');
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      backgroundColor: const Color(0xFFF7F7F7),
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
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 120 + bottomPadding),
                    child: Column(
                      children: [
                        // Panel 0: Où ?
                        _AccordionPanel(
                          key: _panel0Key,
                          title: 'Où ?',
                          subtitle: _getWhereSubtitle(filter),
                          icon: Icons.location_on,
                          isExpanded: _expandedPanel == 0,
                          onTap: () => _expandPanel(0),
                          child: _WhereContent(
                            filter: filter,
                            isLoadingLocation: _isLoadingLocation,
                            onLocationTap: _getCurrentLocation,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Panel 1: Quand ?
                        _AccordionPanel(
                          key: _panel1Key,
                          title: 'Quand ?',
                          subtitle: _getWhenSubtitle(filter),
                          icon: Icons.calendar_today,
                          isExpanded: _expandedPanel == 1,
                          onTap: () => _expandPanel(1),
                          child: _WhenContent(filter: filter),
                        ),

                        const SizedBox(height: 12),

                        // Panel 2: Quoi ?
                        _AccordionPanel(
                          key: _panel2Key,
                          title: 'Quoi ?',
                          subtitle: _getWhatSubtitle(filter),
                          icon: Icons.category,
                          isExpanded: _expandedPanel == 2,
                          onTap: () => _expandPanel(2),
                          child: _WhatContent(filter: filter),
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
              buttonText: 'Rechercher',
              buttonIcon: Icons.search,
              activeFilterCount: _activeFilterCount,
              hasFilters: filter.hasActiveFilters,
              bottomPadding: bottomPadding,
              onPressed: widget.onSearch ?? () {},
              onClear: () => filterNotifier.resetAll(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double topPadding) {
    return Container(
      color: const Color(0xFFF7F7F7),
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
            'Recherche',
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

  String _getWhereSubtitle(EventFilter filter) {
    if (filter.cityName != null) return filter.cityName!;
    if (filter.latitude != null) return 'À ${filter.radiusKm.toInt()} km';
    return 'N\'importe où';
  }

  String _getWhenSubtitle(EventFilter filter) {
    if (filter.dateFilterLabel != null) return filter.dateFilterLabel!;
    if (filter.startDate != null) {
      final formatter = DateFormat('d MMM', 'fr_FR');
      if (filter.endDate != null && filter.startDate != filter.endDate) {
        return '${formatter.format(filter.startDate!)} - ${formatter.format(filter.endDate!)}';
      }
      return formatter.format(filter.startDate!);
    }
    return 'N\'importe quand';
  }

  String _getWhatSubtitle(EventFilter filter) {
    final parts = <String>[];
    if (filter.categoriesSlugs.isNotEmpty) {
      parts.add('${filter.categoriesSlugs.length} cat.');
    }
    if (filter.familyFriendly) parts.add('Famille');
    if (filter.onlyFree) parts.add('Gratuit');
    if (filter.accessiblePMR) parts.add('PMR');
    if (parts.isNotEmpty) return parts.join(', ');
    return 'Tout type d\'activité';
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
                          ? const Color(0xFFFF601F).withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isExpanded
                          ? const Color(0xFFFF601F)
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
                                ? const Color(0xFFFF601F)
                                : Colors.grey.shade600,
                            fontWeight: isExpanded
                                ? FontWeight.w600
                                : FontWeight.w400,
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
            crossFadeState:
                isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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

class _WhereContent extends ConsumerWidget {
  final EventFilter filter;
  final bool isLoadingLocation;
  final VoidCallback onLocationTap;

  const _WhereContent({
    required this.filter,
    required this.isLoadingLocation,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final hasLocation = filter.latitude != null;
    final citiesAsync = ref.watch(homeCitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Géolocalisation
        GestureDetector(
          onTap: isLoadingLocation ? null : onLocationTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasLocation
                  ? const Color(0xFFFF601F).withValues(alpha: 0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasLocation ? const Color(0xFFFF601F) : Colors.grey.shade200,
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
                        ? const Color(0xFFFF601F).withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFF601F),
                          ),
                        )
                      : Icon(
                          Icons.near_me,
                          color: hasLocation
                              ? const Color(0xFFFF601F)
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
                        'À proximité',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        hasLocation
                            ? 'Dans un rayon de ${filter.radiusKm.toInt()} km'
                            : 'Utiliser ma position',
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
                    icon: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ),

        // Slider rayon (visible si géoloc active)
        if (hasLocation) ...[
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFFF601F),
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: const Color(0xFFFF601F),
              overlayColor: const Color(0xFFFF601F).withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: filter.radiusKm,
              min: 5,
              max: 100,
              divisions: 19,
              onChanged: (radius) {
                filterNotifier.setLocation(
                  filter.latitude!,
                  filter.longitude!,
                  radius,
                );
              },
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Villes populaires
        Text(
          'VILLES POPULAIRES',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        citiesAsync.when(
          data: (cities) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cities.take(6).map((city) {
              final isSelected = filter.citySlug == city.slug;
              return SelectableChip(
                label: city.name,
                icon: Icons.location_city,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    filterNotifier.clearCity();
                  } else {
                    filterNotifier.setCity(city.slug, city.name);
                    filterNotifier.clearLocation();
                  }
                },
              );
            }).toList(),
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFFF601F),
              ),
            ),
          ),
          error: (_, __) => _buildFallbackCities(filter, filterNotifier),
        ),
      ],
    );
  }

  Widget _buildFallbackCities(EventFilter filter, EventFilterNotifier filterNotifier) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ('Paris', 'paris'),
        ('Lyon', 'lyon'),
        ('Marseille', 'marseille'),
        ('Bordeaux', 'bordeaux'),
        ('Toulouse', 'toulouse'),
        ('Nantes', 'nantes'),
      ].map((city) {
        final isSelected = filter.citySlug == city.$2;
        return SelectableChip(
          label: city.$1,
          icon: Icons.location_city,
          isSelected: isSelected,
          onTap: () {
            if (isSelected) {
              filterNotifier.clearCity();
            } else {
              filterNotifier.setCity(city.$2, city.$1);
              filterNotifier.clearLocation();
            }
          },
        );
      }).toList(),
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
              label: "Aujourd'hui",
              subtitle: DateFormat('d MMM', 'fr_FR').format(today),
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
              label: 'Demain',
              subtitle: DateFormat('d MMM', 'fr_FR').format(tomorrow),
              isSelected: widget.filter.dateFilterType == DateFilterType.tomorrow,
              onTap: () {
                if (widget.filter.dateFilterType == DateFilterType.tomorrow) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.tomorrow);
                }
              },
            ),
            DateQuickChip(
              label: 'Ce week-end',
              subtitle:
                  '${DateFormat('d').format(saturday)}-${DateFormat('d MMM', 'fr_FR').format(sunday)}',
              isSelected: widget.filter.dateFilterType == DateFilterType.thisWeekend,
              onTap: () {
                if (widget.filter.dateFilterType == DateFilterType.thisWeekend) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.thisWeekend);
                }
              },
            ),
            DateQuickChip(
              label: 'Cette semaine',
              isSelected: widget.filter.dateFilterType == DateFilterType.thisWeek,
              onTap: () {
                if (widget.filter.dateFilterType == DateFilterType.thisWeek) {
                  filterNotifier.clearDateFilter();
                } else {
                  filterNotifier.setDateFilter(DateFilterType.thisWeek);
                }
              },
            ),
            DateQuickChip(
              label: 'Ce mois',
              isSelected: widget.filter.dateFilterType == DateFilterType.thisMonth,
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
                  ? const Color(0xFFFF601F).withValues(alpha: 0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.filter.dateFilterType == DateFilterType.custom
                    ? const Color(0xFFFF601F)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 18,
                  color: widget.filter.dateFilterType == DateFilterType.custom
                      ? const Color(0xFFFF601F)
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dates personnalisées',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.filter.dateFilterType == DateFilterType.custom
                          ? const Color(0xFFFF601F)
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                Icon(
                  _showCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),

        // Mini Calendar
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _showCalendar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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

class _WhatContent extends ConsumerWidget {
  final EventFilter filter;

  const _WhatContent({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final filterOptions = ref.watch(filterOptionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Catégories
        if (filterOptions.categories.isNotEmpty) ...[
          Text(
            'CATÉGORIES',
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
            children: filterOptions.categories.take(8).map((cat) {
              final isSelected = filter.categoriesSlugs.contains(cat.slug);
              return SelectableChip(
                label: cat.name,
                isSelected: isSelected,
                onTap: () => filterNotifier.toggleCategory(cat.slug),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Filtres
        Text(
          'FILTRES',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        // Toggles
        ToggleRow(
          title: 'En famille',
          subtitle: 'Activités adaptées aux enfants',
          icon: Icons.family_restroom,
          isSelected: filter.familyFriendly,
          onTap: () => filterNotifier.setFamilyFriendly(!filter.familyFriendly),
        ),

        const Divider(height: 20),

        ToggleRow(
          title: 'Gratuit',
          subtitle: 'Activités sans frais',
          icon: Icons.local_offer_outlined,
          isSelected: filter.onlyFree,
          onTap: () => filterNotifier.setOnlyFree(!filter.onlyFree),
        ),

        const Divider(height: 20),

        ToggleRow(
          title: 'Accessible PMR',
          subtitle: 'Mobilité réduite',
          icon: Icons.accessible,
          isSelected: filter.accessiblePMR,
          onTap: () => filterNotifier.setAccessiblePMR(!filter.accessiblePMR),
        ),

        const Divider(height: 20),

        ToggleRow(
          title: 'En ligne',
          subtitle: 'Activités virtuelles',
          icon: Icons.videocam_outlined,
          isSelected: filter.onlineOnly,
          onTap: () => filterNotifier.setOnlineOnly(!filter.onlineOnly),
        ),
      ],
    );
  }
}
