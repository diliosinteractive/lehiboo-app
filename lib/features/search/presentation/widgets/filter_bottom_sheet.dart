import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/themes/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../../../events/data/models/event_reference_data_dto.dart';
import '../../../home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/search/presentation/widgets/category_cascade.dart';

/// Show the filter bottom sheet
Future<void> showFilterBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  );
}

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late EventFilter _tempFilter;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _tempFilter = ref.read(eventFilterProvider);
  }

  /// Compte les filtres actifs pour le badge
  int get _activeFilterCount {
    int count = 0;
    if (_tempFilter.searchQuery.isNotEmpty) {
      count++;
    }
    if (_tempFilter.dateFilterType != null || _tempFilter.startDate != null) {
      count++;
    }
    if (_tempFilter.onlyFree ||
        _tempFilter.priceMin > 0 ||
        _tempFilter.priceMax < 500) {
      count++;
    }
    if (_tempFilter.citySlug != null) {
      count++;
    }
    if (_tempFilter.latitude != null) {
      count++;
    }
    count += _tempFilter.thematiquesSlugs.length;
    count += _tempFilter.categoriesSlugs.length;
    count += _tempFilter.targetAudienceSlugs.length;
    if (_tempFilter.eventTagSlug != null) count++;
    count += _tempFilter.specialEventSlugs.length;
    count += _tempFilter.emotionSlugs.length;
    if (_tempFilter.availableOnly) count++;
    if (_tempFilter.locationType != null) count++;
    if (_tempFilter.familyFriendly) count++;
    if (_tempFilter.accessiblePMR) count++;
    if (_tempFilter.onlineOnly) count++;
    if (_tempFilter.inPersonOnly) count++;
    if (_tempFilter.hasExplicitSort) count++;
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

      setState(() {
        _tempFilter = _tempFilter.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          radiusKm: _tempFilter.radiusKm,
          citySlug: null,
          cityName: null,
        );
      });
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final referenceDataAsync = ref.watch(eventReferenceDataProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: HbColors.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header style Airbnb
              _buildHeader(filterNotifier),
              // Filter sections
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  children: [
                    _FilterCard(
                      child: _SearchFilterSection(
                        query: _tempFilter.searchQuery,
                        onChanged: (query) {
                          setState(() {
                            _tempFilter =
                                _tempFilter.copyWith(searchQuery: query);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 1. Section Localisation (NOUVELLE)
                    _FilterCard(
                      child: _LocationFilterSection(
                        filter: _tempFilter,
                        isLoadingLocation: _isLoadingLocation,
                        onLocationTap: _getCurrentLocation,
                        onClearLocation: () {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              latitude: null,
                              longitude: null,
                            );
                          });
                        },
                        onRadiusChanged: (radius) {
                          setState(() {
                            _tempFilter =
                                _tempFilter.copyWith(radiusKm: radius);
                          });
                        },
                        onCityRadiusChanged: (radius) {
                          setState(() {
                            _tempFilter =
                                _tempFilter.copyWith(cityRadiusKm: radius);
                          });
                        },
                        onCitySelected: (slug, name) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              citySlug: slug,
                              cityName: name,
                              cityRadiusKm: 10,
                              latitude: null,
                              longitude: null,
                            );
                          });
                        },
                        onClearCity: () {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              citySlug: null,
                              cityName: null,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 2. Section Date améliorée
                    _FilterCard(
                      child: _DateFilterSection(
                        selectedType: _tempFilter.dateFilterType,
                        startDate: _tempFilter.startDate,
                        endDate: _tempFilter.endDate,
                        onTypeChanged: (type) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              dateFilterType: type,
                              startDate: null,
                              endDate: null,
                            );
                          });
                        },
                        onCustomDateSelected: (start, end) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              dateFilterType: DateFilterType.custom,
                              startDate: start,
                              endDate: end,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 3. Section Budget
                    _FilterCard(
                      child: _PriceFilterSection(
                        onlyFree: _tempFilter.onlyFree,
                        priceMin: _tempFilter.priceMin,
                        priceMax: _tempFilter.priceMax,
                        onFreeChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(onlyFree: value);
                          });
                        },
                        onRangeChanged: (min, max) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              priceMin: min,
                              priceMax: max,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...referenceDataAsync.when<List<Widget>>(
                      data: (referenceData) => [
                        if (referenceData.categories.isNotEmpty) ...[
                          _FilterCard(
                            child: _CategoriesFilterSection(
                              selectedSlugs: _tempFilter.categoriesSlugs,
                              categories: referenceData.categories,
                              onChanged: (slugs) {
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(
                                      categoriesSlugs: slugs);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (referenceData.themes.isNotEmpty) ...[
                          _FilterCard(
                            child: _ReferenceMultiSelectSection(
                              title: 'Thématiques',
                              icon: Icons.category,
                              selectedSlugs: _tempFilter.thematiquesSlugs,
                              options: referenceData.themes,
                              onChanged: (slugs) {
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(
                                    thematiquesSlugs: slugs,
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        _FilterCard(
                          child: _AudienceFilterSection(
                            familyFriendly: _tempFilter.familyFriendly,
                            accessiblePMR: _tempFilter.accessiblePMR,
                            selectedAudienceSlugs:
                                _tempFilter.targetAudienceSlugs,
                            audienceGroups: referenceData.audienceGroups,
                            onFamilyChanged: (value) {
                              setState(() {
                                _tempFilter =
                                    _tempFilter.copyWith(familyFriendly: value);
                              });
                            },
                            onPMRChanged: (value) {
                              setState(() {
                                _tempFilter =
                                    _tempFilter.copyWith(accessiblePMR: value);
                              });
                            },
                            onTargetAudiencesChanged: (slugs) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(
                                  targetAudienceSlugs: slugs,
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (referenceData.eventTags.isNotEmpty) ...[
                          _FilterCard(
                            child: _ReferenceSingleSelectSection(
                              title: "Type d'événement",
                              icon: Icons.local_activity,
                              selectedSlug: _tempFilter.eventTagSlug,
                              options: referenceData.eventTags,
                              onChanged: (slug) {
                                setState(() {
                                  _tempFilter =
                                      _tempFilter.copyWith(eventTagSlug: slug);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                      loading: () => [
                        const _FilterCard(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: HbColors.brandPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      error: (_, __) => const [],
                    ),
                    const SizedBox(height: 12),
                    // 7. Section Format
                    _FilterCard(
                      child: _FormatFilterSection(
                        onlineOnly: _tempFilter.onlineOnly,
                        inPersonOnly: _tempFilter.inPersonOnly,
                        onOnlineChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              onlineOnly: value,
                              inPersonOnly:
                                  value ? false : _tempFilter.inPersonOnly,
                            );
                          });
                        },
                        onInPersonChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              inPersonOnly: value,
                              onlineOnly:
                                  value ? false : _tempFilter.onlineOnly,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FilterCard(
                      child: _AvailabilityFilterSection(
                        availableOnly: _tempFilter.availableOnly,
                        onChanged: (value) {
                          setState(() {
                            _tempFilter =
                                _tempFilter.copyWith(availableOnly: value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FilterCard(
                      child: _LocationTypeFilterSection(
                        selectedType: _tempFilter.locationType,
                        onChanged: (type) {
                          setState(() {
                            _tempFilter =
                                _tempFilter.copyWith(locationType: type);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...referenceDataAsync.when<List<Widget>>(
                      data: (referenceData) => [
                        if (referenceData.specialEvents.isNotEmpty) ...[
                          _FilterCard(
                            child: _ReferenceMultiSelectSection(
                              title: 'Temps forts',
                              icon: Icons.celebration,
                              selectedSlugs: _tempFilter.specialEventSlugs,
                              options: referenceData.specialEvents,
                              onChanged: (slugs) {
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(
                                    specialEventSlugs: slugs,
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (referenceData.emotions.isNotEmpty) ...[
                          _FilterCard(
                            child: _ReferenceMultiSelectSection(
                              title: 'Ambiance',
                              icon: Icons.mood,
                              selectedSlugs: _tempFilter.emotionSlugs,
                              options: referenceData.emotions,
                              onChanged: (slugs) {
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(
                                    emotionSlugs: slugs,
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                      loading: () => const [],
                      error: (_, __) => const [],
                    ),
                    // 8. Section Tri
                    // 8. Section Tri
                    _FilterCard(
                      child: _SortFilterSection(
                        selectedSort: _tempFilter.effectiveSortBy,
                        onChanged: (sort) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              sortBy: sort,
                              hasExplicitSort: true,
                            );
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 100 + bottomPadding),
                  ],
                ),
              ),
              // Footer sticky amélioré
              _buildFooter(filterNotifier, bottomPadding),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(EventFilterNotifier filterNotifier) {
    return Container(
      decoration: BoxDecoration(
        color: HbColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          // Close button style Airbnb (cercle avec bordure)
          IconButton(
            onPressed: () => Navigator.pop(context),
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
            'Filtres',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          // Bouton Effacer souligné
          GestureDetector(
            onTap: () {
              filterNotifier.resetAll();
              setState(() => _tempFilter = const EventFilter());
            },
            child: Text(
              'Effacer',
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: HbColors.brandPrimary,
                decoration: TextDecoration.underline,
                decorationColor: HbColors.brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
      EventFilterNotifier filterNotifier, double bottomPadding) {
    final previewCount = ref.watch(
      filterPreviewCountProvider(_tempFilter.copyWith(page: 1, perPage: 1)),
    );
    final actionLabel = previewCount.when(
      data: (count) => 'Rechercher · $count activité${count > 1 ? 's' : ''}',
      loading: () => 'Rechercher',
      error: (_, __) => 'Rechercher',
    );

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            filterNotifier.applyFilters(_tempFilter);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [HbColors.brandPrimary, HbColors.brandPrimaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: HbColors.brandPrimary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionLabel,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_activeFilterCount > 0) ...[
                  const SizedBox(width: 10),
                  // Badge compteur
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_activeFilterCount',
                      style: GoogleFonts.montserrat(
                        color: HbColors.brandPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FILTER CARD - Container blanc avec ombre pour chaque section
// =============================================================================

class _FilterCard extends StatelessWidget {
  final Widget child;

  const _FilterCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

// =============================================================================
// SECTION TITLE - Titre de section uniforme
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: HbColors.brandPrimary),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: HbColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _SearchFilterSection extends StatefulWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const _SearchFilterSection({
    required this.query,
    required this.onChanged,
  });

  @override
  State<_SearchFilterSection> createState() => _SearchFilterSectionState();
}

class _SearchFilterSectionState extends State<_SearchFilterSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _SearchFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Recherche', icon: Icons.search),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Événement ou organisation',
            prefixIcon: const Icon(Icons.search, color: HbColors.brandPrimary),
            suffixIcon: widget.query.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                    icon: Icon(Icons.close, color: Colors.grey.shade500),
                  ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: HbColors.brandPrimary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION LOCALISATION (NOUVELLE)
// =============================================================================

class _LocationFilterSection extends ConsumerStatefulWidget {
  final EventFilter filter;
  final bool isLoadingLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onClearLocation;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<double> onCityRadiusChanged;
  final void Function(String slug, String name) onCitySelected;
  final VoidCallback onClearCity;

  const _LocationFilterSection({
    required this.filter,
    required this.isLoadingLocation,
    required this.onLocationTap,
    required this.onClearLocation,
    required this.onRadiusChanged,
    required this.onCityRadiusChanged,
    required this.onCitySelected,
    required this.onClearCity,
  });

  @override
  ConsumerState<_LocationFilterSection> createState() =>
      _LocationFilterSectionState();
}

class _LocationFilterSectionState
    extends ConsumerState<_LocationFilterSection> {
  final TextEditingController _citySearchController = TextEditingController();
  String _cityQuery = '';

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = widget.filter;
    final hasLocation = filter.latitude != null;
    final hasCity = filter.citySlug != null;
    final citiesAsync = ref.watch(homeCitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Localisation', icon: Icons.location_on),
        const SizedBox(height: 20),

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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hasLocation
                        ? HbColors.brandPrimary.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12),
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
                          size: 24,
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À proximité',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        hasLocation
                            ? 'Dans un rayon de ${filter.radiusKm.toInt()} km'
                            : 'Utiliser ma position actuelle',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLocation)
                  IconButton(
                    onPressed: widget.onClearLocation,
                    icon: Icon(Icons.close,
                        size: 20, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ),

        // Slider rayon (visible si géoloc active)
        if (hasLocation) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Rayon : ',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${filter.radiusKm.toInt()} km',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: HbColors.brandPrimary,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: HbColors.brandPrimary,
              overlayColor: HbColors.brandPrimary.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: filter.radiusKm,
              min: 5,
              max: 100,
              divisions: 19,
              onChanged: widget.onRadiusChanged,
            ),
          ),
        ],

        const SizedBox(height: 20),

        TextField(
          controller: _citySearchController,
          onChanged: (value) => setState(() => _cityQuery = value.trim()),
          decoration: InputDecoration(
            hintText: 'Rechercher une ville',
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
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: HbColors.brandPrimary, width: 2),
            ),
          ),
        ),

        if (hasCity) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rayon autour de ${filter.cityName ?? filter.citySlug}',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Text(
                '${filter.cityRadiusKm.toInt()} km',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [5, 10, 20, 50].map((radius) {
              return _SelectableChip(
                label: '$radius km',
                icon: Icons.radar,
                isSelected: filter.cityRadiusKm.toInt() == radius,
                onTap: () => widget.onCityRadiusChanged(radius.toDouble()),
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 20),

        // Villes populaires
        Text(
          _cityQuery.isEmpty ? 'VILLES POPULAIRES' : 'RÉSULTATS',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        citiesAsync.when(
          data: (cities) {
            final normalizedQuery = _cityQuery.toLowerCase();
            final displayedCities = normalizedQuery.isEmpty
                ? cities.take(6).toList()
                : cities
                    .where(
                      (city) =>
                          city.name.toLowerCase().contains(normalizedQuery) ||
                          city.slug.toLowerCase().contains(normalizedQuery),
                    )
                    .take(10)
                    .toList();

            if (displayedCities.isEmpty) {
              return Text(
                'Aucune ville trouvée',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              );
            }

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: displayedCities.map((city) {
                final isSelected = filter.citySlug == city.slug;
                return _SelectableChip(
                  label: city.name,
                  icon: Icons.location_city,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) {
                      widget.onClearCity();
                    } else {
                      widget.onCitySelected(city.slug, city.name);
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
          error: (_, __) => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ('Paris', 'paris'),
              ('Lyon', 'lyon'),
              ('Marseille', 'marseille'),
              ('Bordeaux', 'bordeaux'),
              ('Toulouse', 'toulouse'),
              ('Nantes', 'nantes'),
            ].map((city) {
              final isSelected = filter.citySlug == city.$2;
              return _SelectableChip(
                label: city.$1,
                icon: Icons.location_city,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    widget.onClearCity();
                  } else {
                    widget.onCitySelected(city.$2, city.$1);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION DATE AMELIOREE
// =============================================================================

class _DateFilterSection extends StatefulWidget {
  final DateFilterType? selectedType;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateFilterType?> onTypeChanged;
  final void Function(DateTime start, DateTime? end) onCustomDateSelected;

  const _DateFilterSection({
    required this.selectedType,
    required this.startDate,
    required this.endDate,
    required this.onTypeChanged,
    required this.onCustomDateSelected,
  });

  @override
  State<_DateFilterSection> createState() => _DateFilterSectionState();
}

class _DateFilterSectionState extends State<_DateFilterSection> {
  bool _showCalendar = false;

  String _formatDateRange() {
    if (widget.startDate == null) return '';
    final formatter = DateFormat('d MMM', 'fr_FR');
    if (widget.endDate == null || widget.startDate == widget.endDate) {
      return formatter.format(widget.startDate!);
    }
    return '${formatter.format(widget.startDate!)} - ${formatter.format(widget.endDate!)}';
  }

  @override
  Widget build(BuildContext context) {
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
        const _SectionTitle(title: 'Date', icon: Icons.calendar_today),
        const SizedBox(height: 16),

        // Quick date chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _DateQuickChip(
              label: "Aujourd'hui",
              subtitle: DateFormat('d MMM', 'fr_FR').format(today),
              isSelected: widget.selectedType == DateFilterType.today,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.today
                    ? null
                    : DateFilterType.today,
              ),
            ),
            _DateQuickChip(
              label: 'Demain',
              subtitle: DateFormat('d MMM', 'fr_FR').format(tomorrow),
              isSelected: widget.selectedType == DateFilterType.tomorrow,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.tomorrow
                    ? null
                    : DateFilterType.tomorrow,
              ),
            ),
            _DateQuickChip(
              label: 'Ce week-end',
              subtitle:
                  '${DateFormat('d').format(saturday)}-${DateFormat('d MMM', 'fr_FR').format(sunday)}',
              isSelected: widget.selectedType == DateFilterType.thisWeekend,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.thisWeekend
                    ? null
                    : DateFilterType.thisWeekend,
              ),
            ),
            _DateQuickChip(
              label: 'Cette semaine',
              isSelected: widget.selectedType == DateFilterType.thisWeek,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.thisWeek
                    ? null
                    : DateFilterType.thisWeek,
              ),
            ),
            _DateQuickChip(
              label: 'Ce mois',
              isSelected: widget.selectedType == DateFilterType.thisMonth,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.thisMonth
                    ? null
                    : DateFilterType.thisMonth,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Bouton dates personnalisées
        GestureDetector(
          onTap: () => setState(() => _showCalendar = !_showCalendar),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.selectedType == DateFilterType.custom
                  ? HbColors.brandPrimary.withValues(alpha: 0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.selectedType == DateFilterType.custom
                    ? HbColors.brandPrimary
                    : Colors.grey.shade200,
                width: widget.selectedType == DateFilterType.custom ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: widget.selectedType == DateFilterType.custom
                      ? HbColors.brandPrimary
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selectedType == DateFilterType.custom &&
                            widget.startDate != null
                        ? _formatDateRange()
                        : 'Choisir des dates personnalisées',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: widget.selectedType == DateFilterType.custom
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: widget.selectedType == DateFilterType.custom
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

        // Mini Calendar (visible si ouvert)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _showCalendar
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _MiniCalendar(
              selectedStartDate: widget.startDate,
              selectedEndDate: widget.endDate,
              onDateSelected: widget.onCustomDateSelected,
            ),
          ),
          secondChild: const SizedBox(height: 0),
        ),
      ],
    );
  }
}

class _DateQuickChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateQuickChip({
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: subtitle != null ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: isSelected ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniCalendar extends StatefulWidget {
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final void Function(DateTime start, DateTime? end) onDateSelected;

  const _MiniCalendar({
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onDateSelected,
  });

  @override
  State<_MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<_MiniCalendar> {
  late DateTime _currentMonth;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _rangeStart = widget.selectedStartDate;
    _rangeEnd = widget.selectedEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = (firstDayOfMonth.weekday - 1) % 7;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.grey.shade700),
                onPressed: () {
                  setState(() {
                    _currentMonth =
                        DateTime(_currentMonth.year, _currentMonth.month - 1);
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy', 'fr_FR').format(_currentMonth),
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.grey.shade700),
                onPressed: () {
                  setState(() {
                    _currentMonth =
                        DateTime(_currentMonth.year, _currentMonth.month + 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekday headers
          Row(
            children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayNumber = index - startingWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final date =
                  DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isPast = date.isBefore(todayDate);
              final isToday = date.isAtSameMomentAs(todayDate);
              final isSelected = _isDateSelected(date);
              final isInRange = _isDateInRange(date);

              return GestureDetector(
                onTap: isPast ? null : () => _onDateTap(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? HbColors.brandPrimary
                        : isInRange
                            ? HbColors.brandPrimary.withValues(alpha: 0.15)
                            : null,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: HbColors.brandPrimary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: isToday || isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isPast
                            ? Colors.grey.shade300
                            : isSelected
                                ? Colors.white
                                : isToday
                                    ? HbColors.brandPrimary
                                    : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isDateSelected(DateTime date) {
    if (_rangeStart != null && _isSameDay(date, _rangeStart!)) return true;
    if (_rangeEnd != null && _isSameDay(date, _rangeEnd!)) return true;
    return false;
  }

  bool _isDateInRange(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = date;
        _rangeEnd = null;
      } else {
        if (date.isBefore(_rangeStart!)) {
          _rangeEnd = _rangeStart;
          _rangeStart = date;
        } else {
          _rangeEnd = date;
        }
      }
    });

    widget.onDateSelected(_rangeStart!, _rangeEnd);
  }
}

// =============================================================================
// SECTION BUDGET
// =============================================================================

class _PriceFilterSection extends StatelessWidget {
  final bool onlyFree;
  final double priceMin;
  final double priceMax;
  final ValueChanged<bool> onFreeChanged;
  final void Function(double, double) onRangeChanged;

  static const double _sliderMin = 0;
  static const double _sliderMax = 500;

  const _PriceFilterSection({
    required this.onlyFree,
    required this.priceMin,
    required this.priceMax,
    required this.onFreeChanged,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final clampedMin = priceMin.clamp(_sliderMin, _sliderMax);
    final clampedMax = priceMax.clamp(_sliderMin, _sliderMax);
    final validMin = clampedMin <= clampedMax ? clampedMin : _sliderMin;
    final validMax = clampedMax >= clampedMin ? clampedMax : _sliderMax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Budget', icon: Icons.euro),
        const SizedBox(height: 16),

        // Toggle gratuit
        _ToggleRow(
          title: 'Gratuit uniquement',
          subtitle: 'Afficher seulement les activités gratuites',
          icon: Icons.local_offer,
          isSelected: onlyFree,
          onTap: () => onFreeChanged(!onlyFree),
        ),

        if (!onlyFree) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fourchette de prix',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${validMin.toInt()}€ - ${validMax.toInt()}€${validMax >= _sliderMax ? '+' : ''}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: HbColors.brandPrimary,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: HbColors.brandPrimary,
              overlayColor: HbColors.brandPrimary.withValues(alpha: 0.2),
              trackHeight: 4,
              rangeThumbShape:
                  const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: RangeSlider(
              values: RangeValues(validMin, validMax),
              min: _sliderMin,
              max: _sliderMax,
              divisions: 50,
              onChanged: (values) {
                onRangeChanged(values.start, values.end);
              },
            ),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// SECTION CATEGORIES
// =============================================================================

class _CategoriesFilterSection extends StatefulWidget {
  final List<String> selectedSlugs;
  final List<EventReferenceCategoryDto> categories;
  final ValueChanged<List<String>> onChanged;

  const _CategoriesFilterSection({
    required this.selectedSlugs,
    required this.categories,
    required this.onChanged,
  });

  @override
  State<_CategoriesFilterSection> createState() =>
      _CategoriesFilterSectionState();
}

class _CategoriesFilterSectionState extends State<_CategoriesFilterSection> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return const SizedBox();

    final displayedCategories = _filteredCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Catégories', icon: Icons.grid_view_rounded),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value.trim()),
          decoration: InputDecoration(
            hintText: 'Rechercher une catégorie',
            prefixIcon: const Icon(Icons.search, color: HbColors.brandPrimary),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: HbColors.brandPrimary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...displayedCategories.map(_buildCategoryGroup),
        if (displayedCategories.isEmpty)
          Text(
            'Aucune catégorie trouvée',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  List<EventReferenceCategoryDto> _filteredCategories() {
    if (_query.isEmpty) return widget.categories;
    final normalized = _query.toLowerCase();

    return widget.categories.where((category) {
      final matchesParent = category.name.toLowerCase().contains(normalized) ||
          category.slug.toLowerCase().contains(normalized);
      final matchesChild = category.children.any(
        (child) =>
            child.name.toLowerCase().contains(normalized) ||
            child.slug.toLowerCase().contains(normalized),
      );
      return matchesParent || matchesChild;
    }).toList();
  }

  Widget _buildCategoryGroup(EventReferenceCategoryDto category) {
    final visibleChildren = _query.isEmpty
        ? category.children
        : category.children.where((child) {
            final normalized = _query.toLowerCase();
            return child.name.toLowerCase().contains(normalized) ||
                child.slug.toLowerCase().contains(normalized);
          }).toList();
    final isSelected = widget.selectedSlugs.contains(category.slug);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SelectableChip(
            label: _labelWithCount(category.name, category.eventCount),
            icon: _iconForReference(category.icon, category.slug),
            isSelected: isSelected,
            onTap: () => _toggleParent(category),
          ),
          if (visibleChildren.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: visibleChildren.map((child) {
                  final isChildSelected =
                      widget.selectedSlugs.contains(child.slug);
                  return _SelectableChip(
                    label: _labelWithCount(child.name, child.eventCount),
                    icon: _iconForReference(child.icon, child.slug),
                    isSelected: isChildSelected,
                    onTap: () => _toggleChild(child.slug),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _toggleChild(String slug) {
    final newList = List<String>.from(widget.selectedSlugs);
    if (newList.contains(slug)) {
      newList.remove(slug);
    } else {
      newList.add(slug);
    }
    widget.onChanged(newList);
  }

  void _toggleParent(EventReferenceCategoryDto category) {
    final childSlugs = category.children.map((c) => c.slug).toList();
    final newList = cascadeParentSelection(
      currentSlugs: widget.selectedSlugs,
      parentSlug: category.slug,
      childSlugs: childSlugs,
    );
    widget.onChanged(newList);
  }
}

class _ReferenceMultiSelectSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> selectedSlugs;
  final List<EventReferenceOptionDto> options;
  final ValueChanged<List<String>> onChanged;

  const _ReferenceMultiSelectSection({
    required this.title,
    required this.icon,
    required this.selectedSlugs,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: title, icon: icon),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedSlugs.contains(option.slug);

            return _SelectableChip(
              label: _labelWithCount(option.name, option.eventCount),
              icon: _iconForReference(option.icon, option.slug),
              isSelected: isSelected,
              onTap: () {
                final newList = List<String>.from(selectedSlugs);
                if (isSelected) {
                  newList.remove(option.slug);
                } else {
                  newList.add(option.slug);
                }
                onChanged(newList);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ReferenceSingleSelectSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? selectedSlug;
  final List<EventReferenceOptionDto> options;
  final ValueChanged<String?> onChanged;

  const _ReferenceSingleSelectSection({
    required this.title,
    required this.icon,
    required this.selectedSlug,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: title, icon: icon),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedSlug == option.slug;

            return _SelectableChip(
              label: _labelWithCount(option.name, option.eventCount),
              icon: _iconForReference(option.icon, option.slug),
              isSelected: isSelected,
              onTap: () => onChanged(isSelected ? null : option.slug),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION PUBLIC
// =============================================================================

class _AudienceFilterSection extends StatelessWidget {
  final bool familyFriendly;
  final bool accessiblePMR;
  final List<String> selectedAudienceSlugs;
  final List<EventReferenceAudienceGroupDto> audienceGroups;
  final ValueChanged<bool> onFamilyChanged;
  final ValueChanged<bool> onPMRChanged;
  final ValueChanged<List<String>> onTargetAudiencesChanged;

  const _AudienceFilterSection({
    required this.familyFriendly,
    required this.accessiblePMR,
    required this.selectedAudienceSlugs,
    required this.audienceGroups,
    required this.onFamilyChanged,
    required this.onPMRChanged,
    required this.onTargetAudiencesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Public', icon: Icons.people),
        const SizedBox(height: 16),
        _ToggleRow(
          title: 'En famille',
          subtitle: 'Activités adaptées aux enfants',
          icon: Icons.family_restroom,
          isSelected: familyFriendly,
          onTap: () => onFamilyChanged(!familyFriendly),
        ),
        const Divider(height: 24),
        _ToggleRow(
          title: 'Accessible PMR',
          subtitle: 'Accessibilité mobilité réduite',
          icon: Icons.accessible,
          isSelected: accessiblePMR,
          onTap: () => onPMRChanged(!accessiblePMR),
        ),
        if (audienceGroups.isNotEmpty) ...[
          const Divider(height: 24),
          ...audienceGroups.map((group) {
            if (group.audiences.isEmpty) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: group.audiences.map((audience) {
                      final isSelected =
                          selectedAudienceSlugs.contains(audience.slug);
                      return _SelectableChip(
                        label: audience.name,
                        icon: Icons.groups,
                        isSelected: isSelected,
                        onTap: () {
                          final newList =
                              List<String>.from(selectedAudienceSlugs);
                          if (isSelected) {
                            newList.remove(audience.slug);
                          } else {
                            newList.add(audience.slug);
                          }
                          onTargetAudiencesChanged(newList);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}

// =============================================================================
// SECTION FORMAT
// =============================================================================

class _FormatFilterSection extends StatelessWidget {
  final bool onlineOnly;
  final bool inPersonOnly;
  final ValueChanged<bool> onOnlineChanged;
  final ValueChanged<bool> onInPersonChanged;

  const _FormatFilterSection({
    required this.onlineOnly,
    required this.inPersonOnly,
    required this.onOnlineChanged,
    required this.onInPersonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Format', icon: Icons.videocam),
        const SizedBox(height: 16),
        _ToggleRow(
          title: 'En ligne',
          subtitle: 'Activités virtuelles',
          icon: Icons.videocam_outlined,
          isSelected: onlineOnly,
          onTap: () => onOnlineChanged(!onlineOnly),
        ),
        const Divider(height: 24),
        _ToggleRow(
          title: 'En présentiel',
          subtitle: 'Activités sur place',
          icon: Icons.location_on_outlined,
          isSelected: inPersonOnly,
          onTap: () => onInPersonChanged(!inPersonOnly),
        ),
      ],
    );
  }
}

class _AvailabilityFilterSection extends StatelessWidget {
  final bool availableOnly;
  final ValueChanged<bool> onChanged;

  const _AvailabilityFilterSection({
    required this.availableOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
            title: 'Disponibilités', icon: Icons.event_available),
        const SizedBox(height: 16),
        _ToggleRow(
          title: 'Places disponibles',
          subtitle: 'Masquer les activités complètes',
          icon: Icons.confirmation_number_outlined,
          isSelected: availableOnly,
          onTap: () => onChanged(!availableOnly),
        ),
      ],
    );
  }
}

class _LocationTypeFilterSection extends StatelessWidget {
  final LocationTypeFilter? selectedType;
  final ValueChanged<LocationTypeFilter?> onChanged;

  const _LocationTypeFilterSection({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Type de lieu', icon: Icons.place),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SelectableChip(
              label: 'Lieu physique',
              icon: Icons.storefront,
              isSelected: selectedType == LocationTypeFilter.physical,
              onTap: () => onChanged(
                selectedType == LocationTypeFilter.physical
                    ? null
                    : LocationTypeFilter.physical,
              ),
            ),
            _SelectableChip(
              label: 'Hors ligne',
              icon: Icons.location_on_outlined,
              isSelected: selectedType == LocationTypeFilter.offline,
              onTap: () => onChanged(
                selectedType == LocationTypeFilter.offline
                    ? null
                    : LocationTypeFilter.offline,
              ),
            ),
            _SelectableChip(
              label: 'En ligne',
              icon: Icons.videocam_outlined,
              isSelected: selectedType == LocationTypeFilter.online,
              onTap: () => onChanged(
                selectedType == LocationTypeFilter.online
                    ? null
                    : LocationTypeFilter.online,
              ),
            ),
            _SelectableChip(
              label: 'Hybride',
              icon: Icons.sync_alt,
              isSelected: selectedType == LocationTypeFilter.hybrid,
              onTap: () => onChanged(
                selectedType == LocationTypeFilter.hybrid
                    ? null
                    : LocationTypeFilter.hybrid,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION TRI
// =============================================================================

class _SortFilterSection extends StatelessWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption> onChanged;

  const _SortFilterSection({
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Trier par', icon: Icons.sort),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SelectableChip(
              label: 'Pertinence',
              isSelected: selectedSort == SortOption.relevance,
              onTap: () => onChanged(SortOption.relevance),
            ),
            _SelectableChip(
              label: 'Date (proche)',
              isSelected: selectedSort == SortOption.dateAsc,
              onTap: () => onChanged(SortOption.dateAsc),
            ),
            _SelectableChip(
              label: 'Distance',
              isSelected: selectedSort == SortOption.distance,
              onTap: () => onChanged(SortOption.distance),
            ),
            _SelectableChip(
              label: 'Prix croissant',
              isSelected: selectedSort == SortOption.priceAsc,
              onTap: () => onChanged(SortOption.priceAsc),
            ),
            _SelectableChip(
              label: 'Prix décroissant',
              isSelected: selectedSort == SortOption.priceDesc,
              onTap: () => onChanged(SortOption.priceDesc),
            ),
            _SelectableChip(
              label: 'Popularité',
              isSelected: selectedSort == SortOption.popularity,
              onTap: () => onChanged(SortOption.popularity),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// COMPOSANTS REUTILISABLES
// =============================================================================

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

/// Chip sélectionnable amélioré avec animation
class _SelectableChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    this.icon,
    required this.isSelected,
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
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HbColors.brandPrimary.withValues(alpha: 0.25),
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
              style: GoogleFonts.montserrat(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Toggle row style Airbnb avec switch custom
class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // Icon container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? HbColors.brandPrimary.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? HbColors.brandPrimary : Colors.grey.shade600,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Custom toggle switch
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? HbColors.brandPrimary : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment:
                  isSelected ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
